//  
//  ForgotPasswordViewController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxCocoa
import IGListKit

protocol ForgotPasswordPresenterProtocol: BasePresenterProtocol {
    
    var forgotPasswordRequestResponse: Driver<Void> { get }
    var viewModels: [ListDiffable] { get }
}

final class ForgotPasswordViewController: BaseCollectionViewController {
    
    private var presenter: ForgotPasswordPresenterProtocol {
        return basePresenter as! ForgotPasswordPresenterProtocol
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        applyLayout()
        adapter.dataSource = self
        adapter.performUpdates(animated: true)
    }
    
    override func bind() {
        super.bind()
        
        presenter.forgotPasswordRequestResponse
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func applyLayout() {
        title = R.string.localizable.forgotPasswordTitleNavBar()
        
        addBackground(image: R.image.img_bg()!, type: .full)
    }
}

// MARK: - ListAdapterDataSource
extension ForgotPasswordViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return presenter.viewModels
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
        case is ForgotPasswordSectionModel: return ForgotPasswordSectionController()
        default: return ListSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
