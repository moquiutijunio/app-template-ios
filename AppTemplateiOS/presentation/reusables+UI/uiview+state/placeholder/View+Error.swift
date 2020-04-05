//
//  View+Error.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Material
import Cartography

final class ErrorView: UIView {
    
    private let errorViewConstraintGroup = ConstraintGroup()
    private var actionBlock: (() -> ())?
    private var cancelBlock: (() -> ())?
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 20)
        return textLabel
    }()
    
    private lazy var tryAgainButton: RaisedButton = {
        let button = RaisedButton()
        button.applyAppearance(.main,
                               title: R.string.localizable.tryAgain(),
                               cornerRadius: 22)
        return button
    }()
    
    private lazy var cancelButton: FlatButton = {
        let button = FlatButton()
        button.applyAppearance(.main,
                               title: R.string.localizable.cancel(),
                               titleFont: UIFont.systemFont(ofSize: 14))
        return button
    }()
    
    private lazy var confirmButton: RaisedButton = {
        let button = RaisedButton()
        button.applyAppearance(.main,
                               title: R.string.localizable.ok(),
                               cornerRadius: 22)
        return button
    }()
    
    init(view: UIView, with viewModel: PlaceholderViewModel) {
        super.init(frame: UIScreen.main.bounds)
        
        setupView(parentView: view, viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func dismiss() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { (finished) in
            self.removeFromSuperview()
        })
    }
}

// MARK: - Setup View
extension ErrorView {
    
    private func setupView(parentView: UIView, viewModel: PlaceholderViewModel) {
        backgroundColor = UIColor(white: 0, alpha: 0.85)
        textLabel.text = viewModel.text
        actionBlock = viewModel.action
        cancelBlock = viewModel.cancelAction
        cancelButton.isHidden = viewModel.cancelAction != nil ? false : true
        
        if viewModel.action != nil {
            setupTryAgainButton()
        } else {
            setupConfirmButton()
        }
        
        addSubview(textLabel)
        constrain(self, textLabel, replace: errorViewConstraintGroup) { (view, label) in
            label.center == view.center
            label.right >= view.right - 30
            label.left >= view.left + 30
        }
        
        parentView.addSubview(self)
        constrain(parentView, self) { (container, loading) in
            loading.edges == container.edges
        }
        
        self.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    
    private func setupTryAgainButton() {
        
        _ = tryAgainButton.rx.tap
            .takeUntil(rx.deallocated)
            .bind {[weak self] in
                guard let self = self else { return }
                guard let action = self.actionBlock else { return }
                
                action()
        }
        
        _ = cancelButton.rx.tap
            .takeUntil(rx.deallocated)
            .bind {[weak self] in
                guard let self = self else { return }
                
                if let cancel = self.cancelBlock {
                    cancel()
                }
                
                self.dismiss()
        }
        
        addSubview(cancelButton)
        addSubview(tryAgainButton)
        constrain(self, textLabel, tryAgainButton, cancelButton) { (view, label, button, cancel) in
            button.top == label.bottom + 16
            button.left == view.left + 30
            button.right == view.right - 30
            button.height == 44
            
            cancel.height == 30
            cancel.top == button.bottom + 8
            cancel.left == view.left + 30
            cancel.right == view.right - 30
        }
    }
    
    private func setupConfirmButton() {
        
        _ = confirmButton.rx.tap
            .takeUntil(rx.deallocated)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.dismiss()
        }
        
        addSubview(confirmButton)
        constrain(self, textLabel, confirmButton) { (view, label, button) in
            button.top == label.bottom + 16
            button.left == view.left + 30
            button.right == view.right - 30
            button.height == 44
        }
    }
}
