//
//  WebViewController.swift
//  HealthHippoAppointment
//
//  Created by Matthew Romero Moore on 12/12/16.
//  Copyright © 2016 Matthew Romero Moore. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webViewTextField: UITextField!
    @IBOutlet weak var diagnosisBox: UITextField!
    @IBOutlet weak var wikiView: UIWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        wikiView.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchWeb(_ sender: Any) {
        
        wikiView.isHidden = false
        if let term = diagnosisBox.text{
            
            let newTerm = term.replacingOccurrences(of: " ", with: "_")
            
            if let url = URL(string: "https://en.wikipedia.org.wiki/" + newTerm){
                wikiView.loadRequest(URLRequest(url: url))
            }
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

}
