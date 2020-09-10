//
//  BaseViewController.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import Material
import Cartography

enum NavigationbarContentType {
    
    case text(text: String)
    case image(image: UIImage)
}

enum NavigationbarPosition {
    
    case right
    case left
    case back
}

enum NavigationAppearanceType {
    
    case white
    case black
    case translucent
}

class BaseViewController: UIViewController {
    
    internal let basePresenter: BasePresenterProtocol
    internal var disposeBag: DisposeBag!

    var navigationAppearanceType: NavigationAppearanceType = .translucent
    
    private(set) var isVisible = false
    private(set) var keyboardRect: CGRect = .zero
    
    private var placeholderView: UIView?
    private(set) lazy var backgroundView = BackgroundView()
    
    private(set) lazy var topSafeArea: CGFloat = {
        var topSafeArea: CGFloat = 0
        if #available(iOS 11.0, *) {
            topSafeArea = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        }
        return topSafeArea
    }()
    
    private(set) lazy var bottomSafeArea: CGFloat = {
        var bottomSafeArea: CGFloat = 0
        if #available(iOS 11.0, *) {
            bottomSafeArea += UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        return bottomSafeArea
    }()
    
    init(presenter: BasePresenterProtocol, nibName: String?) {
        self.basePresenter = presenter
        super.init(nibName: nibName, bundle: nil)
    }
    
    init(presenter: BasePresenterProtocol) {
        self.basePresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyNavigationAppearance()
        viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isVisible = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        isVisible = false
    }
    
    internal func bind() {
        disposeBag = DisposeBag()
        
        basePresenter.viewState
            .drive(onNext: {[weak self] (state) in
                guard let self = self else { return }
                
                switch state {
                case .normal:
                    self.removePlaceholder()
                    
                case .failure(let viewModel):
                    self.showPlaceholderWith(viewModel: viewModel, type: .error)
                    
                case .loading(let viewModel):
                    self.showPlaceholderWith(viewModel: viewModel, type: .loading)
                    
                }
            })
            .disposed(by: disposeBag)
        
        basePresenter.alert
            .drive(onNext: {[weak self] (alertViewModel) in
                guard let self = self else { return }
                self.buidlAlertWith(viewModel: alertViewModel)
            })
            .disposed(by: disposeBag)
        
        basePresenter.toast
            .drive(onNext: {[weak self] (text) in
                guard let self = self else { return }
                self.showToast(text: text)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}

// MARK: - NavigationControllers methods
extension BaseViewController {
    
    private func applyNavigationAppearance() {
        guard let navigationController = navigationController else { return }
        
        switch navigationAppearanceType {
        case .white:
            navigationController.navigationBar.barTintColor = .background
            navigationController.navigationBar.tintColor = .primaryColor
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.secondColor,
                                                                      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
            if #available(iOS 11.0, *) {
                navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.secondColor,
                                                                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
                navigationController.navigationBar.prefersLargeTitles = false
                navigationController.navigationItem.largeTitleDisplayMode = .automatic
            }
            
        case .black:
            navigationController.navigationBar.barTintColor = .customBlack()
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
            if #available(iOS 11.0, *) {
                navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
                navigationController.navigationBar.prefersLargeTitles = false
                navigationController.navigationItem.largeTitleDisplayMode = .automatic
            }
            
        case .translucent:
            navigationController.navigationBar.barTintColor = .clear
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            
            if #available(iOS 11.0, *) {
                navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
                navigationController.navigationBar.prefersLargeTitles = false
                navigationController.navigationItem.largeTitleDisplayMode = .automatic
            }
        }
        
        let backImage = R.image.ic_back()
        let barButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController.navigationBar.backIndicatorImage = backImage
        navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController.navigationBar.topItem?.backBarButtonItem = barButton
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }
    
    @discardableResult public func addButtonOnNavigationBar(content: NavigationbarContentType,
                                                            position: NavigationbarPosition,
                                                            block: @escaping () -> Void) -> UIBarButtonItem {
        
        let barButtonItem: UIBarButtonItem
        switch content {
        case .text(let title):
            barButtonItem = UIBarButtonItem(title: title, style: .done, target: nil, action: nil)
            
        case .image(let image):
            barButtonItem = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        }
        
        _ = barButtonItem.rx.tap
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: {(_) in
                block()
            })
        
        switch position {
        case .left:
            navigationItem.leftBarButtonItem = barButtonItem
            
        case .right:
            navigationItem.rightBarButtonItem = barButtonItem
            
        case .back:
            navigationItem.backBarButtonItem = barButtonItem
        }
        
        return barButtonItem
    }
    
    public func hideNavigationButton(position: NavigationbarPosition) {
        let barButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        switch position {
        case .left:
            navigationItem.leftBarButtonItem = barButton
            
        case .right:
            navigationItem.rightBarButtonItem = barButton
            
        case .back:
            navigationItem.backBarButtonItem = barButton
            
            let backImage = UIImage()
            navigationController?.navigationBar.backIndicatorImage = backImage
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
            navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        }
    }
    
    func setNavigationBarHidden(_ isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }
}

// MARK: - BackgroundView
extension BaseViewController {
    
    internal func addBackground(image: UIImage,
                                blurEffect: Bool = false,
                                gradient: Bool = false,
                                type: BackgroundViewType = .normal) {
        
        backgroundView.removeFromSuperview()
        backgroundView.setImage(image, blurEffect: blurEffect, gradient: gradient, type: type)
        addBackgroundView()
    }
    
    private func addBackgroundView() {
        
        backgroundView.clipsToBounds = true
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        constrain(view, backgroundView) { (container, image) in
            image.edges == container.edges
        }
    }
}

// MARK: - Toast and Placeholders
extension BaseViewController {
    
    func showToast(text: String) {
        removePlaceholder()
        view.endEditing(true)
        
        self.placeholderView = ToastView(view: view, text: text, bottomGuide: car_bottomLayoutGuide)
    }
    
    private func removePlaceholder() {
        placeholderView?.removeFromSuperview()
    }
    
    private func showPlaceholderWith(viewModel: PlaceholderViewModel, type: PlaceholderType) {
        view.endEditing(true)
        
        let containerView: UIView
        if viewModel.showOnNavigation {
            containerView = navigationController?.view ?? view
        }else {
            containerView = view
        }
        
        switch type {
        case .loading:
            showLoading(viewModel: viewModel, containerView: containerView)
            
        case .error:
            showError(viewModel: viewModel, containerView: containerView)
        }
    }
    
    private func showLoading(viewModel: PlaceholderViewModel, containerView: UIView) {
        removePlaceholder()
        self.placeholderView = LoadingView(view: containerView, with: viewModel)
    }
    
    private func showError(viewModel: PlaceholderViewModel, containerView: UIView) {
        removePlaceholder()
        self.placeholderView = ErrorView(view: containerView, with: viewModel)
    }
}

// MARK: - AlertViewModel
extension BaseViewController {
    
    func buidlAlertWith(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: viewModel.preferredStyle)
        
        //Trating when alert is showing in the iPad
        if let popoverController = alert.popoverPresentationController, let barButtonPosition = viewModel.barButtonPosition {
            switch barButtonPosition {
            case .left:
                popoverController.barButtonItem = navigationItem.leftBarButtonItem
            case .right:
                popoverController.barButtonItem = navigationItem.rightBarButtonItem
            case .back:
                popoverController.barButtonItem = navigationItem.backBarButtonItem
            }
        }
        
        viewModel.alertActions.forEach { (alertActionViewModel) in
            alert.addAction(alertActionViewModel.transform())
        }
        present(alert, animated: true)
    }
}

// MARK: - Keyboard notifications
extension BaseViewController {
    
    internal func listenToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo else { return }
        
        if let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            self.keyboardRect = keyboardRect
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        keyboardRect = .zero
    }
}

// MARK: - Supported Interface Orientations
extension BaseViewController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BaseViewController: UIGestureRecognizerDelegate {
    
}
