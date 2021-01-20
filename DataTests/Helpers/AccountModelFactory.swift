//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by Nicolas Carvalho on 20/01/21.
//

import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    return AccountModel(id: 0, name: "Any Name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
}

func makeAddAccountModel() -> AddAccountModel {
    return AddAccountModel(name: "Any Name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
}
