//
//  DomainUtils.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

enum DomainUtils {
    
    public static func dateFrom(string: String?) -> Date? {
        guard let stringValue = string else {return nil}
        
        let parseFormat = DateFormatter()
        
        let dateFormat =  ["dd/MM/yyyy",
                           "yyyy-MM-dd",
                           "yyyy-MM-dd'T'HH:mm:ss",
                           "yyyy-MM-ddTHH:mm:ss",
                           "yyyy-MM-dd'T'HH:mm:ss",
                           "yyyy-MM-dd'T'HH:mm:ssZZ",
                           "yyyy-MM-dd'T'HH:mm:ssZZZ",
                           "yyyy-MM-dd'T'HH:mm:ss.SSS",
                           "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ",
                           "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZ",
                           "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZ",
                           "yyyy-MM-dd HH:mm:ss +zzzz",
                           "HH:mm:ss",
                           "HH:mm"]
        
        let dates = dateFormat.compactMap { format -> Date? in
            parseFormat.dateFormat = format
            parseFormat.timeZone = TimeZone.current
            return parseFormat.date(from: stringValue)
        }
        return dates.first
    }
}
