//  
//  ContainerBuilder.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

enum ContainerBuilder {
    
    static func build(router: ContainerRouterProtocol) -> ContainerViewController {
        let repository = SessionRepository()
        let interactor = ContainerInteractor(repository: repository)
        let presenter = ContainerPresenter(interactor: interactor)
        presenter.router = router
        
        return ContainerViewController(presenter: presenter)
    }
}
