//
//  NaUtils.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 20/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

extension URL {
    
    func append(_ parameters: [String:String]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        for (key,value) in parameters {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
}
