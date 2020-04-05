//
//  ActionSheetPresentTransitioning.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

final class ActionSheetPresentTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) as? ActionSheetViewController else { return }
        
        toVC.view.frame = UIScreen.main.bounds
        transitionContext.containerView.addSubview(toVC.view)
        
        let topView = toVC.topView
        topView.alpha = 0
        
        let footerView = toVC.footerContainerView
        footerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.size.height)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            topView.alpha = 1
            footerView.transform = .identity
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
}
