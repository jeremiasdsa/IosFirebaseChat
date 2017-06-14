//
//  LogginViewController.swift
//  InteractIOS
//
//  Created by jeremias araujo on 14/06/17.
//  Copyright © 2017 EpsonVirtus. All rights reserved.
//

import UIKit

class LogginViewController: UIViewController {

    
    @IBOutlet weak var tvChannelId: UITextField!
    @IBOutlet weak var tvPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvChannelId.placeholder = "RoomId"
        tvPassword.placeholder = "***"
        // Do any additional setup after loading the view.
    }

    @IBAction func btnLogginPressed(_ sender: Any) {
        let channelId = tvChannelId.text
        let password = tvPassword.text
        
        if channelId != "" && password != "" {
            let channelProperties = [
                "channelId" : channelId,
                "password" : password
            ]
            
            performSegue(withIdentifier: "showChat", sender: channelProperties)
            

        }else {
            print("empty field(s)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let destination = segue.destination as? ViewController {
            if let channelProperties = sender as? [String : String] {
                destination.channelProperties = channelProperties
            }
        }
    }
    

   }
