//
//  ErrorHelper.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation
import Moya
import RxSwift

extension MoyaError {
    
    public func translateMoyaError(errorType: Swift.Error) -> NSError {
        guard let moyaError = errorType as? Moya.MoyaError else {
            return errorType as NSError
        }
        
        switch moyaError {
        case .underlying(let error, _):
            return error as NSError
        default:
            return moyaError as NSError
        }
    }
}
