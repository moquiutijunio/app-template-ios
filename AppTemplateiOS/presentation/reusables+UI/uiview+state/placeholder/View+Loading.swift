//
//  LoadingView.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

final class LoadingView: UIView {
    
    private let loadingConstraintGroup = ConstraintGroup()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .customBlack()
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 20)
        textLabel.textColor = .customBlack(alpha: 0.64)
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    init(view: UIView, with viewModel: PlaceholderViewModel) {
        super.init(frame: .zero)
        
        setupView(parentView: view, with: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Setup Layout
extension LoadingView {
    
    private func setupView(parentView: UIView, with viewModel: PlaceholderViewModel) {
        
        switch viewModel.type {
        case .hud:
            backgroundColor = .customBlack()
            
            let hudView = UIView()
            hudView.layer.cornerRadius = 15
            hudView.backgroundColor = .white
            
            self.addSubview(hudView)
            self.addSubview(activityIndicatorView)
            constrain(self, hudView, activityIndicatorView, replace: loadingConstraintGroup) { (view, hudView, indicator) in
                hudView.height == 150
                hudView.width == 150
                
                hudView.center == view.center
                
                indicator.top == hudView.top + 40
                indicator.centerX == hudView.centerX
            }
            
        case .full:
            backgroundColor = .customBlack(alpha: 0.85)
            
            self.addSubview(activityIndicatorView)
            constrain(self, activityIndicatorView, replace: loadingConstraintGroup) { (view, indicator) in
                indicator.center == view.center
            }
        }
        
        if let text = viewModel.text {
            setupTextLabel()
            textLabel.text = text
        }
        
        parentView.addSubview(self)
        constrain(parentView, self) { (container, view) in
            view.edges == container.edges
        }
        
        self.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    
    private func setupTextLabel() {
        textLabel.removeFromSuperview()
        
        self.addSubview(textLabel)
        constrain(self, activityIndicatorView, textLabel) { (view, indicator, label) in
            label.top == indicator.bottom + 16
            label.centerX == view.centerX
        }
    }
}
