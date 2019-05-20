//
//  NaImageDownloader.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 19/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit

typealias NaDownloadHandler = (_ image: UIImage?, _ fromUrl: URL, _ error: Error?, _ indexPath: IndexPath?) -> Void


class NaImageDownloader {
    
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
    
    func loadImage(fromUrl url: String, completion: @escaping NaDownloadHandler) {
        let operation = NaDownloadManager.shared.downloadImage(url, nil) { (image, url, error, indexPath) in
            DispatchQueue.main.async {
                 completion(image, url, error, nil)
            }
        }
        self.imageDownloadOperation = operation
    }
    
    func loadImage(fromUrl url: String, atIndexPath indexPath: IndexPath, completion: @escaping NaDownloadHandler) {
        let operation = NaDownloadManager.shared.downloadImage(url, indexPath) { (image, url, error, mIndexPath) in
            DispatchQueue.main.async {
                completion(image, url, error, mIndexPath)
            }
        }
        self.imageDownloadOperation = operation
    }
    
    func cancelLoad() {
        if self.imageDownloadOperation != nil {
            if self.imageDownloadOperation!.isExecuting && !self.imageDownloadOperation!.isFinished {
                self.imageDownloadOperation?.cancel()
            }
        }
    }
    
}
