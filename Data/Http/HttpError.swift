//
//  HttpError.swift
//  Data
//
//  Created by Nicolas Carvalho on 14/01/21.
//

import Foundation

public enum HttpError: Error {
    case noConnectivity
    case badRequest
    case serverError
    case unauthorized
    case forbidden
}
