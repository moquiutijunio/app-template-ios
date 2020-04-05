//
//  ViewResponse.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

enum ViewState {
    case normal
    case loading(PlaceholderViewModel)
    case failure(PlaceholderViewModel)
}

enum ListResponse<T> {
    case new
    case loading
    case success(T, infinityScrollEnabled: Bool? = nil)
    case failure(String)
}
