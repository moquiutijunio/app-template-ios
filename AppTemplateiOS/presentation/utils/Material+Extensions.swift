//
//  Material+Extensions.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Material

// MARK: - TextField
enum TextFieldAppearance {
    
    case main
    case password
}

extension TextField {
    
    func applyAppearance(_ appearance: TextFieldAppearance,
                         text: String? = nil,
                         placeholder: String? = nil,
                         cornerRadius: CGFloat? = nil,
                         autocorrectionType: UITextAutocorrectionType = .yes,
                         textAlignment: NSTextAlignment = .left,
                         keyboardType: UIKeyboardType = .default,
                         font: UIFont = UIFont.systemFont(ofSize: 14),
                         detailsFont: UIFont = UIFont.systemFont(ofSize: 10),
                         placeholderFont: UIFont = UIFont.systemFont(ofSize: 14),
                         hasToolbar: Bool = true,
                         toolbarAction: @escaping (() -> ()) = {}) {
        
        self.font = font
        self.detailLabel.font = detailsFont
        self.placeholderLabel.font = placeholderFont
        self.autocorrectionType = autocorrectionType
        self.keyboardType = keyboardType
        self.textAlignment = textAlignment
        
        if let text = text {
            self.text = text
        }
        
        if let placeholder = placeholder {
            self.placeholder = placeholder
        }
        
        if hasToolbar {
            addToolBar(title: R.string.localizable.ok(), action: toolbarAction)
        }
        
        switch appearance {
        case .main:
            tintColor = .white
            textColor = .white
            backgroundColor = .clear
            isSecureTextEntry = false
            
            placeholderNormalColor = UIColor.white.withAlphaComponent(0.7)
            placeholderActiveColor = UIColor.white
            placeholderVerticalOffset = 20
            
            dividerColor = UIColor.white.withAlphaComponent(0.7)
            dividerNormalColor = UIColor.white.withAlphaComponent(0.3)
            dividerActiveColor = UIColor.white
            dividerContentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
            
            detailColor = Color.red.base
            detailVerticalOffset = -2
            
        case .password:
            tintColor = .white
            textColor = .white
            backgroundColor = .clear
            isSecureTextEntry = true
            
            placeholderNormalColor = UIColor.white.withAlphaComponent(0.7)
            placeholderActiveColor = UIColor.white
            placeholderVerticalOffset = 20
            
            dividerColor = UIColor.white.withAlphaComponent(0.7)
            dividerNormalColor = UIColor.white.withAlphaComponent(0.3)
            dividerActiveColor = UIColor.white
            dividerContentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
            
            detailColor = Color.red.base
            detailVerticalOffset = -2
        }
    }
}

// MARK: - RaisedButton
enum RaisedButtonAppearance {
    
    case main
    case google
    case facebook
}

extension RaisedButton {
    
    func applyAppearance(_ appearance: RaisedButtonAppearance,
                         title: String? = nil,
                         titleColor: UIColor = .white,
                         titleFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                         pulseColor: UIColor = .white,
                         backgroundColor: UIColor? = nil,
                         cornerRadius: CGFloat? = nil,
                         canStayDisable: Bool = true) {
        
        titleLabel?.font = titleFont
        setTitleColor(titleColor, for: .normal)
        self.pulseColor = pulseColor
        layer.cornerRadius = cornerRadius ?? 6
        clipsToBounds = true
        
        if let title = title {
            setTitleWithoutAnimation(title, for: .normal)
        }
        
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        if canStayDisable {
            setBackgroundImage(UIImage.fromColor(color: Color(white: 0.88, alpha: 0.46)), for: .disabled)
            setTitleColor(.white, for: .disabled)
        }
        
        switch appearance {
        case .main:
            self.backgroundColor = .primaryColor
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            
        case .google:
            self.pulseColor = .lightGray
            self.backgroundColor = .white
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            setTitleColor(.gray, for: .normal)
            
            setTitleWithoutAnimation(R.string.localizable.loginGoogle(), for: .normal)
            setImage(R.image.ic_google()?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        case .facebook:
            self.backgroundColor = UIColor(red: 0.23, green: 0.34, blue: 0.59, alpha: 1)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            setBackgroundImage(UIImage.fromColor(color: .white), for: .disabled)
            
            setTitleWithoutAnimation(R.string.localizable.loginFacebook(), for: .normal)
            setImage(R.image.ic_facebook()?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
}

// MARK: - UIButton and FlatButton
enum UIButtonAppearance {
    
    case main
}

extension FlatButton {
    
    func applyAppearance(_ appearance: UIButtonAppearance,
                         title: String? = nil,
                         titleColor: UIColor = .white,
                         titleFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                         pulseColor: UIColor = .white,
                         canStayDisable: Bool = true) {
        
        titleLabel?.font = titleFont
        setTitleColor(titleColor, for: .normal)
        self.pulseColor = pulseColor
        
        if let title = title {
            setTitleWithoutAnimation(title, for: .normal)
        }
        
        if canStayDisable {
            setTitleColor(Color(white: 0.74, alpha: 1), for: .disabled)
        }
        
        switch appearance {
        case .main:
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            
        }
    }
}

extension UIButton {
    
    func applyAppearance(_ appearance: UIButtonAppearance,
                         title: String? = nil,
                         titleColor: UIColor = .white,
                         titleFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                         backgroundColor: UIColor? = nil,
                         cornerRadius: CGFloat? = nil,
                         canStayDisable: Bool = true) {
        
        titleLabel?.font = titleFont
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = cornerRadius ?? 6
        clipsToBounds = true
        
        if let title = title {
            setTitleWithoutAnimation(title, for: .normal)
        }
        
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        if canStayDisable {
            setBackgroundImage(UIImage.fromColor(color: Color(white: 0.88, alpha: 0.46)), for: .disabled)
            setTitleColor(.white, for: .disabled)
        }
        
        switch appearance {
        case .main:
            self.backgroundColor = .primaryColor
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
    }
}
