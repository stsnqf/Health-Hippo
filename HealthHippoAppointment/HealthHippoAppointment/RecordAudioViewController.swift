import UIKit
import CoreData

class RecordAudioViewController: UIViewController, AudioRecorderViewControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func audioRecorderViewControllerDismissed(withFileURL fileURL: URL?) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "audiosegue" {
            
                if let destination = segue.destination as? AudioRecorderViewController{
                    destination.audioRecorderDelegate = self
                
                }
        }
        if segue.identifier == "audiosegue2" {
            
            if let destination = segue.destination as? AudioRecorderViewController{
                destination.audioRecorderDelegate = self
                
            }
        }
    }
    
    //Record Audio
    //
    //1. Save to Documents directory with file path
    //2. Save file path to core data filepath attribute
    
    //Access Audio
    //
    //1. Access core data filepath attribute to get filepath
    //2. Append filepath to relative documents directory to load file
    //3. load file in media player
}
