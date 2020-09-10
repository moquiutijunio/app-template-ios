//
//  User.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

struct User {
    
    var id: Int
    var uid: String?
    var name: String?
    var email: String
    var token: String?
    var image: URL?
}

// MARK: - Mapper
extension User {
    
    static func map(user: UserAPI) -> User? {
        guard let id = user.id,
            let email = user.email else {
                return nil
        }
        
        var image: URL?
        if let imageString = user.image {
            image = URL(string: imageString)
        }
        
        return User(id: id,
                    uid: user.uid,
                    name: user.name,
                    email: email,
                    token: user.token,
                    image: image)
    }
    
    static func map(user: UserDB) -> User {
        
        var image: URL?
        if let imageString = user.image {
            image = URL(string: imageString)
        }
        
        return User(id: user.id,
                    uid: user.uid,
                    name: user.name,
                    email: user.email,
                    token: user.token,
                    image: image)
    }
    
    static func mapArray(users: [UserAPI]) -> [User] {
        return users
            .compactMap { User.map(user: $0) }
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.email == rhs.email &&
            lhs.image == rhs.image
    }
}
