//  
//  ActionSheetPresenter.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ActionSheetRouterProtocol: AnyObject {
    
    func dismissActionSheet()
    func dismissActionSheetWith(message: String)
}

final class ActionSheetPresenter: BasePresenter {
    
    weak var router: ActionSheetRouterProtocol?
    
    let footerViewController: UIViewController
    
    init(footerViewController: UIViewController) {
        self.footerViewController = footerViewController
        super.init()
    }
}

// MARK: - ActionSheetPresenterProtocol
extension ActionSheetPresenter: ActionSheetPresenterProtocol {
    
    func didTapOutsideBottomView() {
        router?.dismissActionSheet()
    }
}
