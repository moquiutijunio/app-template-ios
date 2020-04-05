//
//  AuthenticationCoordinator.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

final class AuthenticationCoordinator: BaseNavigableCoordinator, CoordinatorProtocol {
    
    func start() -> UIViewController {
        showLogin()
        return navigationController
    }
    
    private func showLogin() {
        let loginController = LoginBuilder.build(router: self)
        navigationController.setViewControllers([loginController], animated: true)
    }
}

// MARK: - LoginRouterProtocol
extension AuthenticationCoordinator: LoginRouterProtocol {
    
    func goToForgotPassword() {
        let forgotPasswordController = ForgotPasswordBuilder.build(router: self)
        navigationController.push(viewController: forgotPasswordController)
    }
    
    func goToCreateAccount() {
        let createAccountController = CreateAccountBuilder.build(router: self)
        navigationController.push(viewController: createAccountController)
    }
}

// MARK: - ForgotPasswordRouterProtocol
extension AuthenticationCoordinator: ForgotPasswordRouterProtocol {

}

// MARK: - CreateAccountRouterProtocol
extension AuthenticationCoordinator: CreateAccountRouterProtocol {

}
