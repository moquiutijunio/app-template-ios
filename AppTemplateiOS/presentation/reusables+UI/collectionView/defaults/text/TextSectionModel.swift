//
//  TextSectionModel.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxCocoa

final class TextSectionModel: NSObject, TextViewModelProtocol {

    var text: String
    var font: UIFont?
    var textColor: UIColor
    var textBackgroundColor: UIColor
    var alignment: NSTextAlignment
    var heigth: CGFloat?
    
    init(text: String,
         font: UIFont?,
         textColor: UIColor,
         textBackgroundColor: UIColor,
         alignment: NSTextAlignment = .center,
         heigth: CGFloat? = nil) {
        
        self.text = text
        self.font = font
        self.heigth = heigth
        self.alignment = alignment
        self.textColor = textColor
        self.textBackgroundColor = textBackgroundColor
    }
}
