//
//  AnalyticsLogEvent.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation
import FirebaseAnalytics

enum EventTypes {
    case login
    
    var name: String {
        switch self {
        default: return ""
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        default: return nil
        }
    }
}

class AnalyticsLogEvent {
    
    class func register(event: EventTypes) {
        Analytics.logEvent(event.name.removeAccentsAndSpecialCharacteres,
                           parameters: event.parameters)
    }
}
