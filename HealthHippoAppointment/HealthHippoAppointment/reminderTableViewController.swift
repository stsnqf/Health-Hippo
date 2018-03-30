//
//  reminderTableViewController.swift
//  reminderThing
//
//  Created by Joshua Lewis on 12/9/16.
//  Copyright © 2016 Joshua Lewis. All rights reserved.
//

import UIKit
import CoreData

class reminderTableViewController: UITableViewController {
    
    
    
    var reminders = [Reminder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title = "Reminders"
        
       
        self.view.backgroundColor = UIColor(red: 94/255, green: 177/255, blue: 217/255, alpha: 1.0)

        //navigationController?.pushViewController(ReminderViewController, animated: true)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false , animated: true)
        reminders = getReminders()
        tableView.reloadData()
    }
    
    func getReminders() -> [Reminder] {
        
        let fetchRequest = NSFetchRequest<Reminder>(entityName: "Reminder")
        
        do {
            let foundNotes = try getContext().fetch(fetchRequest)
            return foundNotes
        } catch{
            print("Error retrieving Tasks")
        }
        
        return [Reminder]()
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)

        cell.textLabel?.text = reminders[indexPath.row].title
        cell.detailTextLabel?.text = reminders[indexPath.row].directions
        
        let reminder = reminders[indexPath.row]
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        //i am ashamed of the following line
        
        if (dateFormatter.date(from: reminder.date!)! <= currentDate){
            cell.textLabel?.textColor = UIColor.red
            cell.detailTextLabel?.textColor = UIColor.red
        }

        return cell
    }
    
    func confirmDelete(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Reminder", message: "Are you sure you want to delete this reminder?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
            (action) in
            self.deleteReminder(indexPath: indexPath)
        })
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: {
            (action) in
            self.tableView.reloadRows(at: [indexPath], with: .right)
        })
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    
    func deleteReminder(indexPath: IndexPath) {
        let row = indexPath.row
        
        if (row < reminders.count){
            let task = reminders[row]
            //removes row from array
            reminders.remove(at: row)
            //removes the in-memory context
            getContext().delete(task)
            //need to call save on the context, if we don't nothing will happen
            
            do{
                try getContext().save()
            }catch{
                print("Error ocurred saving context after deleting item.")
            }
        }
        
        //this must happen after the note is deleted from the array, otherwise it will crash
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            //deleteNote(indexPath: indexPath)
            confirmDelete(indexPath: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "select"), let destination = segue.destination as? ReminderViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            destination.reminder = reminders[indexPath.row]
        }
        
    }
    

}
