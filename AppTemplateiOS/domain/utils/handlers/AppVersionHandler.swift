//
//  AppVersionHandler.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 10/09/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift
import Foundation

protocol AppVersionHandlerProtocol {
    func checkVersion()
}

class AppVersionHandler: NSObject, AppVersionHandlerProtocol {
    
    static let shared: AppVersionHandlerProtocol = AppVersionHandler()
    
    var disposeBag: DisposeBag!
    
    func checkVersion() {
        disposeBag = DisposeBag()
        
        SessionRepository()
            .getAppVersion()
            .subscribe(onSuccess: { [weak self] (versionAPI) in
                guard let self = self,
                    let appVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                    let appVersion = Int(appVersionString.replacingOccurrences(of: ".", with: "")) else {
                        return
                }
                
                if appVersion < versionAPI.versionNumber {
                    self.showAppVersionAlert(version: versionAPI.required ? .updatedRequired : .outdated)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func showAppVersionAlert(version: Version) {
        guard let viewController = PresentationHelper.topViewController() as? BaseViewController else { return }
        
        if version != .updated {
            var actions = [AlertActionViewModel]()
            actions.append(AlertActionViewModel(title: R.string.localizable.update(),
                                                           action: { [unowned self] in
                                                            self.goToAplicationInAppStore()
            }))
            
            if version != .updatedRequired {
                actions.append(AlertActionViewModel(title: R.string.localizable.cancel()))
            }
            
            let viewModel = AlertViewModel(title: R.string.localizable.versionAlertTitle(),
                                           message: R.string.localizable.versionAlertBody(),
                                           actions: actions)
            
            viewController.buidlAlertWith(viewModel: viewModel)
        }
    }
    
    private func goToAplicationInAppStore() {
        UIApplication.shared.open(APPHosts.appURL, options: [:], completionHandler: nil)
    }
}
