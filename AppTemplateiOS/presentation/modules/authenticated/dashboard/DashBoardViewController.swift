//
//  DashBoardViewController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

final class DashboardViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        
        let todoLabel = UILabel()
        todoLabel.text = R.string.localizable.messageTodoFeature()
        todoLabel.font = UIFont.boldSystemFont(ofSize: 20)
        todoLabel.textColor = .lightGray
        todoLabel.textAlignment = .center
        todoLabel.numberOfLines = 0
        
        let dismissButton = UIButton()
        dismissButton.applyAppearance(.main,
                                      title: R.string.localizable.exit(),
                                      titleFont: UIFont.boldSystemFont(ofSize: 18),
                                      backgroundColor: .black)
        
        view.addSubview(todoLabel)
        view.addSubview(dismissButton)
        constrain(view, todoLabel, dismissButton) { (view, label, button) in
            label.center == view.center
            label.width == view.width
            label.height == 30
            
            button.top == label.bottom + 12
            button.left == view.left + 12
            button.right == view.right - 12
            button.height == 44
        }
        
        _ = dismissButton.rx.tap
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: {(_) in
                SessionManager.shared.expireSession()
            })
        
        if self.navigationController?.viewControllers.first != nil {
            addButtonOnNavigationBar(content: .image(image: R.image.ic_close()!), position: .left) { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    init() {
        super.init(presenter: BasePresenter(), nibName: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
