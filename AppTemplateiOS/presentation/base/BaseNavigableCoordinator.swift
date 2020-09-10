//
//  BaseNavigableCoordinator.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

class BaseNavigableCoordinator: BaseCoordinator {
    
    internal var navigationController = BaseNavigationController()
    internal var photoPickerOrigin: PhotoPickerOrigin!
    
    init(callback: BaseCoordinatorCallbackProtocol?) {
        super.init()
        self.callback = callback
    }
    
    internal func showActionSheetWith(viewController: UIViewController) {
        let actionSheetViewController = ActionSheetBuilder.build(router: self, viewController: viewController)
        self.navigationController.present(actionSheetViewController, animated: true)
        self.actionSheetViewController = actionSheetViewController
    }

    func popRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func popWith(message: String) {
        navigationController.popViewController(animated: true)
        
        if let vc = navigationController.viewControllers.last as? BaseViewController {
            vc.showToast(text: message)
        }
    }
    
    func dismissWithoutAnimated() {
        navigationController.dismiss(animated: false) {
            self.callback?.shouldDismissCoordinator()
        }
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true) {
            self.callback?.shouldDismissCoordinator()
        }
    }
    
    func dismissWith(message: String) {
        navigationController.dismiss(animated: true) {
            self.callback?.shouldDismissCoordinatorWith(message: message)
        }
    }
    
    func dismissWith(action: @escaping (() -> Void)) {
        navigationController.dismiss(animated: true) {
            self.callback?.shouldDismissCoordinator()
            action()
        }
    }
    
    override func shouldDismissCoordinatorWith(message: String) {
        childCoordinator = nil
        
        if let vc = navigationController.viewControllers.last as? BaseViewController {
            vc.showToast(text: message)
        }
    }
    
    override func dismissActionSheetWith(message: String) {
        dismissActionSheetIfNeeded {[unowned self] in
            self.shouldDismissCoordinatorWith(message: message)
        }
    }
}

// MARK: - UINavigationController
extension UINavigationController {
    
    func push(viewController: UIViewController, animated: Bool = true, hidesBottomBarWhenPushed: Bool = true) {
        viewController.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
        self.pushViewController(viewController, animated: animated)
    }
}
