//
//  ErrorAPI.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

struct ErrorAPI: Codable {
    
    var message: String?
    var error: String?
    var errors: [String]?
    
    var localizedDescription: String {
        var errorsAPI = [String]()
        
        if let message = message {
            errorsAPI.append(message)
        }
        
        if let error = error {
            errorsAPI.append(error)
        }
        
        if let errors = errors {
            if errors.count > 1 {
                errorsAPI.append(contentsOf: errors.map({ (error) -> String in
                    return "- \(error)"
                }))
            } else {
                errorsAPI.append(contentsOf: errors)
            }
        }
        
        if errorsAPI.isEmpty {
            return R.string.localizable.messageGenericError()
            
        } else {
            return errorsAPI.joined(separator: "\n")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case errors
        case error
        case message
    }
}

// MARK: - Mapper
extension ErrorAPI {
    
    static func map(json: [String: Any]) -> ErrorAPI? {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
            let error = try? JSONDecoder().decode(ErrorAPI.self, from: data) else {
            return nil
        }
        
        return error
    }
}
