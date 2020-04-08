//
//  AuthenticationUITests.swift
//  AppTemplateiOSUITests
//
//  Created by Junio Moquiuti on 06/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import XCTest

final class AuthenticationUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func test_success_login() {

        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements

        let emailTextField = elementsQuery.textFields[R.string.accessibilityIdentifier.loginEmail()]
        emailTextField.tap()
        emailTextField.typeText("moquiuti@jera.com.br")

        let passwordTextField = elementsQuery.secureTextFields[R.string.accessibilityIdentifier.loginPassword()]
        passwordTextField.tap()
        passwordTextField.typeText("secret123")

        let entryButton = elementsQuery.buttons[R.string.accessibilityIdentifier.loginEntryButton()]
        entryButton.tap()
        
        sleep(5)
    }

    func test_forgot_email() {
        
        let scrollViewsQuery = app.scrollViews.otherElements
        let forgotButton = scrollViewsQuery.buttons[R.string.accessibilityIdentifier.loginForgotPasswordButton()]
        forgotButton.tap()

        let collectionViewsQuery = app.collectionViews.otherElements
        let emailTextField = collectionViewsQuery.textFields[R.string.accessibilityIdentifier.forgotEmail()]
        emailTextField.tap()
        emailTextField.typeText("teste@test.com")

        let sendButton = collectionViewsQuery.buttons[R.string.accessibilityIdentifier.forgotSendButton()]
        sendButton.tap()

        let alertView = app.alerts[R.string.accessibilityIdentifier.alertView()]
        let okButton = alertView.scrollViews.otherElements.buttons[R.string.accessibilityIdentifier.alertAction()]
        okButton.tap()
    }

    func test_create_account() {
        
        let elementsQuery = app.scrollViews.otherElements
        let forgotButton = elementsQuery.buttons[R.string.accessibilityIdentifier.loginCreateAccountButton()]
        forgotButton.tap()
        
        let nameTextField = elementsQuery.textFields[R.string.accessibilityIdentifier.createAccountName()]
        nameTextField.tap()
        nameTextField.typeText("Teste Teste")
        
        let emailTextField = elementsQuery.textFields[R.string.accessibilityIdentifier.createAccountEmail()]
        emailTextField.tap()
        emailTextField.typeText("teste@teste.teste")
        
        let passwordTextField = elementsQuery.secureTextFields[R.string.accessibilityIdentifier.createAccountPassword()]
        passwordTextField.tap()
        passwordTextField.typeText("teste123")
        
        let confirmPasswordTextField = elementsQuery.secureTextFields[R.string.accessibilityIdentifier.createAccountConfirmPassword()]
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText("teste123")
        
        let sendButton = elementsQuery.buttons[R.string.accessibilityIdentifier.createAccountSendButton()]
        sendButton.tap()
        
        sleep(5)
    }
}
