//
//  ParameterEncoder.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 20/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

class ParameterEncoder {
    
    var encoding: ParameterEncoding?
    var parameters: [String:Any]?
    
    init(parameters: [String: Any], encoding: ParameterEncoding) {
        self.parameters = parameters
    }
    
    func encode() -> Any? {
        switch encoding! {
        case .formEncoding:
            return formEncode(self.parameters!)
        case .jsonEncoding:
            return jsonEncode(self.parameters!)
        default:
            print("Unsupported Encoding")
            return nil
        }
    }
    
    func jsonEncode(_ parameters: [String:Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            return jsonData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func formEncode(_ parameters: [String:Any]) -> Data {
        var output: String = ""
        for (key,value) in parameters {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output.data(using: .utf8)!
    }
    
}
