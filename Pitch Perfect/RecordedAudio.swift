//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Victor Jimenez on 1/24/16.
//  Copyright © 2016 Victor Jimenez. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: URL!
    var title: String!
    
    init(filePathUrl: URL, title: String)
    {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
