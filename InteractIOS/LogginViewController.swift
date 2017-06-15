//
//  LogginViewController.swift
//  InteractIOS
//
//  Created by jeremias araujo on 14/06/17.
//  Copyright © 2017 EpsonVirtus. All rights reserved.
//

import UIKit

struct LogginProperties {
    let roomId : String
    let password: String
    let userName: String
    
    init(roomId: String, password: String, userName: String) {
        self.roomId = roomId
        self.password = password
        self.userName = userName
    }
}

class LogginViewController: UIViewController {

    
    @IBOutlet weak var tvRoomId: UITextField!
    @IBOutlet weak var tvPassword: UITextField!
    @IBOutlet weak var tvUserName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
        tvRoomId.placeholder = "RoomId"
        tvPassword.placeholder = "***"
        tvUserName.placeholder = "EPSON"
    }

    @IBAction func btnLogginPressed(_ sender: Any) {
        let roomId = tvRoomId.text?.trim()
        let password = tvPassword.text?.trim()
        let userName = tvUserName.text?.trim()
        
        if roomId != "" && password != "" && userName != "" {
            let channelProperties = LogginProperties(roomId: roomId!, password: password!, userName: userName!)
            performSegue(withIdentifier: "showChat", sender: channelProperties)
            
        }else {
            print("empty field(s)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let destination = segue.destination as? ChatViewController {
            if let channelProperties = sender as? LogginProperties {
                destination.channelProperties = channelProperties
            }
        }
    }

   }

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
//extension String
//{
//    func trim() -> String
//    {
//        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
//    }
//}

