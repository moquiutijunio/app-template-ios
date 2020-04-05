//
//  PlaceholderViewModel.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

enum PlaceholderType {
    case loading
    case error
}

enum LoadingViewType {
    case hud
    case full
}

struct PlaceholderViewModel {
    
    var text: String?
    var type: LoadingViewType
    var action: (() -> ())?
    var cancelAction: (() -> ())?
    var showOnNavigation: Bool
    
    init(text: String? = nil,
         type: LoadingViewType = .hud,
         showOnNavigation: Bool = true,
         action: (() -> ())? = nil,
         cancelAction: (() -> ())? = nil) {
        
        self.text = text
        self.type = type
        self.action = action
        self.cancelAction = cancelAction
        self.showOnNavigation = showOnNavigation
    }
}
