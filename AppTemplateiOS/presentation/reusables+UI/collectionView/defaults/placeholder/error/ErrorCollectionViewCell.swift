//
//  ErrorCollectionViewCell.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

protocol ErrorCollectionViewModelProtocol {
    
    var message: String { get }
    func tryAgainDidTap()
}

final class ErrorCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var refreshImageView: UIImageView!
    
    private var viewModel: ErrorCollectionViewModelProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       applyAppearance()
    }
    
    private func applyAppearance() {
        backgroundColor = .clear
               
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        
        refreshImageView.image = R.image.ic_refresh()?.withRenderingMode(.alwaysTemplate)
        refreshImageView.contentMode = .scaleAspectFit
        refreshImageView.tintColor = .gray
    }
    
    func populateWith(viewModel: ErrorCollectionViewModelProtocol) {
        disposeBag = DisposeBag()
        
        messageLabel.text = viewModel.message
        
        self.rx.tapGesture()
            .when(.recognized)
            .bind { _ in viewModel.tryAgainDidTap() }
            .disposed(by: disposeBag)
        
        self.viewModel = viewModel
    }
}

// MARK: - UINib
extension ErrorCollectionViewCell {
    
    static func heightFor(viewModel: ErrorCollectionViewModelProtocol, width: CGFloat) -> CGFloat {
        let cell = staticCell as! ErrorCollectionViewCell
        cell.populateWith(viewModel: viewModel)
        return cell.heightForWidth(width: width)
    }
}
