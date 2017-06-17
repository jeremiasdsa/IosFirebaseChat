//
//  ChatViewController.swift
//  InteractIOS
//
//  Created by jeremias araujo on 13/06/17.
//  Copyright © 2017 EpsonVirtus. All rights reserved.
//

import UIKit
import Firebase
import GONMarkupParser

class ChatViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var tvChat: UITextView!
    @IBOutlet weak var viewChat: UIView!
    
    var placeholderLabel : UILabel!
    
    var ref: DatabaseReference!
    var channelProperties : LogginProperties!
    var containterTextView : UITextView!
    var dicColors : Dictionary<String, String>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
        initVariables()
        configureUI()
        observeChat()
    }

    @IBAction func sendPressed(_ sender: Any) {
        
        let message = tvMessage.text.trim()
        let user = self.channelProperties.userName
        let data = [
            "message" : message,
            "user" : user
        ]
        
        self.ref.child(channelProperties.roomId).setValue(data)
        
        tvMessage.text = ""
        placeholderLabel.isHidden = !tvMessage.text.isEmpty
        view.endEditing(true)
        
    }
    
    
    
    fileprivate func observeChat() {
        let refHandle = self.ref.observe(DataEventType.value, with: { (snapshot) in
            
            if let json = snapshot.value as? NSDictionary {
                if let room = json.value(forKeyPath: self.channelProperties.roomId) as? NSDictionary {
                    let userName = room.value(forKeyPath: "user") as? String ?? ""
                    self.setUserColor(userName)
                    let message = room.value(forKeyPath: "message") as? String ?? ""
                    self.updateChatMessages(userName, message)
                    
                }
            }
        })
    }
    
    fileprivate func updateChatMessages(_ userName: String, _ message: String) {
        self.containterTextView.insertText("<font size='8'><font color=\"\(self.dicColors["gray"]as!String)\">\(self.getTime())</font></font><strong><font color=\"\(self.dicColors[userName]as!String)\">\(userName)</strong></font>: <font color=\"\(self.dicColors["black"]as!String)\">\(message)</font>\n")
        self.tvChat.setMarkedUpText(self.containterTextView.text)
        
        let bottom = self.tvChat.contentSize.height - self.tvChat.bounds.size.height
        self.tvChat.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
    }
    
    fileprivate func setUserColor(_ userName: String) {
        if let color = self.dicColors[userName] {
            //                        print(self.dicColors[userName]!)
        }else{
            
            self.dicColors[userName] = self.getRandomColor()
        }
    }
    
    fileprivate func configureUI() {
        tvMessage.layer.cornerRadius = 5
        viewChat.layer.cornerRadius = 5
        tvChat.layer.cornerRadius = 5
        tvChat.isEditable = false
        tvMessage.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter some text..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (tvMessage.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        tvMessage.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tvMessage.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvMessage.text.isEmpty
    }
    
    fileprivate func initVariables() {
        self.ref = Database.database().reference()
        self.containterTextView = UITextView()
        self.dicColors = Dictionary<String,String>()
        self.dicColors["black"] = "#000000"
        self.dicColors["gray"] = "#cccccc"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.ref.removeAllObservers()
    }
    
    func getTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "(\(hour):\(minutes))"
    }
    
    func getRandomColor() -> String {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        //HEX
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
        //UIColor
        //return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
}


