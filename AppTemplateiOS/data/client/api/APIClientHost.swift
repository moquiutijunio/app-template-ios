//
//  APIClientHost.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

final class APIClientHost {
    
    static let apiVersion = "/v1"
    
    #if DEBUG
    static let baseURLString = "https://staging.dietaetreino.jera.com.br/api\(apiVersion)"
    #else
    static let baseURLString = "https://staging.dietaetreino.jera.com.br/api\(apiVersion)"
    #endif
    
    static var policies = URL(string: "https://jera.com.br/responsabilidade-social")!
    static var terms = URL(string: "https://jera.com.br/responsabilidade-social")!
    static var baseURL = URL(string: "\(baseURLString)")!
}
