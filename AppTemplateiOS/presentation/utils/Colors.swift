//
//  Colors.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

extension UIColor {
    
    public static var background: UIColor {
        if #available(iOS 11.0, *) {
            return R.color.background()!
        }
        return .blue
    }

    public static var error: UIColor {
        if #available(iOS 11.0, *) {
            return R.color.error()!
        }
        return UIColor(red: 1, green: 0.42, blue: 0.51, alpha: 1)
    }

    public static var gradient: UIColor {
        if #available(iOS 11.0, *) {
            return R.color.gradient()!
        }
        return UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1)
    }

    public static var primaryColor: UIColor {
        if #available(iOS 11.0, *) {
            return R.color.primaryColor()!
        }
        return UIColor(red: 0.25, green: 0.7, blue: 1, alpha: 1)
    }

    public static var secondColor: UIColor {
        if #available(iOS 11.0, *) {
            return R.color.secondColor()!
        }
        return UIColor(red: 0.04, green: 0.35, blue: 0.17, alpha: 1)
    }

    public static func customWhite(alpha: CGFloat = 0.87) -> UIColor {
        return UIColor(white: 1, alpha: alpha)
    }

    public static func customBlack(alpha: CGFloat = 0.87) -> UIColor {
        return UIColor(white: 0, alpha: alpha)
    }
}
