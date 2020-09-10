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
    
    // MARK: - Others
    case registerToken(token: String)
    case appVersion
}

extension APITarget: TargetType {
    
    var baseURL: URL {
        return URL(string: "\(APPHosts.baseURLString)/\(APIVersion.v1)/")!
    }
    
    var path: String {
        switch self {
            
        //MARK: - Authentication
        case .sighIn: return "users/login"
        case .sighInFacebook: return "users/facebook_auth"
        case .sighInGoogle: return "users/google_auth"
        case .sighInApple: return "users/apple_auth"
        case .createAccount: return "users"
        case .forgotPassword: return "users/recover_password"
        case .logout: return "users/logout"
            
        //MARK: - Dashboard
            
        // MARK: - Others
        case .registerToken: return "devices"
        case .appVersion: return "minimum_version"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .forgotPassword: return .put
        case .appVersion: return .get
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
            
        case .sighIn(let email, let password, let token):
            var bodyParams: [String: Any] = [
                "email": email,
                "password": password,
                "platform": "ios"
            ]
            
            if let token = token {
                bodyParams["token"] = token
            }
            
            return .requestParameters(parameters: bodyParams, encoding: JSONEncoding())
            
        case .sighInFacebook(let facebookToken, let firebaseToken):
            var bodyParams: [String: Any] = [
                "facebook_token": facebookToken,
                "platform": "ios"
            ]
            
            if let token = firebaseToken {
                bodyParams["token"] = token
            }
            
            return .requestParameters(parameters: bodyParams, encoding: JSONEncoding())
            
        case .sighInGoogle(let googleToken, let firebaseToken):
            var bodyParams: [String: Any] = [
                "google_token": googleToken,
                "platform": "ios"
            ]
            
            if let token = firebaseToken {
                bodyParams["token"] = token
            }
            
            return .requestParameters(parameters: bodyParams, encoding: JSONEncoding())
            
        case .sighInApple(let email, let fullName, let firebaseToken):
            var bodyParams: [String: Any] = [
                "platform": "ios"
            ]
            
            if let email = email {
                bodyParams["email"] = email
            }
            
            if let fullName = fullName {
                bodyParams["full_name"] = fullName
            }
            
            if let token = firebaseToken {
                bodyParams["token"] = token
            }
            
            return .requestParameters(parameters: bodyParams, encoding: JSONEncoding())
            
        case .createAccount(let request):
            if let multipart = request.toMultiPartIfNeeded() {
                return .uploadCompositeMultipart(multipart, urlParameters: request.toJSON())
            }
            
            return .requestParameters(parameters: request.toJSON(), encoding: JSONEncoding())
            
        case .forgotPassword(let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding())
            
        case .registerToken(let token):
            return .requestParameters(parameters: ["token": token, "platform": "ios"], encoding: JSONEncoding())
            
        case .appVersion:
            return .requestParameters(parameters: ["platform": "ios"], encoding: URLEncoding())
            
        default:
            return .requestPlain
        }
    }
}
