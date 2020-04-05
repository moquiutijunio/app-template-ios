//  
//  LoginInteractor.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift
import RxCocoa

protocol LoginInteractorProtocol {
    
    var email: BehaviorRelay<String?> { get }
    var password: BehaviorRelay<String?> { get }
    var emailErrors: Observable<String?> { get }
    var passwordErrors: Observable<String?> { get }
    var loginButtonEnabled: Observable<Bool> { get }
    var signInRequesResponse: Observable<RequestResponse<Void>> { get }
    
    func signIn()
    func signInApple()
    func signInGoogle()
    func signInFacebook()
}

final class LoginInteractor: BaseInteractor {
 
    private let repository: LoginRepositoryProtocol
    
    private var signInDisposeBag: DisposeBag!
    
    let email = BehaviorRelay<String?>(value: nil)
    let password = BehaviorRelay<String?>(value: nil)
    private let signInRequesResponseSubject = BehaviorSubject<RequestResponse<Void>>(value: .new)
    
    public init(repository: LoginRepositoryProtocol) {
        self.repository = repository
        super.init()
    }
    
    private func sighIn(request: Single<UserAPI>) {
        signInDisposeBag = DisposeBag()
        signInRequesResponseSubject.onNext(.loading)
                
        request
            .subscribe({[weak self] (event) in
                guard let self = self else { return }

                switch event {
                case .success:
                    self.signInRequesResponseSubject.onNext(.success(()))

                case .error(let error):
                    self.signInRequesResponseSubject.onNext(.failure(error))
                }
            })
            .disposed(by: signInDisposeBag)
    }
}

// MARK: - LoginInteractorProtocol
extension LoginInteractor: LoginInteractorProtocol {
    
    var signInRequesResponse: Observable<RequestResponse<Void>> {
        return signInRequesResponseSubject
    }
    
    var emailErrors: Observable<String?> {
        return email
            .unwrap()
            .map { EmailFieldError.isValid(text: $0) }
            .map { $0?.error }
    }
    
    var passwordErrors: Observable<String?> {
        return password
            .unwrap()
            .map { PasswordFieldError.isValid(text: $0) }
            .map { $0?.error }
    }
    
    var loginButtonEnabled: Observable<Bool> {
        return Observable
            .combineLatest(emailErrors, passwordErrors) { (emailErrors, passwordErrors) -> Bool in
                return !(emailErrors != nil || passwordErrors != nil)
            }
    }
    
    func signInGoogle() {
        //https://developers.google.com/identity/sign-in/ios
        print("TODO *** Configurar Google Sing in ***")
        sighIn(request: repository.sighInGoogle())
    }
    
    func signInFacebook() {
        //https://developers.facebook.com/docs/swift/
        print("TODO *** Configurar Facebook Sing in ***")
        sighIn(request: repository.sighInFacebook())
    }
    
    func signIn() {
        guard let email = email.value, let password = password.value else { return /*Error not happen*/ }
        
        sighIn(request: repository.sighInWith(email: email, password: password))
    }
    
    func signInApple() {
        sighIn(request: repository.sighInApple())
    }
}
