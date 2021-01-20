//
//  AccountModel.swift
//  Domain
//
//  Created by Nicolas Carvalho on 11/01/21.
//

import Foundation

public struct AccountModel: Model {
    public var id: Int
    public var name: String
    public var email: String
    public var password: String
    public var passwordConfirmation: String
    
    public init(id: Int, name: String, email: String, password: String, passwordConfirmation: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
