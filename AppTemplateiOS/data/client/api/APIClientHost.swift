//
//  APIClientHost.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

final class APIClientHost {
    
    static let apiVersion = "v1"
    
    #if DEBUG
    static let baseURLString = "http://staging.dietaetreino.jera.com.br"
    #else
    static let baseURLString = "http://staging.dietaetreino.jera.com.br"
    #endif
    
    static var policiesURL = URL(string: "\(baseURLString)/responsabilidade-social")!
    static var termsURL = URL(string: "\(baseURLString)/responsabilidade-social")!
    static var baseURL = URL(string: "\(baseURLString)/api/\(apiVersion)")!
}
