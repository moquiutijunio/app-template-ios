//
//  LoadingCollectionViewCell.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

protocol LoadingCollectionViewModelProtocol {
    
    var title: String { get }
}

final class LoadingCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var activityIndicationView: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var viewModel: LoadingCollectionViewModelProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyAppearance()
    }
    
    private func applyAppearance() {
        backgroundColor = .clear
        
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .primaryColor
        titleLabel.numberOfLines = 0
    }
    
    func populateWith(viewModel: LoadingCollectionViewModelProtocol) {
        
        titleLabel.text = viewModel.title
        self.viewModel = viewModel
        activityIndicationView.startAnimating()
    }
}

// MARK: - UINib
extension LoadingCollectionViewCell {
    
    static func heightFor(viewModel: LoadingCollectionViewModelProtocol, width: CGFloat) -> CGFloat {
        let cell = staticCell as! LoadingCollectionViewCell
        cell.populateWith(viewModel: viewModel)
        return cell.heightForWidth(width: width)
    }
}
