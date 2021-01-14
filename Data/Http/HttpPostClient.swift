//
//  HttpPostClient.swift
//  Data
//
//  Created by Nicolas Carvalho on 14/01/21.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}
