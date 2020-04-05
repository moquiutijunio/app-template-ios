//
//  PullToRefreshView.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import INSPullToRefresh

class PullToRefreshView: UIView {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicatorView.color = .primaryColor
    }
}

// MARK: - INSPullToRefreshBackgroundViewDelegate
extension PullToRefreshView: INSPullToRefreshBackgroundViewDelegate {
    func pull(_ pullToRefreshBackgroundView: INSPullToRefreshBackgroundView!, didChange state: INSPullToRefreshBackgroundViewState) {
        
        switch state {
        case .none: activityIndicatorView.stopAnimating()            
        case .loading: activityIndicatorView.startAnimating()
        case .triggered: activityIndicatorView.stopAnimating()
        default: break
        }
    }
}

// MARK: - UINib
extension PullToRefreshView {
    
    class func instantiateFromNib() -> PullToRefreshView {
        return R.nib.pullToRefreshView.firstView(owner: nil)!
    }
}
