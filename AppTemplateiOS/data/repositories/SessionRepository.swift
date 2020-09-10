//
//  SessionRepository.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation
import RxSwift

protocol SessionRepositoryProtocol {
    
    var sessionState: Observable<UserSessionState> { get }
    func getAppVersion() -> Single<VersionAPI>
    func logout() -> Single<Void>
}

class SessionRepository: BaseRepository, SessionRepositoryProtocol {
    
    var sessionState: Observable<UserSessionState> {
        return SessionManager.shared.sessionState
    }
    
    func logout() -> Single<Void> {
        return apiClient
            .logout()
            .do(onSuccess: { _ in
                SessionManager.shared.logout()
            }, onError: { _ in
                SessionManager.shared.logout()
            })
    }
    
    func getAppVersion() -> Single<VersionAPI> {
        return apiClient
            .version()
    }
}
