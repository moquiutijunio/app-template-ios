//
//  APIClient.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Moya
import RxSwift

protocol APIClientProtocol {
    
    // MARK: - Authentication
    func sighIn(email: String, password: String, token: String?) -> Single<UserAPI>
    func sighInFacebook(fcToken: String, firebaseToken: String?) -> Single<UserAPI>
    func sighInGoogle(ggToken: String, firebaseToken: String?) -> Single<UserAPI>
    func sighInApple(email: String?, fullName: String?, firebaseToken: String?) -> Single<UserAPI>
    func createAccount(request: RegisterUserRequest) -> Single<Void>
    func forgotPassword(email: String) -> Single<Void>
    func logout() -> Single<Void>
    
    // MARK: - Dashboard
    
    // MARK: - Others
    func registerToken(token: String) -> Single<Void>
    func version() -> Single<VersionAPI>
}

final class APIClient: APIClientProtocol {
    
    // MARK: - Authentication
    
    func sighIn(email: String, password: String, token: String?) -> Single<UserAPI> {
        return provider.rx
            .request(.sighIn(email: email, password: password, token: token))
            .processResponse()
            .updateSession()
            .map(UserAPI.self)
    }
    
    func sighInFacebook(fcToken: String, firebaseToken: String?) -> Single<UserAPI> {
        return provider.rx
            .request(.sighInFacebook(facebookToken: fcToken, firebaseToken: firebaseToken))
            .processResponse()
            .updateSession()
            .map(UserAPI.self)
    }
    
    func sighInGoogle(ggToken: String, firebaseToken: String?) -> Single<UserAPI> {
        return provider.rx
            .request(.sighInGoogle(googleToken: ggToken, firebaseToken: firebaseToken))
            .processResponse()
            .updateSession()
            .map(UserAPI.self)
    }
    
    func sighInApple(email: String?, fullName: String?, firebaseToken: String?) -> Single<UserAPI> {
        return provider.rx
            .request(.sighInApple(email: email, fullName: fullName, firebaseToken: firebaseToken))
            .processResponse()
            .updateSession()
            .map(UserAPI.self)
    }
    
    func createAccount(request: RegisterUserRequest) -> Single<Void> {
        return provider.rx
            .request(.createAccount(request: request))
            .processResponse()
            .updateSession()
            .map { _ in }
    }
    
    func forgotPassword(email: String) -> Single<Void> {
        return provider.rx
            .request(.forgotPassword(email: email))
            .processResponse()
            .map { _ in }
    }
    
    func logout() -> Single<Void> {
        return provider.rx
            .request(.logout)
            .processResponse()
            .map { _ in }
    }
    
    // MARK: - Dashboard
    
    // MARK: - Others
    func registerToken(token: String) -> Single<Void> {
        return provider.rx
            .request(.registerToken(token: token))
            .processResponse()
            .map { _ in }
    }
    
    func version() -> Single<VersionAPI> {
       return provider.rx
          .request(.appVersion)
          .map(VersionAPI.self)
    }
}
