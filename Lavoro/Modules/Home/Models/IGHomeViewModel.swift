//
//  IGHomeViewModel.swift
//  InstagramStories
//
//  Created by  Boominadha Prakash on 01/11/17.
//  Copyright © 2017 DrawRect. All rights reserved.
//

import Foundation

class IGHomeViewModel {
    
    //MARK: - iVars
    //Keep it Immutable! don't get Dirty :P
    private var stories: IGStories?
    
    //MARK: - Public functions
    public func setStories(stories: IGStories) {
        self.stories = stories
    }
    public func getStories() -> IGStories? {
        return stories
    }
    public func numberOfItemsInSection(_ section:Int) -> Int {
        if let count = stories?.stories.count {
            return count
        }
        return 1
    }
    public func cellForItemAt(indexPath:IndexPath) -> IGStory? {
        return stories?.stories[indexPath.row]
    }
    
}
