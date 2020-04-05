//
//  BaseCollectionReusableView.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

class BaseCollectionReusableView: UICollectionReusableView {

    static var nibName: String {
        return String(describing: self)
    }
}
