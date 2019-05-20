//
//  DiscardableImageItem.swift
//  Pinterest Board
//
//  Created by Indigo on 20/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit

open class DiscardableImageItem: NSObject, NSDiscardableContent {
    
    private(set) public var image: UIImage?
    private(set) public var imageUrlString: String?
    var accessCount: UInt = 0
    
    public init(image: UIImage, imageUrlString: String) {
        self.image = image
        self.imageUrlString = imageUrlString
    }
    
    public func beginContentAccess() -> Bool {
        if image == nil {
            return false
        }
        
        accessCount += 1
        return true
    }
    
    public func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }
    
    public func discardContentIfPossible() {
        if accessCount == 0 {
            image = nil
        }
    }
    
    public func isContentDiscarded() -> Bool {
        return image == nil
    }
    
}
