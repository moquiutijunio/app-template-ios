//
//  SingInAppleHandler.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 10/09/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift
import Foundation
import AuthenticationServices

protocol SingInAppleHandlerProtocol {
    func checkCredential()
}

@available(iOS 13.0, *)
class SingInAppleHandler: NSObject, SingInAppleHandlerProtocol {
    
    static let shared: SingInAppleHandlerProtocol = SingInAppleHandler()
    
    var disposeBag: DisposeBag!
    
    func checkCredential() {
        
        if let uid = SessionManager.shared.retrieveUserSession()?.currentUser.uid {
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: uid) { [weak self] (state, error) in
                guard let self = self else { return }
                
                if case .revoked = state {
                    self.disposeBag = DisposeBag()
                    
                    SessionRepository()
                        .logout()
                        .subscribe({ [weak self] (_) in
                            guard let self = self else { return }
                            self.logoutSession()
                        })
                        .disposed(by: self.disposeBag)
                }
            }
        }
    }
    
    private func logoutSession() {
        
        if let viewController = PresentationHelper.topViewController() as? BaseViewController {
            viewController.showToast(text: R.string.localizable.revokedSession())
        }
        
        SessionManager.shared.logout()
    }
}
