//
//  Presentation+Extensions.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IGListKit

// MARK: - String
extension String {
    
    var removeAccentsAndSpecialCharacteres: String {
        var text = self.folding(options: .diacriticInsensitive, locale: .current)
        text = text.replacingOccurrences(of: " ", with: "_")
        return text
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool { //Minimo 6 letras, se quiser ativar um caracter especial descomentar em baixo
//        let decimalCharacters = CharacterSet.decimalDigits
//        let decimalRange = self.rangeOfCharacter(from: decimalCharacters)
//        guard !self.isEmpty, self.count > 5, decimalRange != nil else { return false }
        guard !self.isEmpty, self.count > 5 else { return false }
        return true
    }
    
    var isValidCPF: Bool {
        return CPF.validate(cpf: self)
    }
    
    var isValidDate: Bool {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let date = format.date(from: self)
        
        return date != nil ? true : false
    }
    
    var isValidPhone: Bool {
        let phoneRegex = "^\\d{3}-\\d{3}-\\d{4}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    var toInt: Int? {
        return Int(self)
    }
    
    //Formata valores "2,60"
    var toDouble: Double? {
        let formatter = NumberFormatter()
        
        formatter.decimalSeparator = "."
        if let result = formatter.number(from: self) {
            return result.doubleValue
        }
        
        formatter.decimalSeparator = ","
        if let result = formatter.number(from: self) {
            return result.doubleValue
        }
        
        return 0
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

// MARK: - Double
extension Double {
    
    var toInt: Int {
        return Int(self)
    }
    
    func toString(formatted: String? = nil) -> String {
        guard self != 0 else { return "0" }
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: formatted ?? "%.2f", self)
    }
}

// MARK: - Int
extension Int {
    
    var toDouble: Double {
        return Double(self)
    }
    
    var toFloat: CGFloat {
        return CGFloat(self)
    }
}

// MARK: - Date
extension Date {
    
    var firstDayOfTheYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let components = Calendar.current.dateComponents([.year], from: self)
        let startOfYear = Calendar.current.date(from: components)!
        return dateFormatter.string(from: startOfYear)
    }
    
    var lastDayOfTheYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let startOfYearComponents = Calendar.current.dateComponents([.year], from: self)
        let startOfYear = Calendar.current.date(from: startOfYearComponents)!
        
        var endOfYearComponents = DateComponents()
        endOfYearComponents.year = 1
        endOfYearComponents.day = -1
        let endOfYear = Calendar.current.date(byAdding: endOfYearComponents, to: startOfYear)!
        return dateFormatter.string(from: endOfYear)
    }
    
    var getNextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
    
    var getPreviousDay: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? self
    }
    
    func isEqual(_ date: String?, components: Calendar.Component) -> Bool {
        guard let date = DomainUtils.dateFrom(string: date) else { return false }
        
        let order = Calendar.current.compare(self, to: date, toGranularity: components)
        if case .orderedSame = order {
            return true
        }
        
        return false
    }
    
    func isEqual(_ date: Date?, components: Calendar.Component) -> Bool {
        guard let date = date else { return false }
        
        let order = Calendar.current.compare(self, to: date, toGranularity: components)
        if case .orderedSame = order {
            return true
        }
        
        return false
    }
    
    func isOrdered(_ result: ComparisonResult, date: Date, components: Calendar.Component) -> Bool {
        let order = NSCalendar.current.compare(self, to: date, toGranularity: components)
        if order == result {
            return false
        }
        
        return true
    }
    
    func stringWith(format: String, timeZone: TimeZone? = TimeZone.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}

// MARK: - UIView
extension UIView {
    
    func round(cornerRadius: Double, corners: UIRectCorner = [.allCorners]) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        rectShape.fillColor = backgroundColor?.cgColor
        layer.mask = rectShape
    }
    
    func addLeftGradient(color: UIColor = .black) -> CAGradientLayer {
        let colors = [UIColor.clear, color]
        
        let gradient = addGradient(colors: colors, locations: [0, 0.95])
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        return gradient
    }
    
    func addGradient(colors: [UIColor], locations: [NSNumber]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

// MARK: - UIButton
extension UIButton {
    
    func setTitleWithoutAnimation(_ title: String?, for state: UIControl.State) {
        UIView.performWithoutAnimation { [weak self] in
            self?.setTitle(title, for: state)
            self?.layoutIfNeeded()
        }
    }
}

// MARK: - UIImage
extension UIImage {
    
    static func fromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}

// MARK: - UITextField
extension UITextField {
    
    func addToolBar(title: String, action: @escaping (() -> ())) {
        let doneButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        if #available(iOS 12.0, *) {
            doneButton.tintColor = self.traitCollection.userInterfaceStyle == .dark ? .white: .black
        } else {
            doneButton.tintColor = .black
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolBar
        
        _ = doneButton.rx.tap
            .takeUntil(rx.deallocated)
            .bind { [unowned self] in
                action()
                self.resignFirstResponder()
        }
    }
}

// MARK: - NSObject
extension NSObject: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
}

// MARK: - UIViewController
extension UIViewController {
    
    func removeDefinitely() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

// MARK: - UICollectionViewCell
extension UICollectionViewCell {
    
    private struct AssociatedKeys {
        static var lastRefreshWidth = "lastRefreshWidth"
    }
    
    private var lastRefreshWidth: CGFloat? {
        get {
            return getAssociated(associativeKey: &AssociatedKeys.lastRefreshWidth)
        }
        set {
            setAssociated(value: newValue, associativeKey: &AssociatedKeys.lastRefreshWidth)
        }
    }
    
    func heightForWidth(width: CGFloat) -> CGFloat {
        contentView.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: width, height: contentView.frame.size.height)
        contentView.layoutIfNeeded()
        
        return contentView.systemLayoutSizeFitting(CGSize(width: width, height: CGFloat.infinity), withHorizontalFittingPriority: UILayoutPriority(rawValue: 999), verticalFittingPriority: UILayoutPriority(rawValue: 50)).height
    }
}

// MARK: - UIStackView
extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

// MARK: - NSObject
extension NSObject {
    func setAssociated<T>(value: T, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, associativeKey, value, policy)
    }
    
    func getAssociated<T>(associativeKey: UnsafeRawPointer) -> T? {
        let value = objc_getAssociatedObject(self, associativeKey)
        return value as? T
    }
}
