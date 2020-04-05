//  
//  CreateAccountViewController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxCocoa

protocol CreateAccountPresenterProtocol: BasePresenterProtocol, CreateAccountViewModelProtocol {
    
    var createAccountRequestResponse: Driver<Void> { get }
    var newImagePickingResponse: Driver<Void> { get }
}

final class CreateAccountViewController: BaseScrollViewController {
    
    private var presenter: CreateAccountPresenterProtocol {
        return basePresenter as! CreateAccountPresenterProtocol
    }
    
    private lazy var createAccountView = CreateAccountView.loadNibName(viewModel: presenter)
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addBackground(image: R.image.img_bg()!, type: .full)
        addChildViewToScrollView(childView: createAccountView)
    }
    
    override public func bind() {
        super.bind()
        
        presenter.createAccountRequestResponse
            .drive()
            .disposed(by: disposeBag)
        
        presenter.newImagePickingResponse
            .drive()
            .disposed(by: disposeBag)
    }
}
