//
//  APIFacebook.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift
import RxCocoa
import FBSDKLoginKit

protocol APIFacebookProtocol {
    
    func signOut()
    func signIn() -> Single<String>
}

final class APIFacebook: APIFacebookProtocol {
    
    private static let facebookPermissions = ["public_profile", "email"]
    
    private let loginManager = LoginManager()
    
    func signIn() -> Single<String> {
        return Single.create(subscribe: {[weak self] (single) -> Disposable in
            guard let self = self, let fromViewController = PresentationHelper.topViewController() else {
                single(.error(APIClient.error(description: R.string.localizable.loginFacebookGenericError())))
                return Disposables.create()
            }
            
            self.loginManager.logIn(permissions: APIFacebook.facebookPermissions, from: fromViewController) { (result, error) -> Void in
                if let error = error {
                    single(.error(error))
                    
                } else if result?.isCancelled == true {
                    single(.error(APIClient.error(description: R.string.localizable.loginFacebookGenericError())))
                    
                } else {
                    if let result = result, let token = result.token {
                        single(.success(token.tokenString))
                        
                    } else {
                        single(.error(APIClient.error(description: R.string.localizable.loginFacebookGenericError())))
                    }
                }
            }
            
            return Disposables.create()
        })
    }
    
    func signOut() {
        loginManager.logOut()
    }
}
