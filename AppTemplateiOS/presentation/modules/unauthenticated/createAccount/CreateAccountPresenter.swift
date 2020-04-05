//  
//  CreateAccountPresenter.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IGListKit

protocol CreateAccountRouterProtocol: AnyObject {
    
    func goToPhotoPickerView(_ type: PhotoPickerType)
}

final class CreateAccountPresenter: BasePresenter {
    
    private let interactor: CreateAccountInteractorProtocol
    weak var router: CreateAccountRouterProtocol?
    
    private let createAccountButtonSubject = PublishSubject<Void>()
    
    init(interactor: CreateAccountInteractorProtocol) {
        self.interactor = interactor
        super.init()
    }
}

// MARK: - CreateAccountPresenterProtocol
extension CreateAccountPresenter: CreateAccountPresenterProtocol {
    
    var createAccountRequestResponse: Driver<Void> {
        return createAccountButtonSubject
            .flatMap { [unowned self] in self.interactor.createAccountRequestResponse }
            .do(onNext: { [weak self] (response) in
                guard let self = self else { return }
                self.newViewStateSubject.onNext(.normal)
                
                switch response {
                case .loading:
                    self.newViewStateSubject.onNext(.loading(PlaceholderViewModel(text: R.string.localizable.alertLoading(),
                                                                                  showOnNavigation: false)))
                    
                case .failure(let error):
                    self.alertSubject.onNext(AlertViewModel(title: R.string.localizable.alertTitle(),
                                                            message: error.localizedDescription,
                                                            actions: [AlertActionViewModel(title: R.string.localizable.ok())]))
                    
                default:
                    break
                }
            })
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
    }
    
    var newImagePickingResponse: Driver<Void> {
        return interactor.newImagePickingResponse
            .asDriver(onErrorJustReturn: ())
    }
}

// MARK: - CreateAccountViewModelProtocol
extension CreateAccountPresenter: CreateAccountViewModelProtocol {
    
    var image: BehaviorRelay<UIImage?> {
        return interactor.image
    }
    
    var name: BehaviorRelay<String?> {
        return interactor.name
    }
    
    var email: BehaviorRelay<String?> {
        return interactor.email
    }
    
    var password: BehaviorRelay<String?> {
        return interactor.password
    }
    
    var confirmePassword: BehaviorRelay<String?> {
        return interactor.confirmPassword
    }
    
    var createAccountButtonEnabled: Driver<Bool> {
        return interactor.createButtonEnabled
            .asDriver(onErrorJustReturn: false)
    }
    
    var nameErrorString: Driver<String?> {
        return interactor.nameErrors
            .asDriver(onErrorJustReturn: nil)
    }
    
    var emailErrorString: Driver<String?> {
        return interactor.emailErrors
            .asDriver(onErrorJustReturn: nil)
    }
    
    var passwordErrorString: Driver<String?> {
        return interactor.passwordErrors
            .asDriver(onErrorJustReturn: nil)
    }
    
    var confirmPasswordErrorString: Driver<String?> {
        return interactor.confirmPasswordErrors
            .asDriver(onErrorJustReturn: nil)
    }
    
    func avatarDidTap() {
        router?.goToPhotoPickerView(.createAccount)
    }
    
    func createAccountButtonDidTap() {
        createAccountButtonSubject.onNext(())
    }
}
