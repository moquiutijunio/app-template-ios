//
//  Presentation+Helper.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

class PresentationHelper {
    
    static func topViewController() -> UIViewController? {
        guard var topController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        return topController
    }
    
    static func romePresentedModalsViewControllers() {
        if let topController = topViewController() {
            if !topController.isKind(of: ContainerViewController.self) {
                topController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    static func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
