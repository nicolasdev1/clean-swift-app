//
//  RemoteAddAccount.swift
//  Data
//
//  Created by Nicolas Carvalho on 14/01/21.
//

import Foundation
import Domain

public final class RemoteAddAccount: AddAccount {
    private let url: URL
    private let httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
        httpClient.post(to: self.url, with: addAccountModel.toData()) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure:
                completion(.failure(.unexpected))
            case .success(let data):
                if let model: AccountModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
            }
        }
    }
}
