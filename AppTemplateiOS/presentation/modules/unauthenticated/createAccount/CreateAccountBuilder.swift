//  
//  CreateAccountBuilder.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

enum CreateAccountBuilder {
 
    static func build(router: CreateAccountRouterProtocol) -> UIViewController {
        let repository = AuthenticationRepository()
        let interactor = CreateAccountInteractor(repository: repository)
        let presenter = CreateAccountPresenter(interactor: interactor)
        presenter.router = router
        
        return CreateAccountViewController(presenter: presenter)
    }
}
