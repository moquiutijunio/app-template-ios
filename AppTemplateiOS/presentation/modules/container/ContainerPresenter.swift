//  
//  ContainerPresenter.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxCocoa

enum ContentPageType {
    
    case unauthenticated
    case authenticated
}

protocol ContainerRouterProtocol: AnyObject {
    
    func updateCurrentPage(_ page: ContentPageType)
}

final class ContainerPresenter: BasePresenter {
    
    weak var router: ContainerRouterProtocol?
    private let interactor: ContainerInteractorProtocol
    
    init(interactor: ContainerInteractorProtocol) {
        self.interactor = interactor
        super.init()
    }
}

// MARK: - ContainerPresenterProtocol
extension ContainerPresenter: ContainerPresenterProtocol {
    
    var applicationStateDidChange: Driver<Void> {
        return interactor.applicationState
            .do(onNext: {[weak self] (appState) in
                guard let self = self else { return }
                
                switch appState {
                case .logged:
                    self.router?.updateCurrentPage(.authenticated)
                    
                case .expired,
                     .notLogged:
                    self.router?.updateCurrentPage(.unauthenticated)
                }
            })
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
    }
}
