//
//  ForgotPasswordSectionModel.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ForgotPasswordSectionModelCallbackProtocol: AnyObject {
        
    func forgotPasswordButtonDidTap()
}

final class ForgotPasswordSectionModel: NSObject {
    
    private weak var callback: ForgotPasswordSectionModelCallbackProtocol?

    let textRelay: BehaviorRelay<String?>
    let buttonIsEnable: Driver<Bool>
    let textFieldErrorString: Driver<String?>
    
    init(email: BehaviorRelay<String?>,
         emailErrorString: Observable<String?>,
         forgotButtonEnabled: Observable<Bool>,
         callback: ForgotPasswordSectionModelCallbackProtocol?) {
        
        self.textRelay = email
        self.textFieldErrorString = emailErrorString.asDriver(onErrorJustReturn: nil)
        self.buttonIsEnable = forgotButtonEnabled.asDriver(onErrorJustReturn: false)
        super.init()
        self.callback = callback
    }
}

// MARK: - TextViewModelProtocol
extension ForgotPasswordSectionModel: TextViewModelProtocol {
    
    var text: String {
        return R.string.localizable.forgotPasswordTitle()
    }
    
    var font: UIFont? {
        return UIFont.systemFont(ofSize: 12)
    }
    
    var textColor: UIColor {
        return .white
    }
    
    var textBackgroundColor: UIColor {
        return .clear
    }
    
    var alignment: NSTextAlignment {
        return .left
    }
}

// MARK: - TextViewModelProtocol
extension ForgotPasswordSectionModel: TextFieldViewModelProtocol {
    
    var keyboardType: UIKeyboardType {
        return .emailAddress
    }
    
    var textFieldPlaceholder: String? {
        return R.string.localizable.email()
    }
    
    var textContainerBackgroundColor: UIColor {
        return .clear
    }
    
    var fieldAccessibilityIdentifier: String? {
        return R.string.accessibilityIdentifier.forgotEmail()
    }
    
    var textFieldAppearance: TextFieldAppearance {
        return .main
    }
    
    var hasToolbar: Bool {
        return false
    }
}

// MARK: - TextViewModelProtocol
extension ForgotPasswordSectionModel: ButtonViewModelProtocol {
    
    var titleButton: String {
        return R.string.localizable.forgotPasswordSend().uppercased()
    }
    
    var buttonBackgroundColor: UIColor {
        return .clear
    }
    
    var buttonAppearance: RaisedButtonAppearance {
        return .main
    }
    
    var buttonAccessibilityIdentifier: String? {
        return R.string.accessibilityIdentifier.forgotSendButton()
    }
    
    func buttonDidTap() {
        callback?.forgotPasswordButtonDidTap()
    }
}
