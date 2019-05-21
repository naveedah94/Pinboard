//
//  NaNetworking.swift
//  Pinterest Board
//
//  Created by Indigo on 20/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

typealias NetworkCompletionHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

class NaNetworking {
    
    private var completionHandler: NetworkCompletionHandler?
    lazy var networkQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.naveed.nanetworkqueue"
        return queue
    }()
    
    static let shared = NaNetworking()
    private init() {}
    
    func createRequest(_ parameters: [String:Any]?, _ method: HTTPMethod = .get, _ encoding: ParameterEncoding = .urlEncoding, _ urlString: String, completion: @escaping NetworkCompletionHandler) {
        if urlString == "" {
            print("Oops Invalid URL Passed")
        }
        var url: URL?
        if let val = URL.init(string: urlString) {
            url = val
        }
        
        self.completionHandler = completion
        let request = self.getUrlRequest(url!, parameters, method, encoding)
        
        if let operationList = (networkQueue.operations as? [NaNetworkOperation])?.filter({$0.urlRequest.url!.absoluteString == url!.absoluteString && $0.isFinished == false && $0.isExecuting == true}), let operation = operationList.first {
            print("In progress url: " + url!.absoluteString)
            operation.queuePriority = .veryHigh
            
            let operation = NaNetworkOperation.init(urlRequest: request)
            operation.completionHandler = { (data, response, error) in
                DispatchQueue.main.async {
                    self.completionHandler?(data, response, error)
                }
            }
        } else {
            let operation = NaNetworkOperation.init(urlRequest: request)
            operation.completionHandler = { (data, response, error) in
                DispatchQueue.main.async {
                    self.completionHandler?(data, response, error)
                }
            }
            
            networkQueue.addOperation(operation)
        }
    }
    
    public func getJson(from data: Data) -> Any? {
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        print(responseJSON)
        return responseJSON
    }
    
    private func getUrlRequest(_ mURL: URL, _ parameters: [String:Any]?, _ method: HTTPMethod,  _ encoding: ParameterEncoding) -> URLRequest {
        var url = mURL
        var request = URLRequest(url: url)
        request.httpMethod = self.getMethodString(method)
        
        if let params = parameters {
            if encoding == .urlEncoding {
                if let val = parameters as? [String:String] {
                    url = url.append(val)
                } else {
                    print("Oops could not encode this data")
                }
            } else {
                if let val = ParameterEncoder.init(parameters: params, encoding: encoding).encode() as? Data {
                    request.httpBody = val
                } else {
                    //Encoding Failed
                    print("Oops could not encode this data")
                }
            }
        }
        
        request.setValue(self.getContentType(encoding), forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .returnCacheDataElseLoad
        
        return request
    }
    
    private func getContentType(_ encoding: ParameterEncoding) -> String {
        switch encoding {
        case .urlEncoding:
            return ""
        case .formEncoding:
            return "application/x-www-form-urlencoded"
        case .jsonEncoding:
            return "application/json"
        }
    }
    
    private func getMethodString(_ method: HTTPMethod) -> String {
        switch method {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        }
    }
    
    
    
    
    
    
//    public static func request(_ url: String, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) {
//
//    }
    
    
    
    
//    public static func request(_ url: URLConvertible,
//                               method: HTTPMethod = .get,
//                               parameters: Parameters? = nil,
//                               encoding: ParameterEncoding = URLEncoding.default,
//                               headers: HTTPHeaders? = nil) -> DataRequest {
//        return Session.default.request(url,
//                                       method: method,
//                                       parameters: parameters,
//                                       encoding: encoding,
//                                       headers: headers)
//    }
    
}

