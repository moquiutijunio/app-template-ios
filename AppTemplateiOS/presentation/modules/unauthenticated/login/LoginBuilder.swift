//  
//  LoginBuilder.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

enum LoginBuilder {
 
    static func build(router: LoginRouterProtocol) -> UIViewController {
        let repository = AuthenticationRepository()
        let interactor = LoginInteractor(repository: repository)
        let presenter = LoginPresenter(interactor: interactor)
        presenter.router = router
        
        return LoginViewController(presenter: presenter)
    }
}
