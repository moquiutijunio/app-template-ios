//
//  ForgotPasswordSectionController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import IGListKit

final class ForgotPasswordSectionController: ListSectionController {
    
    var viewModel: ForgotPasswordSectionModel!
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 3
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let _ = viewModel else { return .zero }
        
        let width = context.containerSize.width - (inset.left + inset.right)
        var height: CGFloat = 0
        if index == 0 {
            height = TextCollectionViewCell.heightFor(viewModel: viewModel, width: width)
        } else if index == 1 {
            height = TextFieldCollectionViewCell.heightFor(viewModel: viewModel, width: width)
        } else {
            height = ButtonCollectionViewCell.heightFor(viewModel: viewModel, width: width)
        }
        
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        if index == 0 {
            let cell = collectionContext!.dequeueReusableCell(withNibName: TextCollectionViewCell.nibName, bundle: nil, for: self, at: index) as! TextCollectionViewCell
            cell.populateWith(viewModel: viewModel)
            return cell
            
        } else if index == 1 {
            let cell = collectionContext!.dequeueReusableCell(withNibName: TextFieldCollectionViewCell.nibName, bundle: nil, for: self, at: index) as! TextFieldCollectionViewCell
            cell.populateWith(viewModel: viewModel)
            return cell
            
        } else {
            
            let cell = collectionContext!.dequeueReusableCell(withNibName: ButtonCollectionViewCell.nibName, bundle: nil, for: self, at: index) as! ButtonCollectionViewCell
            cell.populateWith(viewModel: viewModel)
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        viewModel = object as? ForgotPasswordSectionModel
    }
}
