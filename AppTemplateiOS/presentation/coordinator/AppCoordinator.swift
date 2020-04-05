//
//  AppCoordinator.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    private var currentPage: ContentPageType?
    
    private lazy var containerViewController: ContainerViewController = {
        return ContainerBuilder.build(router: self)
    }()
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    func start() {
        window.rootViewController = containerViewController
        window.makeKeyAndVisible()
    }
    
    @available(iOS 13.0, *)
    func start(scene: UIWindowScene) {
        window.rootViewController = containerViewController
        window.makeKeyAndVisible()
        window.windowScene = scene
    }
}

extension AppCoordinator: ContainerRouterProtocol {
    
    func updateCurrentPage(_ page: ContentPageType) {
        guard page != currentPage else { return }
        
        switch page {
            
        case .unauthenticated:
            let authenticationCoordinator = AuthenticationCoordinator(callback: nil)
            containerViewController.setCurrentViewController(viewController: authenticationCoordinator.start())
            childCoordinator = authenticationCoordinator
            
        case .authenticated:
            let dashboardViewController = DashboardViewController()
            containerViewController.setCurrentViewController(viewController: dashboardViewController)
        }
        
        self.currentPage = page
    }
}
