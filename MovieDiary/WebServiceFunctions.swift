//
//  WebServiceFunctions.swift
//  MovieDiary
//
//  Contains Web service functions invoked in WebServicesClient.swift
//
//  Created by Sanjay Noronha on 2016/03/25.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import UIKit

extension   WebServicesClient
{
       
    //MARK: Get Functions
    
    func taskForGETImage(size: String, filePath: String, completionHandlerForImage: (imageData: NSData?, error: NSError?) -> Void) -> NSURLSessionTask {
        
        /* 1. Set the parameters */
        // There are none...
        
        /* 2/3. Build the URL and configure the request */
        let baseURL = NSURL(string: MovieDiaryConstants.Constants.baseImageURLString)!
        let url = baseURL.URLByAppendingPathComponent(size).URLByAppendingPathComponent(filePath)
        let request = NSURLRequest(URL: url)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                let errorMethod = "taskForGETImage"
                completionHandlerForImage(imageData: nil, error: self.getError(errorMethod, errorInfo: error))
                 }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForImage(imageData: data, error: nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func getMoviesForSearchString(searchString: String, completionHandlerForMovies: (result: [Movie]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        /* 1. Specify parameters */
        let parameters = [MovieDiaryConstants.ParameterKeys.Query: searchString]
        
        /* 2. Make the request */
        let task = taskForGETMethod(MovieDiaryConstants.Methods.SearchMovie, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForMovies(result: nil, error: error)
            } else {
                
                if let results = results[MovieDiaryConstants.JSONResponseKeys.MovieResults] as? [[String:AnyObject]] {
                    
                    let movies = Movie.moviesFromResults(results)
                    completionHandlerForMovies(result: movies, error: nil)
                } else {
                    let errorMethod = "getMoviesForSearchString"
                    let errorInfo = "Could not parse JSON"
                    completionHandlerForMovies(result: nil, error: self.getError(errorMethod, errorInfo: errorInfo))
                }
            }
        }
        
        return task
    }
    
    // used in several APIs having the {id} keyword
    func getUserID(completionHandlerForUserID: (success: Bool, userID: Int?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters */
        let parameters = [MovieDiaryConstants.ParameterKeys.SessionID: sessionID!]
        
        /* 2. Make the request */
        taskForGETMethod(MovieDiaryConstants.Methods.Account, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForUserID(success: false, userID: nil, error: error )
            } else {
                if let userID = results[MovieDiaryConstants.JSONResponseKeys.UserID] as? Int {
                    completionHandlerForUserID(success: true, userID: userID, error: nil)
                } else {
                    let errorMethod = "getUserID"
                    let errorInfo = "Could not parse JSON"
                    completionHandlerForUserID(success: false, userID: nil, error: self.getError(errorMethod, errorInfo: errorInfo))
                }
            }
        }
    }
    
    
    
     func getSessionID(completionHandlerForSession: (success: Bool, sessionID: String?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [MovieDiaryConstants.ParameterKeys.RequestToken: requestToken!]
        
        /* 2. Make the request */
        taskForGETMethod(MovieDiaryConstants.Methods.AuthenticationSessionNew, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForSession(success: false, sessionID: nil, error: error)
            } else {
                if let sessionID = results[MovieDiaryConstants.JSONResponseKeys.SessionID] as? String {
                    completionHandlerForSession(success: true, sessionID: sessionID, error: nil)
                } else {
                    let errorMethod = "getSessionID"
                    let errorInfo = "Could not get session ID from JSON"
                    completionHandlerForSession(success: false, sessionID: nil, error: self.getError(errorMethod, errorInfo: errorInfo))
                }
            }
        }
    }
    
    
    func getRequestToken(completionHandlerForToken: (success: Bool, requestToken: String?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters. This function has none*/
        let parameters = [String:AnyObject]()
        
        /* 2. Make the request */
        taskForGETMethod(MovieDiaryConstants.Methods.AuthenticationTokenNew, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForToken(success: false, requestToken: nil, error: error)
            } else {
                if let requestToken = results[MovieDiaryConstants.JSONResponseKeys.RequestToken] as? String {
                    completionHandlerForToken(success: true, requestToken: requestToken, error: nil)
                } else {
                    let errorMethod = "getRequestToken"
                    let errorInfo = "Could not parse JSON"
                    completionHandlerForToken(success: false, requestToken: nil, error: self.getError(errorMethod, errorInfo: errorInfo))

                }
            }
        }
    }
    
    //MARK: TMDB Auth function
    
    // Authorization will take place in a web view
    // This means that the login details will not be available in the App : Secure
    func loginWithToken(hostViewController: UIViewController, completionHandlerForLogin: (success: Bool, error: NSError?) -> Void) {
        
        let authorizationURL = NSURL(string: "\(MovieDiaryConstants.Constants.AuthorizationURL)\(requestToken!)")
        let request = NSURLRequest(URL: authorizationURL!)
        
        let webAuthViewController = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("AuthViewController") as! AuthViewController
        
            webAuthViewController.urlRequest = request
            webAuthViewController.requestToken = requestToken
            webAuthViewController.completionHandlerForView = completionHandlerForLogin
        
        let webAuthNavigationController = UINavigationController()
       
        //Setting Nav Controller Properties
        
            //The tint color to apply to the navigation bar background
            webAuthNavigationController.navigationBar.barTintColor = MovieDiaryConstants.AppThemeColor
            
            // color of the bar button items
            webAuthNavigationController.navigationBar.tintColor = UIColor.whiteColor()
            
            //setting color of Nav bar text
            let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            webAuthNavigationController.navigationBar.titleTextAttributes = titleDict
        

        // pushing a view controller causes its view to be embedded
        // in the navigation interface
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        performUIUpdatesOnMain {
            hostViewController.presentViewController(webAuthNavigationController, animated: true, completion: nil)
        }
    }
    
    //MARK: GET common function
    func taskForGETMethod(method: String, var parameters: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Add the common parameter */
        parameters[MovieDiaryConstants.ParameterKeys.ApiKey] = MovieDiaryConstants.Constants.ApiKey
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSURLRequest(URL: tmdbURLFromParameters(parameters, withPathExtension: method))
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(errorInfo: String) {
                let errorMethod = "\(method) : taskForGETMethod"
                completionHandlerForGET(result: nil, error: self.getError(errorMethod, errorInfo: errorInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Invalid response Status: \(response as? NSHTTPURLResponse)?.statusCode)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(MovieDiaryConstants.Methods.AuthenticationTokenNew,data: data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request. Beginner snafu, this.. */
        task.resume()
        
        return task
    }
    
    //MARK: Private functions
    
    private func tmdbURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = MovieDiaryConstants.Constants.ApiScheme
        components.host = MovieDiaryConstants.Constants.ApiHost
        components.path = MovieDiaryConstants.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
  
    private func convertDataWithCompletionHandler(method:String, data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            
            let errorMethod = "\(method) : convertDataWithCompletionHandler"
            completionHandlerForConvertData(result: nil, error: getError(errorMethod,errorInfo: "Could not parse the data as JSON: \(data)"))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
        
    private func getError(errorMethod:String, errorInfo: String) -> NSError {
    
    let errorDomain = errorMethod
    let userInfo = [NSLocalizedDescriptionKey : errorInfo]
    
    //TODO : Better Error Code Handling
    return  NSError(domain: errorDomain, code: MovieDiaryConstants.ErrorCodes.tmdbAPI, userInfo: userInfo)
    }

}