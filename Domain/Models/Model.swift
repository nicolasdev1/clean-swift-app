//
//  Model.swift
//  Domain
//
//  Created by Nicolas Carvalho on 14/01/21.
//

import Foundation

public protocol Model: Codable, Equatable {}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
