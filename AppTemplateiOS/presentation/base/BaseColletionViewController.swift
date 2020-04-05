//
//  BaseColletionViewController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import IGListKit
import Cartography

class BaseCollectionViewController: BaseViewController {
    
    internal var collectionViewConstraintGroup = ConstraintGroup()
    
    internal var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .clear
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.keyboardDismissMode = .interactive
        return view
    }()
    
    internal lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    override func loadView() {
        super.loadView()
        
        addCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenToKeyboard()
        adapter.collectionView = collectionView
        
        if #available(iOS 11.0, *) {
           collectionView.contentInsetAdjustmentBehavior = .never
        } else {
           automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        
        updateCollectionViewConstraints()
    }
    
    internal func updateCollectionViewConstraints(topMargin: CGFloat = 0,
                                                  bottomMargin: CGFloat = 0,
                                                  leftMargin: CGFloat = 0,
                                                  rightMargin: CGFloat = 0,
                                                  ignoreTopSafeArea: Bool = false,
                                                  ignoreBottomSafeArea: Bool = false) {
        
        constrain(view, collectionView, car_topLayoutGuide, car_bottomLayoutGuide, replace: collectionViewConstraintGroup) { (container, collection, topGuide, bottomGuide) in
            collection.left == container.left + leftMargin
            collection.right == container.right - rightMargin
            
            if #available(iOS 11.0, *) {
                collection.top == container.safeAreaLayoutGuide.top + topMargin
                collection.bottom == container.safeAreaLayoutGuide.bottom - bottomMargin
                
            } else {
                collection.top == topGuide.bottom + topMargin
                collection.bottom == bottomGuide.top - bottomMargin
            }
            
            if ignoreTopSafeArea {
                collection.top == container.top + topMargin
            }
            
            if ignoreBottomSafeArea {
                collection.bottom == container.bottom - bottomMargin
            }
        }
    }
}

// MARK: - Keyboard Notifications
extension BaseCollectionViewController {
    
    override func keyboardWillShow(sender: NSNotification) {
        guard let keyboardValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrameCG = keyboardValue.cgRectValue
        let keyboarFrame = view.convert(keyboardFrameCG, from: view.window)
        
        collectionView.contentInset.bottom = keyboarFrame.height - bottomLayoutGuide.length + 30
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        collectionView.layoutIfNeeded()
    }
    
    override func keyboardWillHide(sender: NSNotification) {
        collectionView.contentInset = .zero
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        collectionView.layoutIfNeeded()
    }
}

// MARK: - InfinityScroll and PullToRefresh
extension BaseCollectionViewController {

    internal func updateInfinityScrollAndPullToRefreshWith(_ listResponse: ListResponse<[ListDiffable]>) {
        collectionView.ins_endPullToRefresh()
        collectionView.ins_endInfinityScroll(withStoppingContentOffset: true)
        
        switch listResponse {
        case .new,
             .loading:
            collectionView.ins_setPull(toRefreshEnabled: false)
            collectionView.ins_setInfinityScrollEnabled(false)
            
        case .success(let viewModels, let infinityScrollEnabled):
            
            if viewModels.isEmpty {
                collectionView.ins_setPull(toRefreshEnabled: true)
                collectionView.ins_setInfinityScrollEnabled(infinityScrollEnabled ?? false)
            }else {
                collectionView.ins_setPull(toRefreshEnabled: true)
                collectionView.ins_setInfinityScrollEnabled(infinityScrollEnabled ?? true)
            }
            
        case .failure:
            collectionView.ins_setPull(toRefreshEnabled: true)
            collectionView.ins_setInfinityScrollEnabled(false)
        }
    }
}
