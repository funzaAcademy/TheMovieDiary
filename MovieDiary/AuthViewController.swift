//
//  AuthViewController.swift
//  MovieDiary
//
//  Created by Sanjay Noronha on 2016/03/25.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import UIKit

// MARK: - AuthViewController: UIViewController

class AuthViewController: UIViewController {
    
    // MARK: Properties
    
    var urlRequest: NSURLRequest? = nil
    var requestToken: String? = nil
    var completionHandlerForView: ((success: Bool, error: NSError?) -> Void)? = nil
    
    // MARK: Outlets
    
    @IBOutlet weak var webView: UIWebView!
   
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        navigationItem.title = "Authentication"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelAuth")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let urlRequest = urlRequest {
            webView.loadRequest(urlRequest)
        }
    }
    
    // MARK: Cancel Auth Flow
    
    func cancelAuth() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - TMDBAuthViewController: UIWebViewDelegate

extension AuthViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        if webView.request!.URL!.absoluteString == "\(MovieDiaryConstants.Constants.AuthorizationURL)\(requestToken!)/allow" {
            
            dismissViewControllerAnimated(true) {
                self.completionHandlerForView!(success: true, error: nil)
            }
        }
    }
}
