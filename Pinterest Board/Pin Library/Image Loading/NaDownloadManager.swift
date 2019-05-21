//
//  NaDownloadManager.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 19/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation
import UIKit

typealias ImageDownloadHandler = (_ image: UIImage?, _ fromUrl: URL, _ error: Error?, _ indexPath: IndexPath?) -> Void

public class NaDownloadManager {
    
    private var completionHandler: ImageDownloadHandler?
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.naveed.nadownloadqueue"
        return queue
    }()
    
    static let imageCache = NSCache<NSString, DiscardableImageItem>()
    private var maximumCacheSize = 3
    
    
    static let shared = NaDownloadManager()
    private init() {}
    
    func setMaximumCacheSize(_ maximumCacheSize: Int) {
        self.maximumCacheSize = maximumCacheSize
    }
    
    func getMaximumCacheSize() -> Int {
        return self.maximumCacheSize
    }
    
    func downloadImage(_ imageUrl: String, _ indexPath: IndexPath?, completion: @escaping ImageDownloadHandler) -> Operation? {
        self.completionHandler = completion
        guard let url = URL.init(string: imageUrl) else {
            return nil
        }
        
        if let cachedImage = self.getImageFromCache(url.absoluteString as NSString) {                self.completionHandler?(cachedImage.image, url, nil, indexPath)
            return nil
        } else {
            if let operationList = (downloadQueue.operations as? [NaOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true}), let operation = operationList.first {
                print("In progress url: " + url.absoluteString)
                operation.queuePriority = .veryHigh
                
                
                let mOperation = NaOperation.init(url: URL.init(string: imageUrl)!, indexPath: indexPath)
                mOperation.downloadHandler = { (image, url, error, indexPath) in
                    if let mImage = image {
                        self.addImageToCache(mImage, url.absoluteString as NSString)
                    }
                    self.completionHandler?(image, url, error, indexPath)
                }
                downloadQueue.addOperation(mOperation)
                return mOperation
                
            } else {
                let operation = NaOperation.init(url: URL.init(string: imageUrl)!, indexPath: indexPath)
                operation.downloadHandler = { (image, url, error, indexPath) in
                    if let mImage = image {
                        self.addImageToCache(mImage, url.absoluteString as NSString)
                    }
                    self.completionHandler?(image, url, error, indexPath)
                }
                downloadQueue.addOperation(operation)
                return operation
            }
        }
    }
    
    func getImageFromCache(_ url: NSString) -> DiscardableImageItem? {
        return NaDownloadManager.imageCache.object(forKey: url)
    }
    
    func addImageToCache(_ image: UIImage, _ url: NSString) {
        let item = DiscardableImageItem.init(image: image, imageUrlString: url as String)
        NaDownloadManager.imageCache.setObject(item, forKey: url)
    }
    
}
