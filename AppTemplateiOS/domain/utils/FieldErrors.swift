//
//  FieldErrors.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 31/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

// MARK: - DefaultFieldError
enum DefaultFieldError: Equatable {
    case empty
    
    var error: String {
        switch self {
        case .empty: return ""
        }
    }
    
    static func isValid(text: String) -> DefaultFieldError? {
        
        if text.isEmpty {
            return .empty
        }
        
        return nil
    }
}

// MARK: - CpfFieldError
enum CpfFieldError: Equatable {
    
    case empty
    case notValid
    
    var error: String {
        switch self {
        case .empty: return ""
        case .notValid: return R.string.localizable.messageCpfInvalid()
        }
    }
    
    static func isValid(text: String) -> CpfFieldError? {
        
        if text.isEmpty {
            return .empty
        }
        
        if !text.isValidCPF {
            return .notValid
        }
        
        return nil
    }
}

// MARK: - EmailFieldError
enum EmailFieldError: Equatable {
    case empty
    case notValid
    
    var error: String {
        switch self {
        case .empty: return ""
        case .notValid: return R.string.localizable.emailNotValid()
        }
    }
    
    static func isValid(text: String) -> EmailFieldError? {
        
        if text.isEmpty {
            return .empty
        }
        
        if !text.isValidEmail {
            return .notValid
        }
        
        return nil
    }
}

// MARK: - PhoneFieldError
enum PhoneFieldError: Equatable {
    case empty
    case minCharaters(count: Int)
    
    var error: String {
        switch self {
        case .empty: return ""
        case .minCharaters(let count): return R.string.localizable.passwordValueMinimum(count.description)
        }
    }
    
    static func isValid(text: String) -> PhoneFieldError? {
        
        if text.isEmpty {
            return .empty
        }
        
        if !text.isValidPhone {
            return .minCharaters(count: 10)
        }
        
        return nil
    }
}

// MARK: - PasswordFieldError
enum PasswordFieldError: Equatable {
    case empty
    case minCharaters(count: Int)
    
    var error: String {
        switch self {
        case .empty: return ""
        case .minCharaters(let count): return R.string.localizable.passwordValueMinimum(count.description)
        }
    }
    
    static func isValid(text: String) -> PasswordFieldError? {
        
        if text.isEmpty {
            return .empty
        }
        
        if !text.isValidPassword {
            return .minCharaters(count: 6)
        }
        
        return nil
    }
}

enum ConfirmPasswordFieldError: Equatable {
    case empty
    case confirmPasswordNotMatch
    
    var error: String {
        switch self {
        case .empty: return ""
        case .confirmPasswordNotMatch: return R.string.localizable.messagePasswordNotEqual()
        }
    }
    
    static func isValid(password: String, passwordConfirm: String) -> ConfirmPasswordFieldError? {
        
        if password.isEmpty || passwordConfirm.isEmpty {
            return .empty
        }
        
        if password != passwordConfirm {
            return .confirmPasswordNotMatch
        }
        
        return nil
    }
}
