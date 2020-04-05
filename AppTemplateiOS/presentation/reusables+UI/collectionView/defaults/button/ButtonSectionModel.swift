//
//  ButtonSectionModel.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ButtonSectionCallbackProtocol: AnyObject {
    
    func buttonDidTap()
}

final class ButtonSectionModel: NSObject {
    
    private weak var callback: ButtonSectionCallbackProtocol?
    
    var titleButton: String
    var buttonBackgroundColor: UIColor
    var buttonAppearance: RaisedButtonAppearance
    var buttonIsEnable: Driver<Bool>
    
    init(title: String,
         appearance: RaisedButtonAppearance,
         backgroundColor: UIColor = .clear,
         buttonIsEnable: Observable<Bool> = .just(true),
         callback: ButtonSectionCallbackProtocol?) {
        
        self.titleButton = title
        self.buttonAppearance = appearance
        self.buttonBackgroundColor = backgroundColor
        self.buttonIsEnable = buttonIsEnable.asDriver(onErrorJustReturn: true)
        super.init()
        self.callback = callback
    }
}

// MARK: - ButtonViewModelProtocol
extension ButtonSectionModel: ButtonViewModelProtocol {
    
    func buttonDidTap() {
        callback?.buttonDidTap()
    }
}
