//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Nicolas Carvalho on 11/01/21.
//

import XCTest

class RemoteAddAccount {
    private let url: URL
    private let httpClient: HttpPostClient
    
    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add() {
        httpClient.post(url: self.url)
    }
}

protocol HttpPostClient {
    func post(url: URL)
}

class RemoteAddAccountTests: XCTestCase {
    func test_() {
        let url = URL(string: "http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let systemUnderTest = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        systemUnderTest.add()
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        
        func post(url: URL) {
            self.url = url
        }
    }
}
