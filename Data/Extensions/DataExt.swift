//
//  DataExt.swift
//  Data
//
//  Created by Nicolas Carvalho on 14/01/21.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
