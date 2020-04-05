//
//  APITarget.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Moya

let provider = MoyaProvider<APITarget>( endpointClosure: { (target) -> Endpoint in
    
    return Endpoint(url: "\(target.baseURL)\(target.path)",
        sampleResponseClosure: {.networkResponse(200, target.sampleData)},
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers)
    
}, plugins: [NetworkActivityPlugin { (change, _)  in
    
    switch change {
    case .began:
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    case .ended:
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }}, NetworkLoggerPlugin(verbose: true)])

enum APITarget {
    
    //MARK: - Authentication
    case sighIn(email: String, password: String, token: String?)
    case sighInFacebook(facebookToken: String, firebaseToken: String?)
    case sighInGoogle(googleToken: String, firebaseToken: String?)
    case sighInApple(email: String?, fullName: String?, firebaseToken: String?)
    case createAccount(request: RegisterUserRequest)
    case forgotPassword(email: String)
    case logout
    
    //MARK: - Dashboard
}

extension APITarget: TargetType {
    
    var baseURL: URL {
        return APIClientHost.baseURL as URL
    }
    
    var path: String {
        switch self {
            
        //MARK: - Authentication
        case .sighIn: return "/users/sigh_in"
        case .sighInFacebook: return "/users/facebook_auth"
        case .sighInGoogle: return "/users/google_auth"
        case .sighInApple: return "/users/apple_auth"
        case .createAccount: return "/users"
        case .forgotPassword: return "/users/recover_password"
        case .logout: return "/users/logout"
            
        //MARK: - Dashboard
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .forgotPassword: return .put
        case .logout: return .delete
        default: return .post
        }
    }
    
    var headers: [String: String]? {
        var httpHeaderFields: [String: String] = [
            "Content-Type": "application/json"
        ]
        
        if let session = SessionManager.shared.retrieveUserSession() {
            httpHeaderFields["USER_TOKEN"] = session.accessToken
            httpHeaderFields["USER_EMAIL"] = session.currentUser.email
        }
        
        return httpHeaderFields
    }
    
    var sampleData: Data {
        switch self {
        default: return Data()
        }
    }
    
    var task: Task {
        switch self {
            
        case .sighIn(let params):
            var bodyParams: [String: Any] = [
                "email": params.email,
                "password": params.password,
                "platform": "ios"
            ]
            
            if let token = params.token {
                bodyParams["token"] = token
            }
            
            return Task.requestParameters(parameters: bodyParams, encoding: JSONEncoding())
            
        case .sighInFacebook(let params):
            var bodyParams: [String: Any] = [
                "facebook_token": params.facebookToken,
                "platform": "ios"
            ]
            
            if let token = params.firebaseToken {
                bodyParams["token"] = token
            }
            
            return Task.requestParameters(parameters: bodyParams, encoding: JSONEncoding())
            
        case .sighInGoogle(let params):
            var bodyParams: [String: Any] = [
                "google_token": params.googleToken,
                "platform": "ios"
            ]
            
            if let token = params.firebaseToken {
                bodyParams["token"] = token
            }
            
            return Task.requestParameters(parameters: bodyParams, encoding: JSONEncoding())
            
        case .sighInApple(let params):
            var bodyParams: [String: Any] = [
                "platform": "ios"
            ]
            
            if let email = params.email {
                bodyParams["email"] = email
            }
            
            if let fullName = params.fullName {
                bodyParams["full_name"] = fullName
            }
            
            if let token = params.firebaseToken {
                bodyParams["token"] = token
            }
            
            return Task.requestParameters(parameters: bodyParams, encoding: JSONEncoding())
            
        case .createAccount(let request):
            if let multipart = request.toMultiPartIfNeeded() {
                return .uploadCompositeMultipart(multipart, urlParameters: request.toJSON())
            }
            
            return .requestParameters(parameters: request.toJSON(), encoding: JSONEncoding())
            
        case .forgotPassword(let email):
            return Task.requestParameters(parameters: ["email": email], encoding: JSONEncoding())
            
        default:
            return Task.requestPlain
        }
    }
}
