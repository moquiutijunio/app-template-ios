//
//  BaseRepository.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

class BaseRepository {
    
    internal let apiClient: APIClientProtocol
    
    init() {
        self.apiClient = APIClient()
    }
}
