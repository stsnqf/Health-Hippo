//
//  UserProfileViewController.swift
//  UserProfile
//
//  Created by Samuel Frimpong Jr. on 12/6/16.
//  Copyright © 2016 Samuel Frimpong Jr. All rights reserved.
//

import UIKit
import CoreData

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var myName: UITextField!
    @IBOutlet weak var myAddress: UITextField!
    @IBOutlet weak var myPhone: UITextField!
    
    //@IBOutlet weak var myAge: UITextField!
    @IBOutlet weak var myDOB: UITextField!
    //@IBOutlet weak var myBlood: UITextField!
    @IBOutlet weak var mySex: UITextField!
    @IBOutlet weak var myHeight: UITextField!
    @IBOutlet weak var myWeight: UITextField!
    
    @IBOutlet weak var myAllergies: UITextField!
    @IBOutlet weak var myMedication: UITextField!
    @IBOutlet weak var myConditions: UITextField!
    //@IBOutlet weak var myNotes: UITextField!
    
    //@IBOutlet weak var hippoImage: UIImageView!
    @IBOutlet weak var birthdatePicker: UIDatePicker!
    @IBOutlet weak var hippoImage: UIImageView!
    
    @IBAction func myDOB(_ sender: UITextField) {
        let datePickerView : UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector(("handleDatePicker:")), for: UIControlEvents.valueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker)
    {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .full
        timeFormatter.timeStyle = .none
        myDOB.text = timeFormatter.string(from: sender.date)
    }
    
    /* func displayBirthdate()
     {
     myDOB.text = birthdatePicker.description
     } */
    
    
    var myProfile : Profile?
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor(red: 94/255, green: 177/255, blue: 217/255, alpha: 1.0)
        //self.navigationItem.rightBarButtonItem
        
        //handleDatePicker(sender: birthdatePicker)
        
        super.viewDidLoad()
        
        func getContext () -> NSManagedObjectContext {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }
        
        func saveUserProfile() {
            let context = getContext()
            
            // if a note doesn't exist, create one
            // if a note does exist, update it
            if myProfile == nil {
                myProfile = Profile(context:  getContext())
            }
            
            if let myProfile = myProfile {
                myProfile.userName = myName.text
                myProfile.userAddress = myAddress.text
                myProfile.userPhone = Double(myPhone.text!)!
                
                //myProfile.userAge = Double(myAge.text!)!
                myProfile.userDOB = myDOB.text
                //myProfile.userBlood = myBlood.text
                myProfile.userSex = mySex.text
                myProfile.userHeight = Float(myHeight.text!)!
                myProfile.userWeight = Float(myWeight.text!)!
                
                myProfile.userAllergies = myAllergies.text
                myProfile.userMedication = myMedication.text
                myProfile.userConditions = myConditions.text
                //myProfile.userNotes = myNotes.text
                
                do {
                    try context.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
            //_ = navigationController?.popToRootViewController(animated: true)
            
        }
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(UserProfileViewController.saveUserProfile))
        
        //navigationController?.setToolbarHidden(true, animated: false)
        
        
        if let myProfile = myProfile
        {
            myName.text = myProfile.userName
            myAddress.text = myProfile.userAddress
            myPhone.text = String(describing: myProfile.userPhone)
            
            //myAge.text = String(myProfile.userAge)
            myDOB.text = String(describing: myProfile.userDOB)
            //myBlood.text = myProfile.userBlood
            mySex.text = myProfile.userSex
            myHeight.text = String(myProfile.userHeight)
            myWeight.text = String(myProfile.userWeight)
            
            myAllergies.text = myProfile.userAllergies
            myMedication.text = myProfile.userMedication
            myConditions.text = myProfile.userConditions
            //myNotes.text = myProfile.userNotes
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
