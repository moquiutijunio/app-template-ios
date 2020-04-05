//
//  AlertViewModel.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

struct AlertViewModel {
    
    var title: String?
    var message: String?
    var barButtonPosition: NavigationbarPosition?
    var preferredStyle: UIAlertController.Style
    var alertActions: [AlertActionViewModel]
    
    init(title: String? = nil,
         message: String? = nil,
         barButtonPosition: NavigationbarPosition? = nil,
         preferredStyle: UIAlertController.Style = .alert,
         actions: [AlertActionViewModel] = []) {
        
        self.title = title
        self.message = message
        self.barButtonPosition = barButtonPosition
        self.preferredStyle = preferredStyle
        self.alertActions = actions
    }
}

struct AlertActionViewModel {
    
    var title: String
    var actionType: UIAlertAction.Style
    var action: (() -> ())?
    
    init(title: String,
         actionType: UIAlertAction.Style = .`default`,
         action: (() -> ())? = nil) {
        
        self.title = title
        self.actionType = actionType
        self.action = action
    }
    
    func transform() -> UIAlertAction {
        
        return UIAlertAction(title: title, style: actionType, handler: { (_) in
            guard let action = self.action else { return }
            action()
        })
    }
}
