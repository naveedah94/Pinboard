//
//  ImagePreFetcher.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 19/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit

public class ImagePreFetcher: NSObject, URLSessionDataDelegate {
    
    public typealias Callback = ((Error?, ImageSizeFetcherParser?) -> (Void))
    
    private var session: URLSession!
    
    private var queue = OperationQueue()
    
    /// Built-in in memory cache
    private var cache = NSCache<NSURL,ImageSizeFetcherParser>()
    
    public var timeout: TimeInterval
    

    public init(configuration: URLSessionConfiguration = .ephemeral, timeout: TimeInterval = 5) {
        self.timeout = timeout
        super.init()
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    public func sizeFor(atURL url: URL, force: Bool = false, _ callback: @escaping Callback) {
        guard force == false, let entry = cache.object(forKey: (url as NSURL)) else {
            // we don't have a cached result or we want to force download
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: self.timeout)
            let op = ImagePreFetchOperation(self.session.dataTask(with: request), callback: callback)
            queue.addOperation(op)
            return
        }
        callback(nil,entry)
    }
    
    private func operation(forTask task: URLSessionTask?) -> ImagePreFetchOperation? {
        return (self.queue.operations as! [ImagePreFetchOperation]).first(where: { $0.url == task?.currentRequest?.url })
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        operation(forTask: dataTask)?.onReceiveData(data)
    }
    
    public func urlSession(_ session: URLSession, task dataTask: URLSessionTask, didCompleteWithError error: Error?) {
        operation(forTask: dataTask)?.onEndWithError(error)
    }
}
