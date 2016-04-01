//
//  MovieSelectorViewController.swift
//  MovieDiary
//
//  Search for your Favorite movies. Add to favorite OR view details
//
//  Created by Sanjay Noronha on 2016/03/27.
//  Copyright © 2016 funza Academy. All rights reserved.
//


import UIKit


class MovieSelectorViewController: UIViewController {
    
    // MARK: Properties
    
    // the data for the table
    var movies = [Movie]()
    
    
    // the most recent data download task. We keep a reference to it so that it can be canceled every time the search text changes
    var searchTask: NSURLSessionDataTask?
    
    //TODO: Use a CollectionView in future
    @IBOutlet weak var movieTableView: UITableView!

    @IBOutlet weak var movieSearchBar: UISearchBar!

    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logout:")
       
        
        // configure tap recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: Dismissals
    
   func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    /*
     * Note: This cannot be private since its a Selector function.
    */
    func logout(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - MoviePickerViewController: UIGestureRecognizerDelegate

extension MovieSelectorViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return movieSearchBar.isFirstResponder()
    }
}

// MARK: - MoviePickerViewController: UISearchBarDelegate

extension MovieSelectorViewController: UISearchBarDelegate {
    
    // each time the search text changes we want to cancel 
    // any current download and start a new one
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // No text : Empty table view
        if searchText == "" {
            movies = [Movie]()
            movieTableView?.reloadData()
            return
        }
        
        // new search
        searchTask = WebServicesClient.sharedInstance.getMoviesForSearchString(searchText) { (movies, error) in
                //self.searchTask = nil
                if let movies = movies {
                    self.movies = movies
                    performUIUpdatesOnMain {
                       self.movieTableView!.reloadData()
                    }
                }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - MoviePickerViewController: UITableViewDelegate, UITableViewDataSource

extension MovieSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseId = "Movie"
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId) as UITableViewCell!
        
        if let releaseYear = movie.releaseYear {
            cell.textLabel!.text = "\(movie.title) (\(releaseYear))"
        } else {
            cell.textLabel!.text = "\(movie.title)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let movie = movies[indexPath.row]
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movie
        navigationController!.pushViewController(controller, animated: true)

    }
}
