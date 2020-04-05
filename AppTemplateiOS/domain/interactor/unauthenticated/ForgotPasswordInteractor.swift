//  
//  ForgotPasswordInteractor.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ForgotPasswordInteractorProtocol {
    
    var email: BehaviorRelay<String?> { get }
    var emailErrorString: Observable<String?> { get }
    var forgotButtonEnabled: Observable<Bool> { get }
    var forgotPasswordRequestResponse: Observable<RequestResponse<Void>> { get }
}

final class ForgotPasswordInteractor: BaseInteractor {
 
    private let repository: ForgotPasswordRepositoryProtocol
    
    let email = BehaviorRelay<String?>(value: nil)
    
    public init(repository: ForgotPasswordRepositoryProtocol) {
        self.repository = repository
        super.init()
    }
}

// MARK: - ForgotPasswordInteractorProtocol
extension ForgotPasswordInteractor: ForgotPasswordInteractorProtocol {
    
    var emailErrorString: Observable<String?> {
        return email
            .unwrap()
            .map { EmailFieldError.isValid(text: $0) }
            .map { $0?.error }
    }
    
    var forgotButtonEnabled: Observable<Bool> {
        return emailErrorString
            .map { $0 == nil }
    }
    
    var forgotPasswordRequestResponse: Observable<RequestResponse<Void>> {
        guard let email = email.value else { return .just(.new) }
        
        return repository
            .forgotPasswordWith(email: email)
            .map { .success(()) }
            .catchError { .just(.failure($0)) }
            .asObservable()
            .startWith(.loading)
    }
}
