//
//  NaImageOperation.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 20/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation
import UIKit

class NaOperation: Operation {
    
    var downloadHandler: ImageDownloadHandler?
    var imageUrl: URL!
    var indexPath: IndexPath?
    
    override var isAsynchronous: Bool {
        get {
            return true
        }
    }
    
    private var mExecuting = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return mExecuting
    }
    
    private var mFinished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return mFinished
    }
    
    func executing(_ executing: Bool) {
        mExecuting = executing
    }
    
    func finish(_ finished: Bool) {
        mFinished = finished
    }
    
    required init(url: URL, indexPath: IndexPath?) {
        self.imageUrl = url
        self.indexPath = indexPath
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        
        self.executing(true)
        
        self.downloadImageFromUrl(self.imageUrl)
    }
    
    func downloadImageFromUrl(_ url: URL) {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: self.imageUrl) { (url, response, error) in
            if let mUrl = url, let data = try? Data.init(contentsOf: mUrl) {
                let image = UIImage.init(data: data)
                self.downloadHandler?(image, self.imageUrl, error, self.indexPath)
            }
            self.finish(true)
            self.executing(false)
        }
        downloadTask.resume()
    }
    
}
