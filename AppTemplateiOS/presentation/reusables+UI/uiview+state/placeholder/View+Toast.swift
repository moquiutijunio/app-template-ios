//
//  View+Toast.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

final class ToastView: UIView {
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    init(view: UIView, text: String, bottomGuide: Cartography.LayoutSupport) {
        super.init(frame: UIScreen.main.bounds)
        
        setupView(parentView: view, text: text, bottomGuide: bottomGuide)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func dismissAnimation() {
        UIView.animate(withDuration: 0.5, delay: 3, animations: {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 0
            }, completion: {[weak self] (finished) in
                guard let strongSelf = self else { return }
                strongSelf.removeFromSuperview()
        })
    }
}

// MARK: - Setup View
extension ToastView {
    
    private func setupView(parentView: UIView, text: String, bottomGuide: Cartography.LayoutSupport) {
        textLabel.text = text
        layer.cornerRadius = 4
        backgroundColor = UIColor(white: 0.2, alpha: 1)
        
        self.addSubview(textLabel)
        constrain(self, textLabel) { (container, label) in
            label.top == container.top + 16
            label.bottom == container.bottom - 16
            label.right == container.right - 16
            label.left == container.left + 16
        }
        
        parentView.addSubview(self)
        constrain(parentView, self, bottomGuide) { (container, toast, bottomGuide) in
            toast.bottom == bottomGuide.top - 24
            toast.centerX == container.centerX
        }
        
        self.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
            
        }, completion: { (finished) in
            if finished {
                self.dismissAnimation()
            }
        })
    }
}
