//
//  ViewController.swift
//  InteractIOS
//
//  Created by jeremias araujo on 13/06/17.
//  Copyright © 2017 EpsonVirtus. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var tvUserName: UITextField!
    @IBOutlet weak var tvChat: UITextView!
    @IBOutlet weak var viewChat: UIView!
    var placeholderLabel : UILabel!
    var ref: DatabaseReference!
    var channelProperties : [String:String]!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        tvMessage.layer.cornerRadius = 5
        viewChat.layer.cornerRadius = 5
        tvChat.layer.cornerRadius = 5
        tvMessage.delegate = self
        tvUserName.placeholder = "Jose"
        
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter some text..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (tvMessage.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        tvMessage.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tvMessage.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvMessage.text.isEmpty
        
        
        
        
        let refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            if let postDict = snapshot.value as? NSDictionary {
                if let user = postDict.value(forKeyPath: "user") as? String {
                    print("USUARIO DA HUMILHACAO: ", user)
                }
            }
            
            
            //tvChat.insertText("[00:00]:\(user): \(text)")
        })
        
    }



    @IBAction func sendPressed(_ sender: Any) {
        
        
        let text = tvMessage.text
        
        let user = tvUserName.text
        let data = [
            "message" : text,
            "user" : user
        ]
        
        let channelId = channelProperties["channelId"]!
        let password = channelProperties["password"]!
        
        ref.child(channelId).setValue(data)
        
        tvMessage.text = ""
        placeholderLabel.isHidden = !tvMessage.text.isEmpty
        
        view.endEditing(true)
        
        //tvChat.insertText("[00:00]:\(user): \(text)")
        
    }
    
    
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    

}

