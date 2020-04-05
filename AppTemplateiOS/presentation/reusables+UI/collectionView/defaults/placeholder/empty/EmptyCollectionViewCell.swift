//
//  EmptyCollectionViewCell.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

protocol EmptyCollectionViewModelProtocol {
    
    var message: String { get }
}

final class EmptyCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var viewModel: EmptyCollectionViewModelProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyAppearance()
    }
    
    private func applyAppearance() {
        backgroundColor = .clear
        
        emptyImageView.image = R.image.ic_empty_list()
        emptyImageView.contentMode = .scaleAspectFit
        
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
    }
    
    func populateWith(viewModel: EmptyCollectionViewModelProtocol) {
        messageLabel.text = viewModel.message
        
        self.viewModel = viewModel
    }
}

// MARK: - UINib
extension EmptyCollectionViewCell {
    
    static func heightFor(viewModel: EmptyCollectionViewModelProtocol, width: CGFloat) -> CGFloat {
        let cell = staticCell as! EmptyCollectionViewCell
        cell.populateWith(viewModel: viewModel)
        return cell.heightForWidth(width: width)
    }
}
