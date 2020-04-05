//
//  UserAPI.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

struct UserAPI: Codable {

    var id: Int?
    var name: String?
    var email: String?
    var token: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case token
        case image = "avatar"
    }
}

// MARK: - Mapper
extension UserAPI {
    
    static func map(data: Data) -> UserAPI? {
        guard let user = try? JSONDecoder().decode(UserAPI.self, from: data) else {
            return nil
        }
        
        return user
    }
}
