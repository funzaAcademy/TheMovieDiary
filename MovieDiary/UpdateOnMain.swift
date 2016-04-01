//
//  UpdateOnMain.swift
//  MovieDiary
//
//  Global function used by other calling classes
//  Performs action on Main thread
//
//  Created by Sanjay Noronha on 2016/03/25.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import Foundation


func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}