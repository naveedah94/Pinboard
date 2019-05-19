//
//  NaDownloadManager.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 19/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation
import UIKit

typealias ImageDownloadHandler = (_ image: UIImage?, _ fromUrl: URL, _ error: Error?) -> Void

public class NaDownloadManager {
    
    private var completionHandler: ImageDownloadHandler?
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.naveed.nadownloadqueue"
        return queue
    }()
    let imageCache = NSCache<NSString, UIImage>()
    static let shared = NaDownloadManager()
    
    private init() {}
    
    func downloadImage(_ imageUrl: String, completion: @escaping ImageDownloadHandler) {
        self.completionHandler = completion
        guard let url = URL.init(string: imageUrl) else {
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.completionHandler?(cachedImage, url, nil)
        } else {
            if let operationList = (downloadQueue.operations as? [NaOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true}), let operation = operationList.first {
                print("In progress url: " + url.absoluteString)
                operation.queuePriority = .veryHigh
            } else {
                let operation = NaOperation.init(url: URL.init(string: imageUrl)!)
                operation.downloadHandler = { (image, url, error) in
                    if let mImage = image {
                        self.imageCache.setObject(mImage, forKey: url.absoluteString as NSString)
                    }
                    self.completionHandler?(image, url, error)
                }
                downloadQueue.addOperation(operation)
            }
        }
    }
    
}
