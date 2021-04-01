//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by Nicolas Carvalho on 20/01/21.
//

import XCTest
import Presentation
import Domain

class SignUpPresenterTests: XCTestCase {
    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy)
        let expec = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "Nome"))
            expec.fulfill()
        }
        systemUnderTest.signUp(viewModel: makeSignUpViewModel(name: nil))
        wait(for: [expec], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy)
        let expec = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "E-mail"))
            expec.fulfill()
        }
        systemUnderTest.signUp(viewModel: makeSignUpViewModel(email: nil))
        wait(for: [expec], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy)
        let expec = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "Senha"))
            expec.fulfill()
        }
        systemUnderTest.signUp(viewModel: makeSignUpViewModel(password: nil))
        wait(for: [expec], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_passwordConfirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy)
        let expec = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "Confirmar Senha"))
            expec.fulfill()
        }
        systemUnderTest.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        wait(for: [expec], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_passwordConfirmation_is_not_match() {
        let alertViewSpy = AlertViewSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy)
        let expec = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeInvalidAlertViewModel(fieldName: "Confirmar Senha"))
            expec.fulfill()
        }
        systemUnderTest.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "wrong_password"))
        wait(for: [expec], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_invalid_email_is_provided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        let expec = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeInvalidAlertViewModel(fieldName: "E-mail"))
            expec.fulfill()
        }
        emailValidatorSpy.simulateInvalidEmail()
        systemUnderTest.signUp(viewModel: makeSignUpViewModel())
        wait(for: [expec], timeout: 1)
    }
    
    func test_signUp_should_call_emailValidator_with_correct_email() {
        let emailValidatorSpy = EmailValidatorSpy()
        let systemUnderTest = makeSystemUnderTest(emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        systemUnderTest.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    func test_signUp_should_call_addAccount_with_correct_values() {
        let addAccountSpy = AddAccountSpy()
        let systemUnderTest = makeSystemUnderTest(addAccount: addAccountSpy)
        systemUnderTest.signUp(viewModel:  makeSignUpViewModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }
    
    func test_signUp_should_show_error_message_if_addAccount_fails() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy, addAccount: addAccountSpy)
        let expec = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeErrorAlertViewModel(message: "Ocorreu algo inesperado, tente novamente em alguns instantes."))
            expec.fulfill()
        }
        systemUnderTest.signUp(viewModel: makeSignUpViewModel())  
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [expec], timeout: 1)
    }
    
    func test_signUp_should_show_loading_if_before_call_addAccount() {
        let loadingViewSpy: LoadingViewSpy = LoadingViewSpy()
        let systemUnderTest = makeSystemUnderTest(loadingView: loadingViewSpy)
        systemUnderTest.signUp(viewModel: makeSignUpViewModel())
        XCTAssertEqual(loadingViewSpy.viewModel, LoadingViewModel(isLoading: true))
    }
}

extension SignUpPresenterTests {
    func makeSystemUnderTest(alertView: AlertViewSpy = AlertViewSpy(), emailValidator: EmailValidatorSpy = EmailValidatorSpy(), addAccount: AddAccountSpy = AddAccountSpy(), loadingView: LoadingViewSpy = LoadingViewSpy(), file: StaticString = #file, line: UInt = #line) -> SignUpPresenter {
        let systemUnderTest: SignUpPresenter = SignUpPresenter(alertView: alertView, emailValidator: emailValidator, addAccount: addAccount, loadingView: loadingView)
        checkMemoryLeak(for: systemUnderTest, file: file, line: line)
        return systemUnderTest
    }
    
    func makeSignUpViewModel(name: String? = "Any Name", email: String? = "any_email@mail.com", password: String? = "any_password", passwordConfirmation: String? = "any_password") -> SignUpViewModel {
        return SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    func makeRequiredAlertViewModel(fieldName: String) -> AlertViewModel {
        return AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é obrigatório.")
    }
    
    func makeInvalidAlertViewModel(fieldName: String) -> AlertViewModel {
        return AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é inválido.")
    }
    
    func makeErrorAlertViewModel(message: String) -> AlertViewModel {
        return AlertViewModel(title: "Erro", message: message)
    }
    
    class AlertViewSpy: AlertView {
        var emit: ((AlertViewModel) -> Void)?
        
        func observe(completion: @escaping (AlertViewModel) -> Void) {
            self.emit = completion
        }
        
        func showMessage(viewModel: AlertViewModel) {
            self.emit?(viewModel)
        }
    }
    
    class EmailValidatorSpy: EmailValidator {
        var isValid = true
        var email: String?
        
        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }
        
        func simulateInvalidEmail() {
            isValid = false
        }
    }
    
    class AddAccountSpy: AddAccount {
        var addAccountModel: AddAccountModel?
        var completion: ((Result<AccountModel, DomainError>) -> Void)?
        
        func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
            self.addAccountModel = addAccountModel
            self.completion = completion
        }
        
        func completeWithError(_ error: DomainError) {
            completion?(.failure(error))
        }
    }
    
    class LoadingViewSpy: LoadingView {
        var viewModel: LoadingViewModel?
        
        func display(viewModel: LoadingViewModel) {
            self.viewModel = viewModel
        }
    }
}
