//
//  NaNetworkOperation.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 20/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation
import UIKit

class NaNetworkOperation: Operation {
    
    var completionHandler: NetworkCompletionHandler?
    var urlRequest: URLRequest!
    
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
    
    required init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        
        self.executing(true)
        
        self.getDataFromService(self.urlRequest)
    }
    
    func getDataFromService(_ request: URLRequest) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            self.completionHandler?(data, response, error)
            self.finish(true)
            self.executing(false)
        }
        task.resume()
    }
    
}
