//
//  TextFieldCollectionViewCell.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Material

protocol TextFieldViewModelProtocol {
    
    var textFieldIsEnabled: Bool { get }
    var becomeFirstResponder: Bool { get }
    var keyboardType: UIKeyboardType { get }
    var textFieldPlaceholder: String? { get }
    var textFieldCornerRadius: CGFloat { get }
    var textViewBackgroundColor: UIColor { get }
    var textRelay: BehaviorRelay<String?> { get }
    var textFieldAlignment: NSTextAlignment { get }
    var textFieldErrorString: Driver<String?> { get }
    var textFieldAppearance: TextFieldAppearance { get }
    
    func textDidEndEditing()
}

extension TextFieldViewModelProtocol {
    
    var textFieldIsEnabled: Bool { return true }
    var becomeFirstResponder: Bool { return false }
    var textFieldPlaceholder: String? { return nil }
    var textFieldCornerRadius: CGFloat { return 6 }
    var textViewBackgroundColor: UIColor { return .clear }
    var textFieldAlignment: NSTextAlignment { return .left }
    var keyboardType: UIKeyboardType { return .default }
    var textFieldErrorString: Driver<String?> { return .just(nil) }
    func textDidEndEditing() {}
}

final class TextFieldCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var textField: TextField!
    
    private var viewModel: TextFieldViewModelProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
    }
    
    func populateWith(viewModel: TextFieldViewModelProtocol) {
        disposeBag = DisposeBag()
        
        textField.applyAppearance(viewModel.textFieldAppearance,
                                  placeholder: viewModel.textFieldPlaceholder,
                                  cornerRadius: viewModel.textFieldCornerRadius,
                                  textAlignment: viewModel.textFieldAlignment,
                                  keyboardType: viewModel.keyboardType)
        
        textField.isEnabled = viewModel.textFieldIsEnabled
        backgroundColor = viewModel.textViewBackgroundColor
        
        viewModel.textRelay
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        
        textField.rx.text
            .bind(to: viewModel.textRelay)
            .disposed(by: disposeBag)
        
        viewModel.textFieldErrorString
            .drive(onNext: { [textField = textField] (errorString) in
                guard let textField = textField else { return }
                textField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        if viewModel.becomeFirstResponder {
            _ = textField.becomeFirstResponder()
        }
        
        self.viewModel = viewModel
    }
}

// MARK: - UITextFieldDelegate
extension TextFieldCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        viewModel?.textDidEndEditing()
    }
}

// MARK: - UINib
extension TextFieldCollectionViewCell {
    
    private static var textFieldCollectionViewCell: TextFieldCollectionViewCell = {
        return R.nib.textFieldCollectionViewCell.firstView(owner: nil)!
    }()
    
    class func heightFor(viewModel: TextFieldViewModelProtocol, width: CGFloat) -> CGFloat {
        textFieldCollectionViewCell.populateWith(viewModel: viewModel)
        
        return textFieldCollectionViewCell.heightForWidth(width: width)
    }
}

