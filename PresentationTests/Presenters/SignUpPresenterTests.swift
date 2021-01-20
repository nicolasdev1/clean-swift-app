//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by Nicolas Carvalho on 20/01/21.
//

import XCTest
import Presentation

class SignUpPresenterTests: XCTestCase {
    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
        systemUnderTest.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo Nome é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", password: "any_password", passwordConfirmation: "any_password")
        systemUnderTest.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo E-mail é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com", passwordConfirmation: "any_password")
        systemUnderTest.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo Senha é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_passwordConfirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com", password: "any_password")
        systemUnderTest.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo Confirmar Senha é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_passwordConfirmation_is_not_match() {
        let alertViewSpy = AlertViewSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "wrong_password")
        systemUnderTest.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Falha ao confirmar senha"))
    }
    
    func test_signUp_should_call_emailValidator_with_correct_email() {
        let emailValidatorSpy = EmailValidatorSpy()
        let systemUnderTest = makeSystemUnderTest(emailValidator: emailValidatorSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "invalid_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
        systemUnderTest.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    func test_signUp_should_show_error_message_if_invalid_email_is_provided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let systemUnderTest = makeSystemUnderTest(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "invalid_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
        emailValidatorSpy.isValid = false
        systemUnderTest.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "E-mail inválido"))
    }
}

extension SignUpPresenterTests {
    func makeSystemUnderTest(alertView: AlertViewSpy = AlertViewSpy(), emailValidator: EmailValidatorSpy = EmailValidatorSpy()) -> SignUpPresenter {
        return SignUpPresenter(alertView: alertView, emailValidator: emailValidator)
    }
    
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
    
    class EmailValidatorSpy: EmailValidator {
        var isValid = true
        var email: String?
        
        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }
    }
}
