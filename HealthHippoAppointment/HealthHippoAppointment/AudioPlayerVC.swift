import UIKit
import AVFoundation
import CoreData
 
class AudioPlayerVC: UIViewController, AudioRecorderViewControllerDelegate{

    var trackID2: String!
    var titlememo : Memo?
    var audioPlayer:AVAudioPlayer!
    var timechoice: Float! = 1.01
    var memos = [Memo]()
    var tracknum : Int!
    
    @IBOutlet var trcktitle : UILabel!
   
    
    @IBOutlet var trackLbl: UILabel!
    

    @IBOutlet var progressView: UIProgressView!
    
    @IBAction func fastBackward(_ sender: AnyObject) {
        var time: TimeInterval = audioPlayer.currentTime
        time -= 5.0 // Go back by 5 seconds
        if time < 0
        {
            stop(self)
        }else
        {
            audioPlayer.currentTime = time
        }
    }
    @IBAction func pause(_ sender: AnyObject) {
        audioPlayer.pause()
    }
    @IBAction func play(_ sender: AnyObject) {
        if !audioPlayer.isPlaying{
            audioPlayer.play()
        }
    }
    @IBAction func stop(_ sender: AnyObject) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        progressView.progress = 0.0
    }
    @IBAction func fastForward(_ sender: AnyObject) {
        var time: TimeInterval = audioPlayer.currentTime
        time += 1.0 // Go forward by 1 second
        if time > audioPlayer.duration
        {
            stop(self)
        }else
        {
            audioPlayer.currentTime = time
        }
    }
    
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
        memos = getMemos()
 
        
        // 1
        //let mp3URL = NSURL(fileURLWithPath: path)
        do
        {
            /*
            let m4afiles = directoryContents.filter{ $0.pathExtension == "m4a" }
            print (m4afiles)
            let urlarray: [URL] = m4afiles*/
            
            let fileManager = FileManager.default

            let urls2 = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            _ = tracknum
            trackLbl?.text = (memos[tracknum].title)
            let newfilepath = memos[tracknum].filepath!
            print (newfilepath)
            let urls = URL(fileURLWithPath: newfilepath, relativeTo: urls2)
            print(urls)
            audioPlayer = try AVAudioPlayer(contentsOf: urls as URL)
            print(urls)
            audioPlayer.play()
            // 3
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            progressView.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: false)
        }
        catch
        {
            print("An error occurred while trying to extract audio file")
        }
        
    }
    //override func viewWillDisappear(_ animated: Bool) {
        //audioPlayer.stop()
    //}
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: animated)
    }
    
    func updateAudioProgressView()
    {
        if audioPlayer.isPlaying
        {
            // Update progress
            
            progressView.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: true)
        }
    }
    
    func goToTime(sender:UIButton){
        let time : Int = sender.tag
        let myfloat = Float(time)
        audioPlayer.pause()
        audioPlayer.currentTime = TimeInterval(myfloat)
        progressView.progress = Float(time)
        progressView.setProgress(Float(time)/(Float(audioPlayer.duration)), animated: true)
        
    }
    
    var timearray: [String] = []
    var flagbuttoncount : Int  = 0
    @IBOutlet weak var flagview: UITextView!
    
    @IBAction func flag(_ sender: Any) {
            let currentTime: TimeInterval = audioPlayer.currentTime
            print(currentTime.description)
            var text : String = ""
            var shortentime = String(format: "%.2f", currentTime)
            timearray.append(shortentime)
            
            //print(newtext)
            for index in 0..<timearray.count {
                text += "\(timearray[index])\n"
                print(text)
            }
            flagview.text = text
            
            
            
            if (flagbuttoncount == 0) {
                flagbuttoncount = 1
                var detailsButton = UIButton(frame: CGRect(x: 205, y: 310, width: 70, height: 25))
                detailsButton.setTitle("Go To", for: .normal)
                detailsButton.setTitleColor(UIColor.red, for: .normal)
                self.view.addSubview(detailsButton)
                detailsButton.bringSubview(toFront: detailsButton)
                detailsButton.addTarget(self, action: #selector(goToTime(sender:)), for: UIControlEvents.touchUpInside)
                
            }
            else{
                
                let newcount = 2
                createbutton(count: newcount, value: audioPlayer.currentTime)
                
                
            }
            //print(timearray.description)
            // Update progress
            //audioPlayer.pause()
            //progressView.progress = Float(currentTime)
            //progressView.setProgress(Float(currentTime)/(Float(audioPlayer.duration)), animated: true)
            
    }

    
    func createbutton(count: Int, value: TimeInterval){
        if (count > 1){
            var countmultiplier = flagbuttoncount*20
            var lowerheight: Int = 310 + countmultiplier
            let detailsButton = UIButton(frame: CGRect(x: 205, y: lowerheight, width: 70, height: 25))
            detailsButton.setTitle("Go To", for: .normal)
            detailsButton.setTitleColor(UIColor.red, for: .normal)
            self.view.addSubview(detailsButton)
            detailsButton.bringSubview(toFront: detailsButton)
            detailsButton.addTarget(self, action: #selector(goToTime(sender:)), for: UIControlEvents.touchUpInside)
            detailsButton.tag = Int(value)
            //var newstring : String = text.
            flagbuttoncount += 1
        }
    }
    func displayflag()
    {
        
        let currentTime: TimeInterval = audioPlayer.currentTime
        var timearray: [TimeInterval] = []
        _ = audioPlayer.duration
        var _ : TimeInterval
        for _ in timearray{
            timearray.append(currentTime)
            flagview.text = currentTime.description
        }
            // Update progress
            audioPlayer.pause()
            progressView.progress = Float(currentTime)
            progressView.setProgress(Float(currentTime)/(Float(audioPlayer.duration)), animated: true)
        
    }
    func audioRecorderViewControllerDismissed(withFileURL fileURL: URL?) {
        // do something with fileURL
        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 10.0, *)
    @IBAction func presentAudioRecorder(_ sender: AnyObject) {
        
        let controller = AudioRecorderViewController()
        controller.audioRecorderDelegate = self
        present(controller, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 10.0, *)
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            return appDelegate.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
        }
        return appDelegate.persistentContainer.viewContext
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
