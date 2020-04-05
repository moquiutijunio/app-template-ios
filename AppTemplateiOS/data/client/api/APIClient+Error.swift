//
//  APIClient+Error.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

extension APIClient {
    
    static let errorDomain = "APIClient"
    
    static func error(description: String, code: Int = 0) -> NSError {
        return NSError(domain: errorDomain,
                       code: code,
                       userInfo: [NSLocalizedDescriptionKey: description])
    }
}
