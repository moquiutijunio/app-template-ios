//
//  APIOperators.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Moya
import RxSwift

struct SessionCredentials {
    
    var userEmail: String
    var userToken: String
}

extension Data {
    
    var asJSON: Result<[String: Any], NSError> {
        do {
            guard let JSONDict = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] else {
                return Result.failure(APIClient.error(description: R.string.localizable.messageGenericError()))
            }
            
            return Result.success(JSONDict)
            
        } catch let error as NSError {
            return Result.failure(error)
        }
    }
}

extension Moya.Response {
    
    var accessToken: String? {
        guard let response = response else { return nil }
        return response.allHeaderFields["token"] as? String
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func processResponse() -> Single<Moya.Response> {
        return flatMap({ (response) -> Single<Moya.Response> in
            
            if response.statusCode >= 200 && response.statusCode <= 299 {
                
                if let accessToken = response.accessToken, let _ = SessionManager.shared.retrieveUserSession() {
                    do {
                        try SessionManager.shared.updateSession(accessToken: accessToken, currentUser: nil)
                    } catch (let error) {
                        return .error(error)
                    }
                }
                
                return .just(response)
                
            } else {
                if response.statusCode == 401 {
                    SessionManager.shared.expireSession()
                }
                
                switch response.data.asJSON {
                case .success(let json):
                    
                    if let errorAPI = ErrorAPI.map(json: json) {
                        return .error(APIClient.error(description: errorAPI.localizedDescription, code: response.statusCode))
                        
                    } else {
                        return .error(APIClient.error(description: R.string.localizable.messageGenericError(), code: response.statusCode))
                    }
                    
                case .failure(let error):
                    return .error(error)
                }
            }
        })
    }
    
    func updateSession() -> Single<Moya.Response> {
        return flatMap { (response) -> Single<Moya.Response> in
            
            if let userAPI = UserAPI.map(data: response.data),
                let userDB = UserDB.map(userAPI: userAPI) {
                
                do {
                    try SessionManager.shared.createUserSession(accessToken: userAPI.token, currentUser: userDB)
                    return .just(response)
                    
                } catch(let error) {
                    return .error(error)
                }
            }
            
            return .error(APIClient.error(description: R.string.localizable.messageGenericError(), code: response.statusCode))
        }
    }
}
