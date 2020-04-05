//
//  ErrorSectionController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import IGListKit

final class ErrorSectionController: ListSectionController {
    
    var viewModel: ErrorSectionModel!
    
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
        let cell = collectionContext!.dequeueReusableCell(withNibName: ErrorCollectionViewCell.nibName, bundle: nil, for: self, at: index) as! ErrorCollectionViewCell
        cell.populateWith(viewModel: viewModel)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        viewModel = object as? ErrorSectionModel
    }
}
