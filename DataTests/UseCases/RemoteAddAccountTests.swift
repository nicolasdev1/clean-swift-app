//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Nicolas Carvalho on 11/01/21.
//

import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    // - MARK: Request Tests
    func test_add_should_call_httpClient_with_correct_url() {
        let url = makeUrl()
        let (systemUnderTest, httpClientSpy) = makeSystemUnderTest(url: url)
        systemUnderTest.add(addAccountModel: makeAddAccountModel()) { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpClient_with_correct_data() {
        let (systemUnderTest, httpClientSpy) = makeSystemUnderTest()
        let addAccountModel = makeAddAccountModel()
        systemUnderTest.add(addAccountModel: addAccountModel) { _ in }
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }
    
    // - MARK: Response Tests
    func test_add_should_complete_with_error_if_client_completes_with_error() {
        let (systemUnderTest, httpClientSpy) = makeSystemUnderTest()
        expect(systemUnderTest, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }
    
    func test_add_should_complete_with_account_if_client_completes_with_valid_data() {
        let (systemUnderTest, httpClientSpy) = makeSystemUnderTest()
        let account = makeAccountModel()
        expect(systemUnderTest, completeWith: .success(account), when: {
            httpClientSpy.completeWithData(account.toData()!)
        })
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data() {
        let (systemUnderTest, httpClientSpy) = makeSystemUnderTest()
        expect(systemUnderTest, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(makeInvalidData())
        })
    }
    
    func test_add_should_not_complete_if_systemUnderTest_has_been_deallocated() {
        let httpClientSpy = HttpClientSpy()
        var systemUnderTest: RemoteAddAccount? = RemoteAddAccount(url: makeUrl(), httpClient: httpClientSpy)
        var result: Result<AccountModel, DomainError>?
        systemUnderTest?.add(addAccountModel: makeAddAccountModel()) { result = $0 }
        systemUnderTest = nil
        httpClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}

// - MARK: Extensions Tests
extension RemoteAddAccountTests {
    func makeSystemUnderTest(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #file, line: UInt = #line) -> (systemUnderTest: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let systemUnderTest = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(for: systemUnderTest, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (systemUnderTest, httpClientSpy)
    }
    
    func expect(_ systemUnderTest: RemoteAddAccount, completeWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let expec = expectation(description: "waiting")
        systemUnderTest.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)):
                XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) received \(receivedResult) instead.", file: file, line: line)
            }
            expec.fulfill()
        }
        action()
        wait(for: [expec], timeout: 1)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "Any Name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
    }
}
