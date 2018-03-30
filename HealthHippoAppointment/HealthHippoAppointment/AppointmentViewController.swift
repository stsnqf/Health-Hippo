//
//  AppointmentViewController.swift
//  HealthHippoAppointment
//
//  Created by Matthew Romero Moore on 12/11/16.
//  Copyright © 2016 Matthew Romero Moore. All rights reserved.
//

import UIKit
import CoreData

class AppointmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AudioRecorderViewControllerDelegate {
    
    var questions = ["Do I need to renew or change a medication?", "Do I need any medical tests done?", "What is my diagnosis?", "What are my treatment options?", "What are the side effects?", "Do I need any tests?", "What will that test do?", "What will the test results tell me?", "What medication are you prescribing me?", "How do I take the medication?", "Why do I need surgery?", "Are there any other treatment options?", "Are there any changes I need to make to my daily routine?"]
    
    func audioRecorderViewControllerDismissed(withFileURL fileURL: URL?) {
        // do something with fileURL
        dismiss(animated: true, completion: nil)
    }
  
    @IBAction func presentAudioRecorder(_ sender: Any) {
        
        let controller = AudioRecorderViewController()
        controller.audioRecorderDelegate = self
        present(controller, animated: true, completion: nil)
        
    }
    var newAppointment: Appointment?
    
    var selectedQuestions : [String] = []
    var selectedDate: Date?
    var appointment: String?
    var doctor: String?
    var symptoms: String?
    var diagnosis: String?
    
    var appointmentTextField: UITextField?
    var doctorTextField: UITextField?
    var datePicker : UIDatePicker?
    var symptomsTextView: UITextView?
    var questionsLabel: UILabel?
    var diagnosisTextField: UITextField?
    var appointmentLabel: UILabel?
    var doctorLabel: UILabel?
    var selectedDateLabel: UILabel?
    
    var activeTextField: UITextField? = nil
    
    var selectedSegmentIndex = 0

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsMultipleSelection = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(AppointmentViewController.saveAppointment))

        
        selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        
        navigationController?.setToolbarHidden(true, animated: false)
        self.view.backgroundColor = UIColor(red: 94/255, green: 177/255, blue: 217/255, alpha: 1.0)
        
               // print("\(self.newAppointment?.appointmentName)")
        
        if let newAppointment = newAppointment {
            doctorTextField?.text = newAppointment.doctorName
            symptomsTextView?.text = newAppointment.symptoms
            questionsLabel?.text = newAppointment.questions
            datePicker?.date = newAppointment.date as! Date
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveAppointment() {
        
        let context = getContext()
        
        if newAppointment == nil {
            newAppointment = Appointment(context: context)
        }
        
        
        if let appointmentThing = newAppointment {
        
            
            appointmentThing.appointmentName = appointmentTextField?.text
            appointmentThing.doctorName = doctorTextField?.text
            appointmentThing.date = datePicker?.date as NSDate?
            appointmentThing.symptoms = symptomsTextView?.text
            appointmentThing.diagnosis = diagnosisTextField?.text 
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (selectedSegmentIndex == 0) {
            return 3
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (selectedSegmentIndex == 0) {
            switch section {
            case 0:
                return 3
            case 1:
                return 1
            case 2:
                return questions.count
            default:
                return 0
            }
        } else if (selectedSegmentIndex == 1) {
            switch section {
            case 0:
                return 3
            case 1:
                return 1
            case 2:
                return selectedQuestions.count
            default:
                return 0
            }
        } else {
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return selectedQuestions.count
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Basic Info"
        case 1:
            return "Symptoms"
        case 2:
            return "Questions"
        default:
            return ""
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (selectedSegmentIndex == 0) {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentcell", for: indexPath) as! AppointmentTableViewCell
                    cell.appointmentTextField.delegate = self  // this is needed to implement methods to make the keyboard go away when enter is pressed
                    
                    if let newAppointment = newAppointment{
                        appointment = newAppointment.appointmentName
                    }
                    
                    cell.appointmentTextField.text = appointment
                    
                    appointmentTextField = cell.appointmentTextField
              
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "doctorcell", for: indexPath) as! DoctorTableViewCell
                    cell.doctorTextField.delegate = self
                    
                    if let newAppointment = newAppointment{
                        doctor = newAppointment.doctorName
                    }
                    
                    
                    cell.doctorTextField.text = doctor
                    doctorTextField = cell.doctorTextField
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "datecell", for: indexPath) as! DateInputTableViewCell
                    if let newAppointment = newAppointment{
                        selectedDate = newAppointment.date as? Date
                    }
                    
                    if let selectedDate = selectedDate {
                        cell.datePicker.date = selectedDate
                    }
                    datePicker = cell.datePicker
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
                    return cell
                }
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "symptomscell", for: indexPath) as! SymptomsTableViewCell
                //cell.symptomsTextView.delegate = self
                if let newAppointment = newAppointment{
                    symptoms = newAppointment.symptoms
                }
                cell.symptomsTextView.text = symptoms
                symptomsTextView = cell.symptomsTextView
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionscell", for: indexPath) as! QuestionTableViewCell
                let question = questions[indexPath.row]
                cell.questionLabel.text = question
                if (selectedQuestions.contains(question)) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                
                cell.selectionStyle = .none
                return cell
            default:
                // this because cases must be exhaustive and some sort of cell needs to be returned (this should never happen)
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
                return cell
            }
        } else if (selectedSegmentIndex == 1) {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentdisplaycell", for: indexPath) as! AppointmentDisplayTableViewCell
                    cell.appointmentLabel.text = appointment
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "doctordisplaycell", for: indexPath) as! DoctorDisplayTableViewCell
                    cell.doctorLabel.text = doctor
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "datedisplaycell", for: indexPath) as! DateDisplayTableViewCell
                    if let selectedDate = selectedDate {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                        cell.dateLabel.text = dateFormatter.string(from: selectedDate)
                    } else {
                        cell.dateLabel.text = "No date selected"
                    }
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
                    return cell
                }
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "symptomscell", for: indexPath) as! SymptomsTableViewCell
                //cell.symptomsTextView.delegate = self
                cell.symptomsTextView.text = symptoms
                symptomsTextView = cell.symptomsTextView
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionscell", for: indexPath) as! QuestionTableViewCell
                cell.questionLabel.text = selectedQuestions[indexPath.row]
                return cell
            default:
                // this because cases must be exhaustive and some sort of cell needs to be returned (this should never happen)
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
                return cell
            }
        } else {
            switch indexPath.section {
            case 0:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "webcell", for: indexPath) as! WebViewCell
                cell.diagnosisBox.delegate = self
                if let newAppointment = newAppointment{
                    diagnosis = newAppointment.diagnosis
                    print (diagnosis)
                }
                //diagnosisdisplay.text =diagnosis
                cell.diagnosisBox.text = diagnosis
                diagnosisTextField = cell.diagnosisBox
                return cell
//                
//            case 1:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "symptomscell", for: indexPath) as! SymptomsTableViewCell
//                //cell.symptomsTextView.delegate = self
//                cell.symptomsTextView.text = symptoms
//                symptomsTextView = cell.symptomsTextView
//                return cell
//            case 2:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "questionscell", for: indexPath) as! QuestionTableViewCell
//                cell.questionLabel.text = selectedQuestions[indexPath.row]
//                return cell
            default:
                // this because cases must be exhaustive and some sort of cell needs to be returned (this should never happen)
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (selectedSegmentIndex == 0) {
            switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                case 0:
                    return 44
                case 1:
                    return 44
                case 2:
                    return 250
                default:
                    return 44
                }
            case 1:
                return 150 // date input cell
            case 2:
                return 44  // item cell
            default:
                return 44
            }
        } else if (selectedSegmentIndex == 1) {
            switch (indexPath.section) {
            case 0:
                return 44
            case 1:
                return 150
            case 2:
                return 44
            default:
                return 44
            }
        } else {
            switch (indexPath.section) {
            case 0:
                return 650
            default:
                return 44
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 2) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            let row = indexPath.row
            if row < questions.count {
                // add item to array of selected items
                let question = questions[row]
                if (!selectedQuestions.contains(question)) {
                    selectedQuestions.append(question)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (indexPath.section == 2) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            let row = indexPath.row
            if row < questions.count {
                // remove item from array of selected items
                let question = questions[row]
                if let index = selectedQuestions.index(of: question) {
                    selectedQuestions.remove(at: index)
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func segmentSelected(_ sender: Any) {
        if (selectedSegmentIndex == 0) {
            // get the data from the cells before the cells are destroyed
            
            if let appointmentTextField = appointmentTextField {
                appointment = appointmentTextField.text!
            }
            if let doctorTextField = doctorTextField {
                doctor = doctorTextField.text!
            }
            if let symptomsTextView = symptomsTextView {
                symptoms = symptomsTextView.text!
            }
            if let datePicker = datePicker {
                selectedDate = datePicker.date
            }
            
        }
       
        
        
        selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        tableView.reloadData()
        }
    }
    


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


