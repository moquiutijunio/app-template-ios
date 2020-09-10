//
//  APIClientHost.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

enum APIVersion {
    case v1
}

final class APPHosts {
        
    #if DEBUG
    static let domainURL = "staging.dietaetreino.jera.com.br"
    #else
    static let domainURL = "staging.dietaetreino.jera.com.br"
    #endif
    
    static var baseURLString = "http://\(domainURL)/api"
    static var appURL = URL(string: "itms-apps://itunes.apple.com/app/XXXXXX")! //TODO
    static var termsURL = URL(string: "http://\(domainURL)/responsabilidade-social")! //TODO
    static var policiesURL = URL(string: "http://\(domainURL)/responsabilidade-social")! //TODO
}
