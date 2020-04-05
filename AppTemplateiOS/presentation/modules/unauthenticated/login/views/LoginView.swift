//
//  LoginView.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Material
import Cartography
import AuthenticationServices

protocol LoginViewModelProtocol {
    
    var email: BehaviorRelay<String?> { get }
    var password: BehaviorRelay<String?> { get }
    var loginButtonEnabled: Driver<Bool> { get }
    var emailErrorString: Driver<String?> { get }
    var passwordErrorString: Driver<String?> { get }
    
    func loginButtonDidTap()
    func appleButtonDidTap()
    func googleButtonDidTap()
    func facebookButtonDidTap()
    func createAccountButtonDidTap()
    func forgotPasswordButtonDidTap()
}

final class LoginView: BaseView {
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var orLabel: UILabel!
    @IBOutlet private weak var doSignWithLabel: UILabel!
    @IBOutlet private weak var emailTextField: TextField!
    @IBOutlet private weak var passwordTextField: TextField!
    @IBOutlet private weak var appleContainerView: UIView!
    @IBOutlet private weak var loginButton: RaisedButton!
    @IBOutlet private weak var googleButton: RaisedButton!
    @IBOutlet private weak var facebookButton: RaisedButton!
    @IBOutlet private weak var createAccountButton: FlatButton!
    @IBOutlet private weak var forgotPasswordButton: FlatButton!
    
    private var viewModel: LoginViewModelProtocol?
    
    @available(iOS 13.0, *)
    private lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(appleButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyLayout()
    }
    
    private func applyLayout() {
        backgroundColor = .clear
        
        logoImageView.image = R.image.ic_logo()
        
        doSignWithLabel.textColor = .white
        doSignWithLabel.font = UIFont.systemFont(ofSize: 14)
        doSignWithLabel.text = R.string.localizable.loginSignInWith()
        
        orLabel.textColor = .white
        orLabel.font = UIFont.systemFont(ofSize: 14)
        orLabel.text = R.string.localizable.loginOr()
        
        facebookButton.applyAppearance(.facebook)
        googleButton.applyAppearance(.google)
        
        loginButton.applyAppearance(.main,
                                    title: R.string.localizable.loginEnter().uppercased(),
                                    canStayDisable: true)
        
        emailTextField.applyAppearance(.main,
                                       placeholder: R.string.localizable.email(),
                                       autocorrectionType: .no,
                                       keyboardType: .emailAddress,
                                       hasToolbar: false)
        
        passwordTextField.applyAppearance(.password,
                                          placeholder: R.string.localizable.loginPass(),
                                          hasToolbar: false)
        
        createAccountButton.applyAppearance(.main,
                                            title: R.string.localizable.loginCreateAccount())
        
        forgotPasswordButton.applyAppearance(.main,
                                             title: R.string.localizable.loginForgotPassword())
        
        if #available(iOS 13.0, *) {
            
            appleContainerView.addSubview(appleButton)
            constrain(appleButton, appleContainerView) { (button, container) in
                button.top == container.top + 8
                button.bottom == container.bottom
                button.left == container.left + 4
                button.right == container.right - 4
                button.height == 44
            }
        } else {
            appleContainerView.isHidden = true
        }
    }
    
    func populateWith(viewModel: LoginViewModelProtocol) {
        disposeBag = DisposeBag()
        
        viewModel.email
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        viewModel.emailErrorString
            .drive(onNext: { [emailTextField = emailTextField] (errorString) in
                guard let emailTextField = emailTextField else { return }
                emailTextField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.password
            .asObservable()
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.passwordErrorString
            .drive(onNext: { [passwordTextField = passwordTextField] (errorString) in
                guard let passwordTextField = passwordTextField else { return }
                passwordTextField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.loginButtonEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind { _ in viewModel.loginButtonDidTap() }
            .disposed(by: disposeBag)
        
        facebookButton.rx.tap
            .bind { _ in viewModel.facebookButtonDidTap() }
            .disposed(by: disposeBag)
        
        googleButton.rx.tap
            .bind { _ in viewModel.googleButtonDidTap() }
            .disposed(by: disposeBag)
        
        forgotPasswordButton.rx.tap
            .bind { _ in viewModel.forgotPasswordButtonDidTap() }
            .disposed(by: disposeBag)
        
        createAccountButton.rx.tap
            .bind { _ in viewModel.createAccountButtonDidTap() }
            .disposed(by: disposeBag)
        
        self.viewModel = viewModel
    }
    
    @objc private func appleButtonDidTap() {
        viewModel?.appleButtonDidTap()
    }
}

// MARK: - UINib
extension LoginView {
    
    static func loadNibName(viewModel: LoginViewModelProtocol) -> LoginView {
        let view = R.nib.loginView.firstView(owner: nil)!
        view.populateWith(viewModel: viewModel)
        return view
    }
}
