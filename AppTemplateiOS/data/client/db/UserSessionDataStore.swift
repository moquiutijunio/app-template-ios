//
//  UserSessionDataStore.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

protocol UserSessionDataStoreProtocol {
    
    func creatUserSession(accessToken: String, currentUserDB: UserDB) -> UserSessionDB
    func retrieveUserSession() -> UserSessionDB?
    func updateSession(accessToken: String?, currentUser: UserDB?) throws -> UserSessionDB
    func deleteUserSession()
}

final class UserSessionDataStore {
    
    private let currentSessionKey = "current_session_key"
    
    private func saveCurrentSessionWith(userSession: UserSessionDB?) {
        KeyedArchiverManager.saveObjectWith(key: currentSessionKey, object: userSession)
    }
}

extension UserSessionDataStore: UserSessionDataStoreProtocol {
    
    func creatUserSession(accessToken: String, currentUserDB: UserDB) -> UserSessionDB {
        let newUserSession = UserSessionDB(accessToken: accessToken, currentUser: currentUserDB)
        saveCurrentSessionWith(userSession: newUserSession)
        return newUserSession
    }
    
    func retrieveUserSession() -> UserSessionDB? {
        return KeyedArchiverManager.retrieveObjectWith(key: currentSessionKey, type: UserSessionDB.self)
    }
    
    func updateSession(accessToken: String?, currentUser: UserDB?) throws -> UserSessionDB {
        guard let userSession = retrieveUserSession() else {
            throw AuthManagerError.noSession
        }
        
        let updatedUserSession = UserSessionDB(accessToken: accessToken ?? userSession.accessToken, currentUser: currentUser ?? userSession.currentUser)
        saveCurrentSessionWith(userSession: updatedUserSession)
        
        return updatedUserSession
    }
    
    func deleteUserSession() {
        saveCurrentSessionWith(userSession: nil)
    }
}
