//
//  Moments.swift
//  CaptionCam
//
//  Created by Daniel Senga on 2022/04/29.
//

import UIKit

class Moments: NSObject, Codable {
    var fileName: String
    var caption: String
    
    init(fileName: String, caption: String) {
        self.fileName = fileName
        self.caption = caption
    }
}
