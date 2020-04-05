//
//  BaseCollectionViewCell.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    internal var disposeBag: DisposeBag!
    
    static var nibName: String {
        return String(describing: self)
    }
    
    internal static var staticCell: BaseCollectionViewCell {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil).first! as! BaseCollectionViewCell
    }
    
    func roundWith(index: Int, totalIndex: Int) {
        if totalIndex == 1 {
            round(cornerRadius: 4)
        } else if index == 0 {
            round(cornerRadius: 4, corners: [.topLeft, .topRight])
        } else if index == totalIndex-1 {
            round(cornerRadius: 4, corners: [.bottomLeft, .bottomRight])
        }
    }
}
