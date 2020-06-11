//
//  BaseCoordinator.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit 

protocol BaseCoordinatorCallbackProtocol: AnyObject {
    
    func shouldDismissCoordinator()
    func shouldDismissCoordinatorWith(message: String)
}

protocol CoordinatorProtocol: AnyObject {
    
    func start() -> UIViewController
    func start(navigationController: BaseNavigationController)
}

extension CoordinatorProtocol {
    
    func start(navigationController: BaseNavigationController) {
        fatalError("The coordinator needs implement this method")
    }
}

class BaseCoordinator: NSObject {
    
    weak var callback: BaseCoordinatorCallbackProtocol?
    
    var childCoordinator: CoordinatorProtocol?
    var actionSheetViewController: UIViewController?
    
    internal func dismissActionSheetIfNeeded(action: @escaping (() -> Void)) {
        if let actionSheetViewController = actionSheetViewController {
            actionSheetViewController.dismiss(animated: true) {[unowned self] in
                self.actionSheetViewController = nil
                self.childCoordinator = nil
                action()
            }
        } else {
            action()
        }
    }
    
    func shouldDismissCoordinatorWith(message: String) {
        fatalError("this coordinator should be BaseNavigableCoordinator")
    }
    
    func dismissActionSheetWith(message: String) {
        fatalError("this coordinator should be BaseNavigableCoordinator")
    }
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}

// MARK: - BaseCoordinatorCallbackProtocol
extension BaseCoordinator: BaseCoordinatorCallbackProtocol {
    
    func shouldDismissCoordinator() {
        self.childCoordinator = nil
    }
}

// MARK: - ActionSheetRouterProtocol
extension BaseCoordinator: ActionSheetRouterProtocol {
    
    func dismissActionSheet() {
        dismissActionSheetIfNeeded {
            //Do nothing
        }
    }
}
