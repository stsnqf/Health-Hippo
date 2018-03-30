import UIKit
import CoreData


class ViewController: UITableViewController, AudioRecorderViewControllerDelegate{

    var memos = [Memo]()
    var newMemo: Memo?

    var track: Int! = 0
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 94/255, green: 177/255, blue: 217/255, alpha: 1.0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
        memos = getMemos()
        tableView.reloadData()
    }

    
    // Table View DataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CellID")
        //cell?.textLabel?.text = "Track \(indexPath.row + 1)"
        cell.textLabel?.text = memos[indexPath.row].title
        //cell?.textLabel?.text = "Memo \(indexPath.row + 1)"

        return cell
    }
    
    @available(iOS 10.0, *)
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return memos.count
        
    }
    func getMemos() -> [Memo] {
        let fetchRequest = NSFetchRequest<Memo>(entityName: "Memo")
        
        do {
            let foundMemos = try getContext().fetch(fetchRequest)
            return foundMemos
        } catch {
            print("Error retrieving Memo")
        }
        
        return [Memo]()
    }
    
    
    // Table View Delegate
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        track = indexPath.row
        performSegue(withIdentifier: "MoveToAudioPlayer", sender: self)
    }
    */
    func deleteMemo(indexPath: IndexPath) {
        let row = indexPath.row
        
        if(row < memos.count) {
            let memo = memos[row]
            memos.remove(at: row)
            getContext().delete(memo)
            
            do {
                try getContext().save()
            } catch {
                print ("Error occurred saving context after deleting item")
            }
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            confirmDelete(indexPath: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func confirmDelete(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Memo", message: "Are you sure you want to delete the memo?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (action) in
            self.deleteMemo(indexPath: indexPath)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action) in
            self.tableView.reloadRows(at: [indexPath], with: .right)
        })
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func audioRecorderViewControllerDismissed(withFileURL fileURL: URL?) {
        // do something with fileURL
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func presentAudioRecorder(_ sender: Any) {
        let controller = AudioRecorderViewController()
        controller.audioRecorderDelegate = self
        present(controller, animated: true, completion: nil)
    }
    @IBAction func presentAudioRecorder2(_ sender: Any) {
       
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        //audioPlayerVC.trackID2 = track
        if (segue.identifier == "selectaudioplayer"){
            let audioPlayerVC = segue.destination as? AudioPlayerVC
            let indexPath = tableView.indexPathForSelectedRow
            audioPlayerVC?.trackID2 = memos[(indexPath?.row)!].title
            //print(audioPlayerVC.trackID2)
            audioPlayerVC?.tracknum = indexPath?.row
        }
        if segue.identifier == "audiosegue2" {
            
            if let destination = segue.destination as? AudioRecorderViewController{
                destination.audioRecorderDelegate = self
                
            }
        }
        
    }
}

