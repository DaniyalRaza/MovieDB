//
//  KeyboardHandler.swift
//  MovieDB
//
//  Created by Invision on 25/11/2017.
//  Copyright © 2017 Daniyal Raza. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardHandler : class{
    var bottomConstraint:NSLayoutConstraint { get }
    func keyboardDidChangeFrame(notification:Notification)
}

extension KeyboardHandler where Self: UIViewController{
    
    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil, queue: nil) { (notification) in
            self.keyboardDidChangeFrame(notification: notification)
        }
    }
    
    func keyboardDidChangeFrame(notification:Notification){
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomConstraint.constant = -(view.bounds.height - endFrame.origin.y)
        self.view.layoutIfNeeded()
    }
    
}
