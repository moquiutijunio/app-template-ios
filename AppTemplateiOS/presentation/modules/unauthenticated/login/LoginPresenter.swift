//  
//  LoginPresenter.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxCocoa

protocol LoginRouterProtocol: AnyObject {
    
    func goToForgotPassword()
    func goToCreateAccount()
}

final class LoginPresenter: BasePresenter {
    
    private let interactor: LoginInteractorProtocol
    weak var router: LoginRouterProtocol?
    
    init(interactor: LoginInteractorProtocol) {
        self.interactor = interactor
        super.init()
    }
}

// MARK: - LoginPresenterProtocol
extension LoginPresenter: LoginPresenterProtocol {
    
    var signInRequesResponse: Driver<Void> {
        return interactor.signInRequesResponse
            .do(onNext: { [weak self] (response) in
                guard let self = self else { return }
                self.newViewStateSubject.onNext(.normal)
                
                switch response {
                case .loading:
                    self.newViewStateSubject.onNext(.loading(PlaceholderViewModel(text: R.string.localizable.alertLoading())))
                    
                case .failure(let error):
                    self.alertSubject.onNext(AlertViewModel(title: R.string.localizable.alertTitle(),
                                                            message: error.localizedDescription,
                                                            actions: [AlertActionViewModel(title: R.string.localizable.ok())]))
                    
                default: break
                }
            })
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
    }
}

// MARK: - LoginViewModelProtocol
extension LoginPresenter: LoginViewModelProtocol {
    
    var email: BehaviorRelay<String?> {
        return interactor.email
    }
    
    var password: BehaviorRelay<String?> {
        return interactor.password
    }
    
    var emailErrorString: Driver<String?> {
        return interactor.emailErrors
            .asDriver(onErrorJustReturn: nil)
    }
    
    var passwordErrorString: Driver<String?> {
        return interactor.passwordErrors
            .asDriver(onErrorJustReturn: nil)
    }
    
    var loginButtonEnabled: Driver<Bool> {
        return interactor.loginButtonEnabled
            .asDriver(onErrorJustReturn: false)
    }
    
    func loginButtonDidTap() {
        interactor.signIn()
    }
    
    func appleButtonDidTap() {
        interactor.signInApple()
    }
    
    func googleButtonDidTap() {
        interactor.signInGoogle()
    }
    
    func facebookButtonDidTap() {
        interactor.signInFacebook()
    }
    
    func createAccountButtonDidTap() {
        router?.goToCreateAccount()
    }
    
    func forgotPasswordButtonDidTap() {
        router?.goToForgotPassword()
    }
}
