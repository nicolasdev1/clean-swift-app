//
//  InfraTests.swift
//  InfraTests
//
//  Created by Nicolas Carvalho on 14/01/21.
//

import XCTest
import Data
import Alamofire

class AlamofireAdapter {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
        session.request(url, method: .post, parameters: data?.toJson(), encoding: JSONEncoding.default).responseData { dataResponse in
            switch dataResponse.result {
            case .failure:
                completion(.failure(.noConnectivity))
            case .success:
                break
            }
        }
    }
}

class AlamofireAdapterTests: XCTestCase {
    func test_post_should_make_request_with_valid_url_and_method() {
        let url = makeUrl()
        testRequestFor(url: url, data: makeValidData()) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_make_request_with_no_data() {
        testRequestFor(data: nil) { request in
            XCTAssertNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_complete_with_error_when_request_completes_with_error() {
        let systemUnderTest = makeSystemUnderTest()
        UrlProtocolStub.simulate(data: nil, response: nil, error: makeError())
        let expec = expectation(description: "waiting")
        systemUnderTest.post(to: makeUrl(), with: makeValidData()) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noConnectivity)
            case .success:
                XCTFail("Expected error got \(result) instead.")
            }
            expec.fulfill()
        }
        wait(for: [expec], timeout: 1)
    }
}

extension AlamofireAdapterTests {
    func makeSystemUnderTest(file: StaticString = #file, line: UInt = #line) -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let systemUnderTest = AlamofireAdapter(session: session)
        checkMemoryLeak(for: systemUnderTest, file: file, line: line)
        return systemUnderTest
    }
    
    func testRequestFor(url: URL = makeUrl(), data: Data?, action: @escaping (URLRequest) -> Void) {
        let systemUnderTest = makeSystemUnderTest()
        systemUnderTest.post(to: url, with: data) { _ in }
        let expec = expectation(description: "waiting")
        UrlProtocolStub.observeRequest { request in
            action(request)
            expec.fulfill()
        }
        wait(for: [expec], timeout: 1)
    }
}

class UrlProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    static var data: Data?
    static var response: HTTPURLResponse?
    static var error: Error?
    
    static func observeRequest(completion: @escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }
    
    static func simulate(data: Data?, response: HTTPURLResponse?, error: Error?) {
        UrlProtocolStub.data = data
        UrlProtocolStub.response = response
        UrlProtocolStub.error = error
    }
    
    open override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    open override func startLoading() {
        UrlProtocolStub.emit?(request)
        if let data = UrlProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        if let response = UrlProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let error = UrlProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    open override func stopLoading() {}
}
