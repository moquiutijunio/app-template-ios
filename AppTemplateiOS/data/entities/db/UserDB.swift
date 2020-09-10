//
//  UserDB.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

class UserDB: NSObject, NSCoding {
    
    var id: Int
    var uid: String?
    var name: String?
    var email: String
    var token: String?
    var image: String?
    
    init(id: Int,
         uid: String?,
         name: String?,
         email: String,
         token: String?,
         image: String?) {
        
        self.id = id
        self.uid = uid
        self.name = name
        self.email = email
        self.token = token
        self.image = image
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let email = aDecoder.decodeObject(forKey: "email") as? String else { return nil }
            
        let id = aDecoder.decodeInteger(forKey: "id")
        let uid = aDecoder.decodeObject(forKey: "uid") as? String
        let name = aDecoder.decodeObject(forKey: "name") as? String
        let token = aDecoder.decodeObject(forKey: "token") as? String
        let image = aDecoder.decodeObject(forKey: "image") as? String
        
        self.init(id: id,
                  uid: uid,
                  name: name,
                  email: email,
                  token: token,
                  image: image)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(image, forKey: "image")
    }
}

// MARK: - Mapper
extension UserDB {
    
    static func map(userAPI: UserAPI) -> UserDB? {
        guard let id = userAPI.id,
            let email = userAPI.email else {
            return nil
        }
        
        return UserDB(id: id,
                      uid: userAPI.uid,
                      name: userAPI.name,
                      email: email,
                      token: userAPI.token,
                      image: userAPI.image)
    }
    
    static func map(user: User?) -> UserDB? {
        guard let user = user else {
            return nil
        }
        
        return UserDB(id: user.id,
                      uid: user.uid,
                      name: user.name,
                      email: user.email,
                      token: user.token,
                      image: user.image?.description)
    }
}
