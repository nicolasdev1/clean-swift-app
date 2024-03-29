//
//  SignUpPresenter.swift
//  Presentation
//
//  Created by Nicolas Carvalho on 20/01/21.
//

import Foundation
import Domain

public final class SignUpPresenter {
    private let alertView: AlertView
    private let emailValidator: EmailValidator
    private let addAccount: AddAccount
    private let loadingView: LoadingView
    
    public init(alertView: AlertView, emailValidator: EmailValidator, addAccount: AddAccount, loadingView: LoadingView) {
        self.alertView = alertView
        self.emailValidator = emailValidator
        self.addAccount = addAccount
        self.loadingView = loadingView
    }
    
    public func signUp(viewModel: SignUpViewModel) {
        if let message = validate(viewModel: viewModel) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            let addAccountModel = AddAccountModel(name: viewModel.name!, email: viewModel.email!, password: viewModel.password!, passwordConfirmation: viewModel.passwordConfirmation!)
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            addAccount.add(addAccountModel: addAccountModel) { [weak self] result in
                switch result {
                case .failure:
                    self?.alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: "Ocorreu algo inesperado, tente novamente em alguns instantes."))
                case .success:
                    break
                }
            }
        }
    }
    
    private func validate(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "O campo Nome é obrigatório."
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "O campo E-mail é obrigatório."
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "O campo Senha é obrigatório."
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "O campo Confirmar Senha é obrigatório."
        } else if viewModel.password != viewModel.passwordConfirmation {
            return "O campo Confirmar Senha é inválido."
        } else if !emailValidator.isValid(email: viewModel.email!) {
            return "O campo E-mail é inválido."
        }
        return nil
    }
}

public struct SignUpViewModel {
    public var name: String?
    public var email: String?
    public var password: String?
    public var passwordConfirmation: String?
    
    public init(name: String? = nil, email: String? = nil, password: String? = nil, passwordConfirmation: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
