//
//  BasePresenter.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BasePresenterProtocol {
    
    var toast: Driver<String> { get }
    var viewState: Driver<ViewState> { get }
    var alert: Driver<AlertViewModel> { get }
}

class BasePresenter: NSObject {
    
    internal let toastSubject = PublishSubject<String>()
    internal let newViewStateSubject = PublishSubject<ViewState>()
    internal let alertSubject = PublishSubject<AlertViewModel>()
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}

extension BasePresenter: BasePresenterProtocol {
    
    var viewState: Driver<ViewState> {
        return newViewStateSubject
            .asDriver(onErrorJustReturn: .normal)
    }
    
    var toast: Driver<String> {
        return toastSubject
            .asDriver(onErrorJustReturn: "")
    }
    
    var alert: Driver<AlertViewModel> {
        return alertSubject
            .asDriver(onErrorJustReturn: AlertViewModel())
    }
}
