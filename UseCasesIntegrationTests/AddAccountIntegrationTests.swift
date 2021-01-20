//
//  UseCasesIntegrationTests.swift
//  UseCasesIntegrationTests
//
//  Created by Nicolas Carvalho on 19/01/21.
//

import XCTest
import Data
import Infra
import Domain

class AddAccountIntegrationTests: XCTestCase {
    func test_add_account() {
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "https://sign-auth.herokuapp.com/api/v1/signup")!
        let systemUnderTest = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        let addAccountModel = AddAccountModel(name: "Nicolas Carvalho", email: "nicolaspessoal@icloud.com", password: "secret", passwordConfirmation: "secret")
        let expec = expectation(description: "waiting")
        systemUnderTest.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure:
                XCTFail("Expect success got \(result) instead.")
            case .success(let account):
                XCTAssertNotNil(account.id)
                XCTAssertEqual(account.name, addAccountModel.name)
                XCTAssertEqual(account.email, addAccountModel.email)
            }
            expec.fulfill()
        }
        wait(for: [expec], timeout: 5)
    }
}
