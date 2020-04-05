//  
//  CreateAccountInteractor.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CreateAccountInteractorProtocol {
    
    var image: BehaviorRelay<UIImage?> { get }
    var name: BehaviorRelay<String?> { get }
    var email: BehaviorRelay<String?> { get }
    var password: BehaviorRelay<String?> { get }
    var confirmPassword: BehaviorRelay<String?> { get }
    var nameErrors: Observable<String?> { get }
    var emailErrors: Observable<String?> { get }
    var passwordErrors: Observable<String?> { get }
    var confirmPasswordErrors: Observable<String?> { get }
    var createButtonEnabled: Observable<Bool> { get }
    var newImagePickingResponse: Observable<Void> { get }
    var createAccountRequestResponse: Observable<RequestResponse<Void>> { get }
}

final class CreateAccountInteractor: BaseInteractor {
 
    private let repository: CreateAccountRepositoryProtocol
    
    let image = BehaviorRelay<UIImage?>(value: nil)
    let name = BehaviorRelay<String?>(value: nil)
    let email = BehaviorRelay<String?>(value: nil)
    let password = BehaviorRelay<String?>(value: nil)
    let confirmPassword = BehaviorRelay<String?>(value: nil)
    
    public init(repository: CreateAccountRepositoryProtocol) {
        self.repository = repository
        super.init()
    }
}

// MARK: - CreateAccountInteractorProtocol
extension CreateAccountInteractor: CreateAccountInteractorProtocol {
    
    var nameErrors: Observable<String?> {
        return name
        .unwrap()
        .map { DefaultFieldError.isValid(text: $0) }
        .map { $0?.error }
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
    
    var confirmPasswordErrors: Observable<String?> {
        return Observable
        .combineLatest(password, confirmPassword) { (password, confirmPassword) -> ConfirmPasswordFieldError? in
            guard let password = password, let confirmPassword = confirmPassword else { return nil }
            return ConfirmPasswordFieldError.isValid(password: password, passwordConfirm: confirmPassword)
        }
        .map { $0?.error }
    }
    
    var createButtonEnabled: Observable<Bool> {
        return Observable
            .combineLatest(nameErrors, emailErrors, passwordErrors, confirmPasswordErrors) { (nameErrors, emailErrors, passwordErrors, confirmPasswordErrors) -> Bool in
                return !(nameErrors != nil || emailErrors != nil || passwordErrors != nil || confirmPasswordErrors != nil)
            }
    }
    
    var createAccountRequestResponse: Observable<RequestResponse<Void>> {
        guard let name = name.value, let email = email.value, let password = password.value else { return .just(.new) }
        
        let request = RegisterUserRequest(name: name, email: email, password: password, image: image.value)
        
        return repository
            .createAccount(request: request)
            .map { .success(()) }
            .catchError { .just(.failure($0)) }
            .asObservable()
            .startWith(.loading)
    }
    
    var newImagePickingResponse: Observable<Void> {
        return NotificationManager.shared
            .newImagePicking
            .do(onNext: { [weak self] (type, newImage) in
                guard let self = self else { return }
                
                if case .createAccount = type {
                    self.image.accept(newImage)
                }
            })
            .map { _ in }
    }
}
