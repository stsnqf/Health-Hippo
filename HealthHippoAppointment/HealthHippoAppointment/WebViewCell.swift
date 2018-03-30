//
//  WebViewCell.swift
//  HealthHippoAppointment
//
//  Created by Matthew Romero Moore on 12/12/16.
//  Copyright © 2016 Matthew Romero Moore. All rights reserved.
//

import UIKit

class WebViewCell: UITableViewCell {

    @IBOutlet weak var diagnosisBox: UITextField!
    @IBOutlet weak var wikiView: UIWebView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
         wikiView.isHidden = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func search(_ sender: Any) {
        wikiView.isHidden = false
        if let term = diagnosisBox.text{
            
            let newTerm = term.replacingOccurrences(of: " ", with: "_")
            
            if let url = URL(string: "https://en.wikipedia.org/wiki/" + newTerm){
                print(url)
                wikiView.loadRequest(URLRequest(url: url))
            }
        }
    
    }
}



