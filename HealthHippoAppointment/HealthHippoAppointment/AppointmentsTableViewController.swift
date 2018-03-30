//
//  AppointmentsTableViewController.swift
//  HealthHippoAppointment
//
//  Created by Matthew Romero Moore on 12/12/16.
//  Copyright © 2016 Matthew Romero Moore. All rights reserved.
//

import UIKit
import CoreData

class AppointmentsTableViewController: UITableViewController {
    
    var appointments = [Appointment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.view.backgroundColor = UIColor(red: 94/255, green: 177/255, blue: 217/255, alpha: 1.0)

    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
        appointments = getAppointments()
        tableView.reloadData()
    }
    
    func getAppointments() -> [Appointment] {
        let fetchRequest = NSFetchRequest<Appointment>(entityName: "Appointment")

        do {
            let foundAppointments = try getContext().fetch(fetchRequest)
            return foundAppointments
        } catch {
            print("Error retrieving Appointment")
        }
        
        return [Appointment]()
    }
    
    func deleteAppointment(indexPath: IndexPath) {
        let row = indexPath.row
        
        if(row < appointments.count) {
            let appointment = appointments[row]
            appointments.remove(at: row)
            getContext().delete(appointment)
            
            do {
                try getContext().save()
            } catch {
                print ("Error occurred saving context after deleting item")
            }
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appointments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentcell", for: indexPath)

        cell.textLabel?.text = appointments[indexPath.row].appointmentName
        //cell.detailTextLabel?.text = appointments[indexPath.row].dateString
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            confirmDelete(indexPath: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func confirmDelete(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Appointment", message: "Are you sure you want to delete the appointment?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (action) in
            self.deleteAppointment(indexPath: indexPath)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action) in
            self.tableView.reloadRows(at: [indexPath], with: .right)
        })
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "select"), let destination = segue.destination as? AppointmentViewController,
            let indexPath = tableView.indexPathForSelectedRow{
            destination.newAppointment = appointments[indexPath.row]
        }
    }

}
