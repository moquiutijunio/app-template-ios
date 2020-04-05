//
//  TextCollectionViewCell.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

protocol TextViewModelProtocol {
    
    var text: String { get }
    var font: UIFont? { get }
    var textColor: UIColor { get }
    var textBackgroundColor: UIColor { get }
    var alignment: NSTextAlignment { get }
}

final class TextCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    private var viewModel: TextViewModelProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyAppearance()
    }
    
    func applyAppearance() {
        
        textLabel.numberOfLines = 0
    }
    
    func populateWith(viewModel: TextViewModelProtocol) {
        
        textLabel.text = viewModel.text
        textLabel.font = viewModel.font
        textLabel.textColor = viewModel.textColor
        textLabel.textAlignment = viewModel.alignment
        backgroundColor = viewModel.textBackgroundColor
        self.viewModel = viewModel
    }
}

// MARK: - UINib
extension TextCollectionViewCell {
    
    private static var textCollectionViewCell: TextCollectionViewCell = {
        return R.nib.textCollectionViewCell.firstView(owner: nil)!
    }()
    
    class func heightFor(viewModel: TextViewModelProtocol, width: CGFloat) -> CGFloat {
        textCollectionViewCell.populateWith(viewModel: viewModel)
        
        return textCollectionViewCell.heightForWidth(width: width)
    }
}
