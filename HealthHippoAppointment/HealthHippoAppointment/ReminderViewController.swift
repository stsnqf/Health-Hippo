//
//  ReminderViewController.swift
//  reminderThing
//
//  Created by Joshua Lewis on 12/9/16.
//  Copyright © 2016 Joshua Lewis. All rights reserved.
//

import UIKit
import CoreData

class ReminderViewController: UIViewController {
    
    @IBOutlet weak var reminderName: UITextField!
    @IBOutlet weak var directions: UITextView!
    @IBOutlet weak var datePick: UIDatePicker!
    
    
    
    var reminder: Reminder?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reminder"
        
        navigationController?.setToolbarHidden(true , animated: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(ReminderViewController.saveReminder))
        
        
        if let reminder = reminder {
            
            reminderName.text = reminder.title
            directions.text = reminder.directions
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            //i am ashamed of the following line
            datePick.date = dateFormatter.date(from: reminder.date!)!
            
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveReminder() {
        let context = getContext()
        
        if reminder == nil{
            reminder = Reminder(context: context)
        }
        
        if let reminder = reminder {
            reminder.title = reminderName.text
            reminder.directions = directions.text
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            reminder.date = dateFormatter.string(from: datePick.date)
            
            do{
                try context.save()
            } catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            }
        
        
        _ = navigationController?.popToRootViewController(animated: true)
            
        }
        
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     
     
     navigationController?.setToolbarHidden(true , animated: false)
     
     navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(NoteViewController.saveNote))
     
 
    */


