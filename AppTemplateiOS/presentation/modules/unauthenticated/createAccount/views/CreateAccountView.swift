//
//  CreateAccountView.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Material
import Cartography
import AuthenticationServices

protocol CreateAccountViewModelProtocol {
    
    var image: BehaviorRelay<UIImage?> { get }
    var name: BehaviorRelay<String?> { get }
    var email: BehaviorRelay<String?> { get }
    var password: BehaviorRelay<String?> { get }
    var confirmePassword: BehaviorRelay<String?> { get }
    var createAccountButtonEnabled: Driver<Bool> { get }
    var nameErrorString: Driver<String?> { get }
    var emailErrorString: Driver<String?> { get }
    var passwordErrorString: Driver<String?> { get }
    var confirmPasswordErrorString: Driver<String?> { get }
    
    func avatarDidTap()
    func createAccountButtonDidTap()
}

final class CreateAccountView: BaseView {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var changeAvatarButton: FlatButton!
    @IBOutlet private weak var nameTextField: TextField!
    @IBOutlet private weak var emailTextField: TextField!
    @IBOutlet private weak var passwordTextField: TextField!
    @IBOutlet private weak var confirmPasswordTextField: TextField!
    @IBOutlet private weak var createAccountButton: RaisedButton!
    
    private var viewModel: CreateAccountViewModelProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyLayout()
    }
    
    private func applyLayout() {
        backgroundColor = .clear
        
        avatarImageView.image = R.image.ic_avatar()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width/2
        avatarImageView.clipsToBounds = true
        
        nameTextField.accessibilityIdentifier = R.string.accessibilityIdentifier.createAccountName()
        nameTextField.applyAppearance(.main,
                                      placeholder: R.string.localizable.createAccountName(),
                                      autocorrectionType: .no,
                                      hasToolbar: false)
        
        emailTextField.accessibilityIdentifier = R.string.accessibilityIdentifier.createAccountEmail()
        emailTextField.applyAppearance(.main,
                                       placeholder: R.string.localizable.email(),
                                       autocorrectionType: .no,
                                       keyboardType: .emailAddress,
                                       hasToolbar: false)
        
        passwordTextField.accessibilityIdentifier = R.string.accessibilityIdentifier.createAccountPassword()
        passwordTextField.applyAppearance(.password,
                                          placeholder: R.string.localizable.createAccountPassword(),
                                          hasToolbar: false)
        
        confirmPasswordTextField.accessibilityIdentifier = R.string.accessibilityIdentifier.createAccountConfirmPassword()
        confirmPasswordTextField.applyAppearance(.password,
                                                 placeholder: R.string.localizable.createAccountConfirmPassword(),
                                                 hasToolbar: false)
        
        changeAvatarButton.applyAppearance(.main,
                                           title: R.string.localizable.createAccountSeachPhoto().uppercased())
        
        createAccountButton.accessibilityIdentifier = R.string.accessibilityIdentifier.createAccountSendButton()
        createAccountButton.applyAppearance(.main,
                                            title: R.string.localizable.create().uppercased(),
                                            canStayDisable: true)
    }
    
    func populateWith(viewModel: CreateAccountViewModelProtocol) {
        disposeBag = DisposeBag()
        
        nameTextField.rx.text
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        confirmPasswordTextField.rx.text
            .bind(to: viewModel.confirmePassword)
            .disposed(by: disposeBag)
        
        viewModel.image
            .unwrap()
            .bind(to: avatarImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.nameErrorString
            .drive(onNext: { [textField = nameTextField] (errorString) in
                guard let textField = textField else { return }
                textField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.emailErrorString
            .drive(onNext: { [textField = emailTextField] (errorString) in
                guard let textField = textField else { return }
                textField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.passwordErrorString
            .drive(onNext: { [textField = passwordTextField] (errorString) in
                guard let textField = textField else { return }
                textField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.confirmPasswordErrorString
            .drive(onNext: { [textField = confirmPasswordTextField] (errorString) in
                guard let textField = textField else { return }
                textField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.createAccountButtonEnabled
            .drive(createAccountButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        changeAvatarButton.rx.tap
            .bind { _ in viewModel.avatarDidTap() }
            .disposed(by: disposeBag)
        
        createAccountButton.rx.tap
            .bind { _ in viewModel.createAccountButtonDidTap() }
            .disposed(by: disposeBag)
        
        self.viewModel = viewModel
    }
}

// MARK: - UINib
extension CreateAccountView {
    
    static func loadNibName(viewModel: CreateAccountViewModelProtocol) -> CreateAccountView {
        let view = R.nib.createAccountView.firstView(owner: nil)!
        view.populateWith(viewModel: viewModel)
        return view
    }
}
