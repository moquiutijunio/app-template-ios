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
}

class SessionRepository: BaseRepository, SessionRepositoryProtocol {
    
    var sessionState: Observable<UserSessionState> {
        return SessionManager.shared.sessionState
    }
}
