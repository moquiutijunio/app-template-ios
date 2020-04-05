//  
//  ContainerViewController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxCocoa
import Cartography

protocol ContainerPresenterProtocol: BasePresenterProtocol {
    
    var applicationStateDidChange: Driver<Void> { get }
}

final class ContainerViewController: BaseViewController {
    
    private var presenter: ContainerPresenterProtocol {
        return basePresenter as! ContainerPresenterProtocol
    }
    
    private(set) var currentViewController: UIViewController? {
        didSet {
            if let currentViewController = currentViewController {
                currentViewController.willMove(toParent: self)
                addChild(currentViewController)
                currentViewController.didMove(toParent: self)
                
                if let oldViewController = oldValue {
                    view.insertSubview(currentViewController.view, belowSubview: oldViewController.view)
                } else {
                    view.addSubview(currentViewController.view)
                }
                
                constrain(currentViewController.view, view, block: { (childView, parentView) in
                    childView.edges == parentView.edges
                })
                
                self.setNeedsStatusBarAppearanceUpdate()
            }
            
            if let oldViewController = oldValue {
                self.applyScreenTransition(newViewController: currentViewController, oldViewController: oldViewController)
                PresentationHelper.romePresentedModalsViewControllers()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let currentViewController = currentViewController else {
            return .lightContent
        }
        
        return currentViewController.preferredStatusBarStyle
    }
    
    override func bind() {
        super.bind()
        
        presenter.applicationStateDidChange
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func applyScreenTransition(newViewController: UIViewController?, oldViewController: UIViewController) {
        if let newViewController = newViewController {
            newViewController.view.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.size.height))
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: {
                newViewController.view.transform = CGAffineTransform.identity
                oldViewController.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
                
            }, completion: { (finished) in
                oldViewController.removeDefinitely()
            })
            
        } else {
            oldViewController.removeDefinitely()
        }
    }
}

extension ContainerViewController {
    
    func setCurrentViewController(viewController: UIViewController) {
        currentViewController = viewController
    }
}
