//
//  EmptySectionController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import IGListKit

final class EmptySectionController: ListSectionController {
    
    var viewModel: EmptySectionModel!
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let _ = viewModel else { return .zero }
        
        let width = context.containerSize.width
        var height = context.containerSize.height
        
        if case .cell = viewModel.type {
            height = 130
        }
        
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if let cell = collectionContext?.dequeueReusableCell(withNibName: EmptyCollectionViewCell.nibName, bundle: nil, for: self, at: index) as? EmptyCollectionViewCell {
            cell.populateWith(viewModel: viewModel)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func didUpdate(to object: Any) {
        viewModel = object as? EmptySectionModel
    }
}
