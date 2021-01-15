//
//  TestFactories.swift
//  DataTests
//
//  Created by Nicolas Carvalho on 14/01/21.
//

import Foundation
import Domain

func makeValidData() -> Data {
    return Data("{\"name\":\"Any Name\"}".utf8)
}

func makeInvalidData() -> Data {
    return Data("invalid_data".utf8)
}

func makeUrl() -> URL {
    return URL(string: "http://any-url.com")!
}

func makeAccountModel() -> AccountModel {
    return AccountModel(id: "any_id", name: "Any Name", email: "any_email@mail.com", password: "any_password")
}
