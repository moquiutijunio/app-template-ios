//
//  AuthenticationRepository.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift
import Foundation
import FirebaseMessaging

protocol LoginRepositoryProtocol {
    
    func sighInApple() -> Single<UserAPI>
    func sighInGoogle() -> Single<UserAPI>
    func sighInFacebook() -> Single<UserAPI>
    func sighInWith(email: String, password: String) -> Single<UserAPI>
}

protocol ForgotPasswordRepositoryProtocol {

    func forgotPasswordWith(email: String) -> Single<Void>
}

protocol CreateAccountRepositoryProtocol {

    func createAccount(request: RegisterUserRequest) -> Single<Void>
}

final class AuthenticationRepository: BaseRepository, LoginRepositoryProtocol, ForgotPasswordRepositoryProtocol, CreateAccountRepositoryProtocol {
    
    @available(iOS 13.0, *)
    private lazy var apiApple: APIAppleProtocol = APIApple()
    private lazy var apiFacebook: APIFacebookProtocol = APIFacebook()
    private lazy var apiGoogle: APIGoogleProtocol = APIGoogle()
    private lazy var firebaseMessaging = Messaging.messaging()
    
    func sighInFacebook() -> Single<UserAPI> {
        let fcmToken = Messaging.messaging().fcmToken
        
        return apiFacebook
            .signIn()
            .flatMap({[apiClient = apiClient] (fcToken) -> Single<UserAPI> in
                return apiClient.sighInFacebook(fcToken: fcToken, firebaseToken: fcmToken)
            })
    }
    
    func sighInGoogle() -> Single<UserAPI> {
        let fcmToken = firebaseMessaging.fcmToken
        
        return apiGoogle
            .signIn()
            .flatMap({[apiClient = apiClient] (ggToken) -> Single<UserAPI> in
                return apiClient.sighInGoogle(ggToken: ggToken, firebaseToken: fcmToken)
            })
    }
    
    func sighInApple() -> Single<UserAPI> {
        guard #available(iOS 13.0, *) else {
            return .error(APIClient.error(description: R.string.localizable.messageGenericError()))
        }
        
        let fcmToken = firebaseMessaging.fcmToken
        
        return apiApple
            .signIn()
            .flatMap({[apiClient = apiClient] (credential) -> Single<UserAPI> in
                return apiClient.sighInApple(email: credential.email,
                                             fullName: credential.fullName?.debugDescription,
                                             firebaseToken: fcmToken)
            })
    }
    
    func forgotPasswordWith(email: String) -> Single<Void> {
        return apiClient
            .forgotPassword(email: email)
    }
    
    func sighInWith(email: String, password: String) -> Single<UserAPI> {
        return apiClient
            .sighIn(email: email,
                    password: password,
                    token: firebaseMessaging.fcmToken)
    }
    
    func createAccount(request: RegisterUserRequest) -> Single<Void> {
        return apiClient
            .createAccount(request: request)
    }
}
