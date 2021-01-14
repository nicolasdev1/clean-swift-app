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
        let url = URL(string: "http://any-url.com")!
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
        let expec = expectation(description: "waiting")
        systemUnderTest.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            case .success:
                XCTFail("Expected error received \(result) instead.")
            }
            expec.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
        wait(for: [expec], timeout: 1)
    }
}

// - MARK: Extensions Tests
extension RemoteAddAccountTests {
    func makeSystemUnderTest(url: URL = URL(string: "http://any-url.com")!) -> (systemUnderTest: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let systemUnderTest = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (systemUnderTest, httpClientSpy)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "Any Name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
    }
    
    class HttpClientSpy: HttpPostClient {
        var urls: [URL] = []
        var data: Data?
        var completion: ((Result<Data, HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
    }
}
