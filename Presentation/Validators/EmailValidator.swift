//
//  EmailValidator.swift
//  Presentation
//
//  Created by Nicolas Carvalho on 20/01/21.
//

import Foundation

public protocol EmailValidator {
    func isValid(email: String) -> Bool
}
