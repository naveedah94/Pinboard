//
//  ImagePreFetchOperation.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 19/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

class ImagePreFetchOperation: Operation {
    
    let callback: ImagePreFetcher.Callback?
    
    let request: URLSessionDataTask
    
    private(set) var receivedData = Data()
    
    var url: URL? {
        return self.request.currentRequest?.url
    }
    
    init(_ request: URLSessionDataTask, callback: ImagePreFetcher.Callback?) {
        self.request = request
        self.callback = callback
    }
    
    override func start() {
        guard !self.isCancelled else { return }
        self.request.resume()
    }
    
    override func cancel() {
        self.request.cancel()
        super.cancel()
    }
    
    func onReceiveData(_ data: Data) {
        guard !self.isCancelled else { return }
        self.receivedData.append(data)
        
        guard data.count >= 2 else { return }
        
        do {
            if let result = try ImageSizeFetcherParser(sourceURL: self.url!, data) {
                self.callback?(nil,result)
                self.cancel()
            }
        } catch let err {
            self.callback?(err,nil)
            self.cancel()
        }
    }
    
    func onEndWithError(_ error: Error?) {
        self.callback?(ImageParserErrors.network(error),nil)
        self.cancel()
    }
    
}
