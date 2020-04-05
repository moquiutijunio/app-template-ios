//  
//  LoginViewController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxCocoa
import Cartography

protocol LoginPresenterProtocol: BasePresenterProtocol, LoginViewModelProtocol {
    
    var signInRequesResponse: Driver<Void> { get }
}

final class LoginViewController: BaseScrollViewController {
    
    private var presenter: LoginPresenterProtocol {
        return basePresenter as! LoginPresenterProtocol
    }
    
    private lazy var loginView = LoginView.loadNibName(viewModel: presenter)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackground(image: R.image.img_bg()!, type: .full)
        addChildViewToScrollView(childView: loginView)
    }
    
    override func bind() {
        super.bind()
        
        presenter.signInRequesResponse
            .drive()
            .disposed(by: disposeBag)
    }
}
