//
//  SeparetorView+Extensions.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

enum SeparatorViewPosition {
    
    case top
    case bottom
    case left
    case right
    case center
}

extension UIView {
    
    class func separatorView(color: UIColor, height: CGFloat, insets: UIEdgeInsets) -> UIView {
        let separatorView = UIView()

        separatorView.backgroundColor = color

        constrain(separatorView) { (separatorView) -> () in
            separatorView.height == (height / UIScreen.main.nativeScale)
        }

        if insets != UIEdgeInsets.zero {
            return separatorView.containerViewWithInsets(insets: insets)
        }

        return separatorView
    }

    class func separatorView(color: UIColor, width: CGFloat, insets: UIEdgeInsets) -> UIView {
        let separatorView = UIView()

        separatorView.backgroundColor = color

        constrain(separatorView) { (separatorView) -> () in
            separatorView.width == (width / UIScreen.main.nativeScale)
        }

        if insets != UIEdgeInsets.zero {
            return separatorView.containerViewWithInsets(insets: insets)
        }

        return separatorView
    }

    func containerViewWithInsets(insets: UIEdgeInsets = UIEdgeInsets.zero) -> UIView {
        let containerView = UIView()
        containerView.addSubview(self)
        constrain(containerView, self) { (containerView, view) -> () in
            view.top == containerView.top + insets.top
            view.left == containerView.left + insets.left
            view.right == containerView.right - insets.right
            view.bottom == containerView.bottom - insets.bottom
        }

        return containerView
    }

    func addSeparatorsView(color: UIColor = .darkGray, size: CGFloat = 2, insets: UIEdgeInsets = .zero, positions: [SeparatorViewPosition]) {
        for position in positions {
            let separatorView: UIView
            
            switch position {
            case .bottom, .top, .center:
                separatorView = UIView.separatorView(color: color, height: size, insets: insets)
            case .right, .left:
                separatorView = UIView.separatorView(color: color, width: size, insets: insets)
            }

            let containerSeparatorView = separatorView.containerViewWithInsets(insets: insets)
            addSubview(containerSeparatorView)
            constrain(self, containerSeparatorView) { (view, containerSeparatorView) in
                switch position {
                case .top:
                    containerSeparatorView.left == view.left
                    containerSeparatorView.right == view.right
                    containerSeparatorView.top == view.top
                case .bottom:
                    containerSeparatorView.left == view.left
                    containerSeparatorView.right == view.right
                    containerSeparatorView.bottom == view.bottom
                case .right:
                    containerSeparatorView.top == view.top
                    containerSeparatorView.bottom == view.bottom
                    containerSeparatorView.right == view.right
                case .left:
                    containerSeparatorView.top == view.top
                    containerSeparatorView.bottom == view.bottom
                    containerSeparatorView.left == view.left
                case .center:
                    containerSeparatorView.left == view.left
                    containerSeparatorView.right == view.right
                    containerSeparatorView.center == view.center
                }
            }
        }
    }

}
