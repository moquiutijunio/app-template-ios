//
//  ErrorSectionModel.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

protocol ErrorSectionCallbackProtocol: AnyObject {
    
    func tryAgain()
}

final class ErrorSectionModel: NSObject, ErrorCollectionViewModelProtocol {
    
    let message: String
    let type: PlaceholderCellType
    private weak var callback: ErrorSectionCallbackProtocol?
    
    init(message: String, type: PlaceholderCellType = .full, callback: ErrorSectionCallbackProtocol?) {
        self.message = message
        self.type = type
        super.init()
        self.callback = callback
    }
    
    func tryAgainDidTap() {
        callback?.tryAgain()
    }
}
