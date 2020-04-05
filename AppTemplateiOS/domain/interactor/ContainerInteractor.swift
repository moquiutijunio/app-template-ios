//
//  ContainerInteractor.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift

enum ApplicationState {
    
    case logged
    case notLogged
    case expired
}

protocol ContainerInteractorProtocol {
    
    var applicationState: Observable<ApplicationState> { get }
}

final class ContainerInteractor: BaseInteractor {
    
    private let repository: SessionRepositoryProtocol
    
    init(repository: SessionRepositoryProtocol) {
        self.repository = repository
        super.init()
    }
}

extension ContainerInteractor: ContainerInteractorProtocol {
    
    var applicationState: Observable<ApplicationState> {
        return repository.sessionState
            .map { (sessionState) -> ApplicationState in
                
                switch sessionState {
                case .hasSession: return .logged
                case .notHaveSession: return .notLogged
                case .sessionExpired: return .expired
                }
        }
    }
}
