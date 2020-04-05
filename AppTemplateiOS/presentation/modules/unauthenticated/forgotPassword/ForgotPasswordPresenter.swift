//  
//  ForgotPasswordPresenter.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IGListKit

protocol ForgotPasswordRouterProtocol: AnyObject {
    
}

final class ForgotPasswordPresenter: BasePresenter {
    
    private let interactor: ForgotPasswordInteractorProtocol
    weak var router: ForgotPasswordRouterProtocol?
    
    private let forgotPasswordButtonSubject = PublishSubject<Void>()
    
    init(interactor: ForgotPasswordInteractorProtocol) {
        self.interactor = interactor
        super.init()
    }
}

// MARK: - ForgotPasswordPresenterProtocol
extension ForgotPasswordPresenter: ForgotPasswordPresenterProtocol {
    
    var viewModels: [ListDiffable] {
        return [ForgotPasswordSectionModel(email: interactor.email,
                                           emailErrorString: interactor.emailErrorString,
                                           forgotButtonEnabled: interactor.forgotButtonEnabled,
                                           callback: self)]
    }
    
    var forgotPasswordRequestResponse: Driver<Void> {
        return forgotPasswordButtonSubject
            .flatMap { [unowned self] in self.interactor.forgotPasswordRequestResponse }
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
}

// MARK: - ForgotPasswordPresenterProtocol
extension ForgotPasswordPresenter: ForgotPasswordSectionModelCallbackProtocol {
    
    func forgotPasswordButtonDidTap() {
        forgotPasswordButtonSubject.onNext(())
    }
}
