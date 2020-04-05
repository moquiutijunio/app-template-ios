//  
//  ForgotPasswordBuilder.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

enum ForgotPasswordBuilder {
 
    static func build(router: ForgotPasswordRouterProtocol) -> UIViewController {
        let repository = AuthenticationRepository()
        let interactor = ForgotPasswordInteractor(repository: repository)
        let presenter = ForgotPasswordPresenter(interactor: interactor)
        presenter.router = router
        
        return ForgotPasswordViewController(presenter: presenter)
    }
}
