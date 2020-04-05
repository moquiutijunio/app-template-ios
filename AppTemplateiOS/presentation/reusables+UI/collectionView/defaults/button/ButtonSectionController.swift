//
//  ButtonSectionController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import IGListKit

final class ButtonSectionController: ListSectionController {
    
    var viewModel: ButtonSectionModel!
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let viewModel = viewModel else { return .zero }
        
        let width = context.containerSize.width
        let height = ButtonCollectionViewCell.heightFor(viewModel: viewModel, width: width)
        
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        if let cell = collectionContext?.dequeueReusableCell(withNibName: ButtonCollectionViewCell.nibName, bundle: nil, for: self, at: index) as? ButtonCollectionViewCell {
            cell.populateWith(viewModel: viewModel)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func didUpdate(to object: Any) {
        viewModel = object as? ButtonSectionModel
    }
}
