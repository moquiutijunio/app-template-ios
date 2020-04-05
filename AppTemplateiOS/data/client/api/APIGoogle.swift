//
//  APIGoogle.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 31/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import GoogleSignIn
import RxSwift

protocol APIGoogleProtocol {
    
    func signIn() -> Single<String>
    func signOut() -> Single<Void>
}

final class APIGoogle: NSObject {
    
    override init() {
        super.init()
    
        GIDSignIn.sharedInstance().clientID = "1041540415130-on2o3sb4s4utlf0stll21ohhj9r5pkgr.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    fileprivate var signInSingle: ((SingleEvent<String>) -> ())?
    fileprivate var signOutSingle: ((SingleEvent<Void>) -> ())?
}

// MARK: - APIGoogleProtocol
extension APIGoogle: APIGoogleProtocol {
    
    func signIn() -> Single<String> {

        return Single.create(subscribe: {[weak self] (single) -> Disposable in
            guard let self = self else {
                single(.error(APIClient.error(description: R.string.localizable.loginGoogleGenericError())))
                return Disposables.create()
            }

            self.signInSingle = single
            GIDSignIn.sharedInstance().signIn()

            return Disposables.create(with: { [weak self] in
                guard let self = self else { return }
                self.signInSingle = nil
            })
        })
    }

    func signOut() -> Single<Void> {
        
        return Single.create(subscribe: {[weak self] (single) -> Disposable in
            guard let self = self else {
                single(.error(APIClient.error(description: R.string.localizable.loginGoogleGenericError())))
                return Disposables.create()
            }

            self.signOutSingle = single
            GIDSignIn.sharedInstance().signOut()

            return Disposables.create(with: { [weak self] in
                guard let self = self else { return }
                self.signInSingle = nil
            })
        })
    }
}

// MARK: - GIDSignInUIDelegate
extension APIGoogle: GIDSignInUIDelegate {

    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        guard let signInSingle = signInSingle, let error = error else { return }
        
        signInSingle(.error(error))
    }

    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        guard let fromViewController = PresentationHelper.topViewController() else {
            if let signInSingle = signInSingle {
                signInSingle(.error(APIClient.error(description: R.string.localizable.loginGoogleGenericError())))
            }
            
            return
        }
        
        fromViewController.present(viewController, animated: true, completion: nil)
    }

    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - GIDSignInDelegate
extension APIGoogle: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let signInSingle = signInSingle else { return }

        if let error = error {
            signInSingle(.error(error))
        } else {
            signInSingle(.success(user.authentication.accessToken))
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        guard let signOutSingle = signOutSingle else { return }

        if let error = error {
            signOutSingle(.error(error))
        } else {
            signOutSingle(.success(()))
        }
    }
}
