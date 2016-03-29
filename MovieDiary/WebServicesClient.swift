//
//  WebServicesClient.swift
//  MovieDiary
//
//  This class holds one key function : authenticateWithViewController
//  Its extension holds other functions invoked in the key function
//
//  Created by Sanjay Noronha on 2016/03/25.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import UIKit


class WebServicesClient{
    
// MARK: Properties
    
    static let sharedInstance = WebServicesClient() //Singleton
    
    var session = NSURLSession.sharedSession()    
    var requestToken: String? = nil
    var sessionID : String? = nil
    var userID : Int? = nil
    
// MARK:- Key_Function
    func authenticateWithViewController(hostViewController: UIViewController, completionHandlerForAuth: (success: Bool, error: NSError?) -> Void) {
        
            // TODO: Fix Pyramid of Doom
        
            // Chain completion handlers for each request so that they run one after the other
            self.getRequestToken() {  (success, requestToken, error) in
                
                    if success {
                            
                            self.requestToken = requestToken
                            self.loginWithToken(hostViewController) { (success, error)in
                                
                                if success {
                                    
                                    self.getSessionID() { (success,sessionID, error) in
                                        
                                        if success {
                                            
                                            self.sessionID = sessionID
                                            self.getUserID() { (success,userID, error) in
                                                
                                                if success {
                                                    
                                                    self.userID = userID
                                                    
                                                    completionHandlerForAuth(success: success, error: error)
                                                    
                                                } else {
                                                    completionHandlerForAuth(success: success, error: error)
                                                }
                                            }
                                            
                                                
                                        } else {
                                                completionHandlerForAuth(success: success, error: error)
                                        }
                                    }
                                    
                                } else {
                                    completionHandlerForAuth(success: success, error: error)
                                }
                            }
                    } else {
                            completionHandlerForAuth(success: success, error: error)
                    }
            }
    }
    
// MARK: Singleton_Init
    private init() {}

}