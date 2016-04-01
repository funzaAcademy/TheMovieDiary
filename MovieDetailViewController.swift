//
//  MovieDetailViewController.swift
//  MovieDiary
//
//  Selected movie details.
//
//  Created by Sanjay Noronha on 2016/03/31.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import UIKit



class MovieDetailViewController: UIViewController {
    
    // MARK: Properties/Outlets
    var movie: Movie?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //navigationController!.navigationBar.translucent = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
       
        // set the UI Moview image + Title
        if let movie = movie {
            
            // set the title
            if let releaseYear = movie.releaseYear {
                navigationItem.title = "\(movie.title) (\(releaseYear))"
            } else {
                navigationItem.title = "\(movie.title)"
            }
            
            
            // set the poster image
            if let posterPath = movie.posterPath {
                WebServicesClient.sharedInstance.taskForGETImage(MovieDiaryConstants.PosterSizes.DetailPoster, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                    if let image = UIImage(data: imageData!) {
                        performUIUpdatesOnMain {
                            self.activityIndicator.alpha = 0.0
                            self.activityIndicator.stopAnimating()
                            self.posterImageView.image = image
                        }
                    }
                })
            } else {
                activityIndicator.alpha = 0.0
                activityIndicator.stopAnimating()
            }
        }
    }
    
 
}