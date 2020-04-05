//
//  ObservableType.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    public func unwrap<T>() -> Observable<T> where E == T? {
        return self
            .filter { $0 != nil }
            .map { $0! }
    }
}
