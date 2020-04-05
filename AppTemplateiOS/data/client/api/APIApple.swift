//
//  APIApple.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 31/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift
import AuthenticationServices

@available(iOS 13.0, *)
protocol APIAppleProtocol {
    
    func signIn() -> Single<ASAuthorizationAppleIDCredential>
}

@available(iOS 13.0, *)
final class APIApple: NSObject {
    
    fileprivate var signInSingle: ((SingleEvent<ASAuthorizationAppleIDCredential>) -> ())?
}

// MARK: - APIAppleProtocol
@available(iOS 13.0, *)
extension APIApple: APIAppleProtocol {
    
    func signIn() -> Single<ASAuthorizationAppleIDCredential> {
        
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let self = self else {
                single(.error(APIClient.error(description: R.string.localizable.loginGoogleGenericError())))
                return Disposables.create()
            }

            self.signInSingle = single
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()

            return Disposables.create(with: { [weak self] in
                guard let self = self else { return }
                self.signInSingle = nil
            })
        })
    }
}

// MARK: - ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension APIApple: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let signInSingle = signInSingle else { return }
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            signInSingle(.error(APIClient.error(description: R.string.localizable.loginGoogleGenericError())))
            return
        }
        
        signInSingle(.success(appleIDCredential))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let signInSingle = signInSingle else { return }
        
        signInSingle(.error(error))
    }
}
