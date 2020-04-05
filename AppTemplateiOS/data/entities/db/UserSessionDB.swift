//
//  UserSessionDB.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

class UserSessionDB: NSObject, NSCoding {
    
    private(set) var accessToken: String
    private(set) var currentUser: UserDB
    
    init(accessToken: String, currentUser: UserDB) {
        self.accessToken = accessToken
        self.currentUser = currentUser
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String,
            let currentUser = aDecoder.decodeObject(forKey: "currentUser") as? UserDB else {
                return nil
        }
        
        self.init(accessToken: accessToken, currentUser: currentUser)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(currentUser, forKey: "currentUser")
    }
}
