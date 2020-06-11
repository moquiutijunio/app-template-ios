//  
//  ActionSheetViewController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

protocol ActionSheetPresenterProtocol: BasePresenterProtocol {
    
    var footerViewController: UIViewController { get }
    func didTapOutsideBottomView()
}

final class ActionSheetViewController: BaseViewController {
    
    private var presenter: ActionSheetPresenterProtocol {
        return basePresenter as! ActionSheetPresenterProtocol
    }
    
    private let presentationManager = ActionSheetPresentationManager()
    private let viewsConstraintGroup = ConstraintGroup()
    
    let topView = UIView()
    let footerContainerView = UIView()
    
    override init(presenter: BasePresenterProtocol) {
        super.init(presenter: presenter)
        modalPresentationStyle = .custom
        transitioningDelegate = presentationManager
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        addBottomView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        footerContainerView.backgroundColor = .clear
        topView.backgroundColor = .customBlack(alpha: 0.5)
        
        topView.rx
            .tapGesture()
            .when(.recognized)
            .bind { [presenter = presenter] (_) in presenter.didTapOutsideBottomView() }
            .disposed(by: disposeBag)
        
        topView.rx
            .swipeGesture([.down])
            .when(.recognized)
            .bind { [presenter = presenter] (_) in presenter.didTapOutsideBottomView() }
            .disposed(by: disposeBag)
        
        listenToKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(view, footerContainerView, replace: viewsConstraintGroup) { (view, footer) in
            footer.bottom == view.bottom - self.keyboardRect.size.height
            footer.left == view.left
            footer.right == view.right
        }
    }
}

// MARK: - Setup view
extension ActionSheetViewController {
    
    private func addBottomView() {
        view.addSubview(topView)
        view.addSubview(footerContainerView)
        
        constrain(view, topView) { (view, top) in
            top.edges == view.edges
        }
        
        addFooterViewController()
    }
    
    private func addFooterViewController() {
        presenter.footerViewController.willMove(toParent: self)
        addChild(presenter.footerViewController)
        presenter.footerViewController.didMove(toParent: self)
        
        footerContainerView.addSubview(presenter.footerViewController.view)
        constrain(footerContainerView, presenter.footerViewController.view) { (container, view) in
            view.edges == container.edges
        }
    }
}

// MARK: - Keyboard notifications
extension ActionSheetViewController {
    
    override func keyboardWillShow(sender: NSNotification) {
        super.keyboardWillShow(sender: sender)
        self.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    override func keyboardWillHide(sender: NSNotification) {
        super.keyboardWillHide(sender: sender)
        self.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
}
