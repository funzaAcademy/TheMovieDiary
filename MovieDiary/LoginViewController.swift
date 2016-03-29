//
//  LoginViewController.swift
//  MovieDiary
//
// This is where it all begins. The Initial View Controller.
//
//  Created by Sanjay Noronha on 2016/03/25.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

// MARK: Properties
    
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
   
    
// MARK:- Life_Cycle_Methods
     override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    
// MARK: IBAction_Methods
    @IBAction func loginPressed(sender: UIButton) {
        
        WebServicesClient.sharedInstance.authenticateWithViewController(self) {
            (success, error) in
            
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.displayError(error)
                    }
                }
        }

    }

    
// MARK: Private_Methods
    private func displayError(error: NSError?) {
        
        if let error = error {
            debugLabel.text = error.domain + " " + error.localizedDescription
        }
    }
    
    private func completeLogin() {
       
        debugLabel.text = ""
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
}