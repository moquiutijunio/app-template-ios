//
//  BaseScrollViewController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 29/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

class BaseScrollViewController: BaseViewController {
    
    private var scrollViewConstraintGroup = ConstraintGroup()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = false
        view.keyboardDismissMode = .onDrag
        return view
    }()
        
    override func loadView() {
        super.loadView()
        
        addScrollView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenToKeyboard()
    }
    
    private func addScrollView() {
        
        view.addSubview(scrollView)
        constrain(view, scrollView, replace: scrollViewConstraintGroup) { (view, scroll) in
            scroll.left == view.left
            scroll.right == view.right
            scroll.top == view.top
            scroll.bottom == view.bottom
        }
    }
    
    internal func addChildViewToScrollView(childView: UIView, constraintBlock: ((ViewProxy, ViewProxy) -> Void)? = nil) {
        scrollView.addSubview(childView)
        
        if let constraintBlock = constraintBlock {
            constrain(scrollView, childView, block: constraintBlock)
            
        } else {
            constrain(scrollView, childView) { (scroll, subView) in
                subView.edges == scroll.edges
                subView.width == scroll.width
            }
        }
    }
}

// MARK: - Keyboard Notifications
extension BaseScrollViewController {
    
    override func keyboardWillShow(sender: NSNotification) {
        guard let keyboardValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrameCG = keyboardValue.cgRectValue
        let keyboarFrame = view.convert(keyboardFrameCG, from: view.window)

        scrollView.contentInset.bottom = keyboarFrame.height - bottomLayoutGuide.length + 30
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        scrollView.layoutIfNeeded()
    }
    
    override func keyboardWillHide(sender: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        scrollView.layoutIfNeeded()
    }
}
