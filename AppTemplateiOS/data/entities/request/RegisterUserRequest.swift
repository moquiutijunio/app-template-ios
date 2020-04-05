//
//  RegisterUserRequest.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 03/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Moya

struct RegisterUserRequest {
    
    var name: String
    var email: String
    var password: String
    var image: UIImage?
    
    func toJSON() -> [String: Any] {
        var bodyParams = [String: Any]()
        
        bodyParams["name"] = name
        bodyParams["email"] = email
        bodyParams["password"] = password
        
        return bodyParams
    }
    
    func toMultiPartIfNeeded() -> [MultipartFormData]? {
        guard let imageData = image?.jpegData(compressionQuality: 0.8) else { return nil }
        return [Moya.MultipartFormData(provider: MultipartFormData.FormDataProvider.data(imageData),
                                       name: "avatar",
                                       fileName: "avatar.jpg",
                                       mimeType: "avatar/jpg")]
    }
}
