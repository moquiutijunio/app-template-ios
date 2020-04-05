//
//  EmptySectionModel.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

final class EmptySectionModel: NSObject, EmptyCollectionViewModelProtocol {
    
    let message: String
    let type: PlaceholderCellType
    
    init(message: String, type: PlaceholderCellType = .full) {
        self.message = message
        self.type = type
        super.init()
    }
}
