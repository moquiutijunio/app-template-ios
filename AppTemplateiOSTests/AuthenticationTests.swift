//
//  AuthenticationTests.swift
//  AppTemplateiOSTests
//
//  Created by Junio Moquiuti on 08/04/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import XCTest

class AuthenticationTests: XCTestCase {

    func testUserResult() {
    
        //Mock user result
        var userAPI = UserAPI()
        userAPI.id = 1
        userAPI.name = "Junio Cesar Moquiuti"
        userAPI.email = "moquiuti@jera.com.br"
        
        let result: Result<UserAPI, Error> = .success(userAPI)
        
        if case .success(let userAPI) = result {
            guard let user = User.map(user: userAPI) else {
                XCTFail("Failed to mapper userAPI")
                return
            }
            
            XCTAssertEqual(user.id, 1)
            XCTAssertEqual(user.name, "Junio Cesar Moquiuti")
            XCTAssertEqual(user.email, "moquiuti@jera.com.br")
        }
    }
}
