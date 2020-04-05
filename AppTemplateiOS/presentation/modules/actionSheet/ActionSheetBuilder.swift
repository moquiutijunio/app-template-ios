//  
//  ActionSheetBuilder.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

enum ActionSheetBuilder {
    
    static func build(router: ActionSheetRouterProtocol, viewController: UIViewController) -> UIViewController {
        let presenter = ActionSheetPresenter(footerViewController: viewController)
        presenter.router = router
        return ActionSheetViewController(presenter: presenter)
    }
}
