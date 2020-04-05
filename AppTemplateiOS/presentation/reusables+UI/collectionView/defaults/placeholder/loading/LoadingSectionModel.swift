//
//  LoadingSectionModel.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

final class LoadingSectionModel: NSObject, LoadingCollectionViewModelProtocol {
    
    var title: String
    var type: PlaceholderCellType
    
    init(title: String = "", type: PlaceholderCellType = .full) {
        self.title = title
        self.type = type
    }
}
