//
//  TextSectionController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import IGListKit

final class TextSectionController: ListSectionController {
    
    var viewModel: TextSectionModel!
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let _ = viewModel else { return .zero }
        
        let width = context.containerSize.width
        let height = viewModel.heigth != nil ? viewModel.heigth! : TextCollectionViewCell.heightFor(viewModel: viewModel, width: width)
        
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        if let cell = collectionContext?.dequeueReusableCell(withNibName: TextCollectionViewCell.nibName, bundle: nil, for: self, at: index) as? TextCollectionViewCell {
            cell.populateWith(viewModel: viewModel)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func didUpdate(to object: Any) {
        viewModel = object as? TextSectionModel
    }
}
