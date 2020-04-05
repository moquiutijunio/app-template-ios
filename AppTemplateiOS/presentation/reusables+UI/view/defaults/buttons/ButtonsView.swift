//
//  ButtonsView.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Material
import Cartography

enum ButtonType {
    
    case save
    case add
    
    var title: String {
        switch self {
        case .add: return R.string.localizable.add().uppercased()
        case .save: return R.string.localizable.save().uppercased()
        }
    }
    
    var appearance: RaisedButtonAppearance {
        switch self {
        default: return .main
        }
    }
}

protocol ButtonsViewModelProtocol {
    
    var buttonIsEnable: Driver<Bool> { get }
    var buttonTypes: Driver<[ButtonType]> { get }
    func buttonTapped(type: ButtonType)
}

extension ButtonsViewModelProtocol {
    
    var buttonIsEnable: Driver<Bool> {
        return .just(true)
    }
}

final class ButtonsView: BaseView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    fileprivate(set) var heightButtonView: CGFloat = 60
    
    private var viewModel: ButtonsViewModelProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        stackView.distribution = .fillEqually
    }
    
    private func populateWith(viewModel: ButtonsViewModelProtocol) {
        disposeBag = DisposeBag()
        
        viewModel.buttonTypes
            .drive(onNext: {[weak self] (buttonTypes) in
                guard let self = self else { return }
                
                self.stackView.removeAllArrangedSubviews()
                
                for buttonType in buttonTypes {
                 
                    let raisedButton = RaisedButton()
                    raisedButton.applyAppearance(buttonType.appearance,
                                                 title: buttonType.title,
                                                 cornerRadius: 22)
                    
                    raisedButton.rx.tap
                        .bind(onNext: { (_) in
                            viewModel.buttonTapped(type: buttonType)
                        })
                        .disposed(by: self.disposeBag)
                    
                    viewModel.buttonIsEnable
                        .drive(raisedButton.rx.isEnabled)
                        .disposed(by: self.disposeBag)
                    
                    let buttonCardView = UIView()
                    buttonCardView.backgroundColor = .clear
                    
                    buttonCardView.addSubview(raisedButton)
                    constrain(buttonCardView, raisedButton, block: { (view, button) in
                        button.left == view.left + 16
                        button.right == view.right - 16
                        button.top == view.top + 8
                        button.bottom == view.bottom - 8
                        
                        view.height == self.heightButtonView
                    })
                    
                    self.stackView.addArrangedSubview(buttonCardView)
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel = viewModel
    }
}

// MARK: - UINib
extension ButtonsView {
    
    static func loadNibName(viewModel: ButtonsViewModelProtocol) -> ButtonsView {
        let view = R.nib.buttonsView.firstView(owner: nil)!
        view.populateWith(viewModel: viewModel)
        return view
    }
}
