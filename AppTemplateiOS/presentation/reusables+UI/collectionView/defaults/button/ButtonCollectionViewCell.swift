//
//  ButtonCollectionViewCell.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Material

protocol ButtonViewModelProtocol {
    
    var titleButton: String { get }
    var canStayDisable: Bool { get }
    var cornerRadius: CGFloat? { get }
    var buttonIsEnable: Driver<Bool> { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonAppearance: RaisedButtonAppearance { get }
    
    func buttonDidTap()
}

extension ButtonViewModelProtocol {
    
    var canStayDisable: Bool { return true }
    var cornerRadius: CGFloat? { return nil }
}

final class ButtonCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var button: RaisedButton!
    
    private var viewModel: ButtonViewModelProtocol?
    
    func populateWith(viewModel: ButtonViewModelProtocol) {
        disposeBag = DisposeBag()
        
        backgroundColor = viewModel.buttonBackgroundColor
        button.applyAppearance(viewModel.buttonAppearance,
                               title: viewModel.titleButton,
                               cornerRadius: viewModel.cornerRadius,
                               canStayDisable: viewModel.canStayDisable)
        
        viewModel.buttonIsEnable
            .drive(button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .bind { _ in viewModel.buttonDidTap() }
            .disposed(by: disposeBag)
        
        self.viewModel = viewModel
    }
}

// MARK: - UINib
extension ButtonCollectionViewCell {
    
    private static var buttonCollectionViewCell: ButtonCollectionViewCell = {
        return R.nib.buttonCollectionViewCell.firstView(owner: nil)!
    }()
    
    class func heightFor(viewModel: ButtonViewModelProtocol, width: CGFloat) -> CGFloat {
        buttonCollectionViewCell.populateWith(viewModel: viewModel)
        
        return buttonCollectionViewCell.heightForWidth(width: width)
    }
}
