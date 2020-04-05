//
//  RequestResponse.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

enum RequestResponse<T> {
    
    case new
    case loading
    case success(T)
    case failure(Error)
    case cancelled
}
