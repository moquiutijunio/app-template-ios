//
//  BaseInteractor.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

class BaseInteractor {
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}
