//
//  NaImageDownloader.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 19/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit

extension UIImageView {

    private struct PropertyHolder {
        static var operation: Operation?
    }
    
    var imageDownloadOperation: Operation? {
        get {
            return PropertyHolder.operation
        }
        set (value) {
            PropertyHolder.operation = value
        }
    }
    
    func loadImage(fromUrl url: String) {
        let operation = NaDownloadManager.shared.downloadImage(url) { [weak self] (image, url, error) in
            if error == nil {
                if let img = image {
                    self!.setDownloadedImage(img)
                }
            }
        }
        self.imageDownloadOperation = operation
    }
    
    func setDownloadedImage(_ image: UIImage) {
        DispatchQueue.main.sync {
            self.image = image
        }
    }
    
    func cancelLoad() {
        if self.imageDownloadOperation != nil {
            if self.imageDownloadOperation!.isExecuting && !self.imageDownloadOperation!.isFinished {
                self.imageDownloadOperation?.cancel()
            }
        }
    }
    
}
