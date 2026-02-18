//
//  AuthPresenter.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 26.01.2026.
//

import Foundation
import FirebaseAuth

protocol AuthView: AnyObject, ErrorView {
    func display(mode: AuthModeViewModel)
    func setActionEnabled(_ isEnabled: Bool)
    func setLoading(_ isLoading: Bool)
    func showCredentialsError(message: String)
    func hideCredentialsError()
    func showSignUpEmailError(message: String)
    func hideSignUpEmailError()
}

protocol AuthPresenter {
    func viewDidLoad()
    func didUpdateEmail(_ text: String)
    func didUpdatePassword(_ text: String)
    func didUpdateConfirmPassword(_ text: String)
    func didTapAction()
    func didTapReset()
    func didTapForgotPassword()
    func didTapShowSignUp()
}

enum AuthMode {
    case signIn
    case signUp
}

struct AuthModeViewModel {
    let title: String
    let actionTitle: String
    let isConfirmVisible: Bool
}

final class AuthPresenterImpl: AuthPresenter {
    
    weak var view: AuthView?

    private let authService: AuthService
    private let router: AuthRouting

    private var mode: AuthMode {
        didSet {
            updateMode()
            updateActionState()
        }
    }
    private var email = ""
    private var password = ""
    private var confirmPassword = ""
    private var isLoading = false

    init(authService: AuthService, router: AuthRouting, initialMode: AuthMode = .signIn) {
        self.authService = authService
        self.router = router
        self.mode = initialMode
    }

    func viewDidLoad() {
        updateMode()
        updateActionState()
        view?.hideCredentialsError()
        view?.hideSignUpEmailError()
    }

    func didUpdateEmail(_ text: String) {
        email = text.trimmingCharacters(in: .whitespacesAndNewlines)
        updateActionState()
        view?.hideCredentialsError()
        view?.hideSignUpEmailError()
    }

    func didUpdatePassword(_ text: String) {
        password = text
        updateActionState()
        view?.hideCredentialsError()
        view?.hideSignUpEmailError()
    }

    func didUpdateConfirmPassword(_ text: String) {
        confirmPassword = text
        updateActionState()
        view?.hideSignUpEmailError()
    }

    func didTapAction() {
        guard !isLoading else { return }
        let validation = validateInputs()
        guard validation.isValid else {
            if mode == .signUp {
                view?.showSignUpEmailError(message: validation.message)
                return
            }
            if mode == .signIn {
                view?.showCredentialsError(message: validation.message)
                return
            }
            showError(message: validation.message)
            return
        }

        isLoading = true
        view?.setLoading(true)

        let completion: AuthCompletion = { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                self.view?.setLoading(false)
                switch result {
                case .success:
                    self.router.showMain()
                case .failure(let error):
                    self.handleAuthError(error)
                }
            }
        }

        switch mode {
        case .signIn:
            authService.signIn(email: email, password: password, completion: completion)
        case .signUp:
            authService.signUp(email: email, password: password, completion: completion)
        }
    }

    func didTapReset() {
        updateActionState()
    }
    
    func didTapForgotPassword() {
        router.showPasswordReset()
    }

    func didTapShowSignUp() {
        router.showSignUp()
    }

    private func updateMode() {
        let viewModel = AuthModeViewModel(
            title: mode == .signIn
            ? NSLocalizedString("Вход", comment: "sign in")
            : NSLocalizedString("Регистрация", comment: "sign up title"),
            actionTitle: mode == .signIn
            ? NSLocalizedString("Войти", comment: "sign in button")
            : NSLocalizedString("Зарегистрироваться", comment: "sign up button"),
            isConfirmVisible: mode == .signUp
        )
        view?.display(mode: viewModel)
        view?.hideCredentialsError()
        view?.hideSignUpEmailError()
    }

    private func updateActionState() {
        view?.setActionEnabled(isActionEnabled())
    }

    private func isActionEnabled() -> Bool {
        true
    }

    private func validateInputs() -> (isValid: Bool, message: String) {
        guard isValidEmail(email) else {
            return (false, NSLocalizedString("Введите корректный email", comment: "invalid email"))
        }
        guard password.count >= 6 else {
            return (false, NSLocalizedString("Пароль должен быть не короче 6 символов", comment: "weak password"))
        }
        if mode == .signUp, confirmPassword != password {
            return (false, NSLocalizedString("Пароли не совпадают", comment: "password mismatch"))
        }
        return (true, "")
    }

    private func isValidEmail(_ text: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: text)
    }

    private func message(for error: Error) -> String {
        let nsError = error as NSError
        if let code = AuthErrorCode(rawValue: nsError.code) {
            switch code {
            case .invalidEmail:
                return NSLocalizedString("Неверный формат email", comment: "auth error")
            case .emailAlreadyInUse:
                return NSLocalizedString("Такой email уже зарегистрирован", comment: "auth error")
            case .weakPassword:
                return NSLocalizedString("Слишком простой пароль", comment: "auth error")
            case .userNotFound:
                return NSLocalizedString("Пользователь не найден", comment: "auth error")
            case .wrongPassword:
                return NSLocalizedString("Неверный пароль", comment: "auth error")
            case .networkError:
                return NSLocalizedString("Не удалось войти в систему", comment: "auth error")
            case .tooManyRequests:
                return NSLocalizedString("Слишком много попыток. Попробуйте позже", comment: "auth error")
            default:
                break
            }
        }
        return error.localizedDescription.isEmpty
        ? NSLocalizedString("Произошла неизвестная ошибка", comment: "auth error")
        : error.localizedDescription
    }

    private func handleAuthError(_ error: Error) {
        if mode == .signIn {
            if isInvalidCredentialsError(error) {
                view?.showCredentialsError(
                    message: NSLocalizedString(
                        "Введен неверный логин или пароль",
                        comment: "invalid credentials"
                    )
                )
                return
            }
            if isNetworkError(error) {
                view?.hideCredentialsError()
                showError(message: message(for: error))
                return
            }
            view?.showCredentialsError(message: message(for: error))
            return
        }
        if mode == .signUp, isEmailAlreadyInUseError(error) {
            view?.showSignUpEmailError(message: message(for: error))
            return
        }
        view?.hideCredentialsError()
        view?.hideSignUpEmailError()
        showError(message: message(for: error))
    }

    private func isInvalidCredentialsError(_ error: Error) -> Bool {
        let nsError = error as NSError
        guard let code = AuthErrorCode(rawValue: nsError.code) else { return false }
        switch code {
        case .userNotFound, .wrongPassword, .invalidEmail, .invalidCredential:
            return true
        default:
            return false
        }
    }

    private func isEmailAlreadyInUseError(_ error: Error) -> Bool {
        let nsError = error as NSError
        guard let code = AuthErrorCode(rawValue: nsError.code) else { return false }
        return code == .emailAlreadyInUse
    }

    private func isNetworkError(_ error: Error) -> Bool {
        let nsError = error as NSError
        guard let code = AuthErrorCode(rawValue: nsError.code) else { return false }
        return code == .networkError
    }

    private func showError(message: String) {
        let title = NSLocalizedString("Что-то пошло не так(", comment: "")
        let primary = ErrorAction(
            title: NSLocalizedString("Ок", comment: "Ок"),
            style: .default
        ) { }
        let model = ErrorModel(title: title, message: message, primaryAction: primary, secondaryAction: nil)
        view?.showError(model)
    }
}

protocol ResetPasswordView: AnyObject, ErrorView {
    func setResetEnabled(_ isEnabled: Bool)
    func setLoading(_ isLoading: Bool)
    func showSuccess(message: String)
}

protocol ResetPasswordPresenter {
    func viewDidLoad()
    func didUpdateEmail(_ text: String)
    func didTapReset()
}

final class ResetPasswordPresenterImpl: ResetPasswordPresenter {

    weak var view: ResetPasswordView?

    private let authService: AuthService

    private var email = ""
    private var isLoading = false

    init(authService: AuthService) {
        self.authService = authService
    }

    func viewDidLoad() {
        updateResetState()
    }

    func didUpdateEmail(_ text: String) {
        email = text.trimmingCharacters(in: .whitespacesAndNewlines)
        updateResetState()
    }

    func didTapReset() {
        guard !isLoading else { return }
        guard isValidEmail(email) else {
            showError(message: NSLocalizedString("Введите корректный email", comment: "invalid email"))
            return
        }

        isLoading = true
        view?.setLoading(true)

        authService.resetPassword(email: email) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                self.view?.setLoading(false)
                switch result {
                case .success:
                    self.view?.showSuccess(
                        message: NSLocalizedString(
                            "Инструкции по восстановлению пароля высланы\nна указанный email",
                            comment: "reset password success"
                        )
                    )
                case .failure(let error):
                    self.showError(message: self.message(for: error))
                }
            }
        }
    }

    private func updateResetState() {
        view?.setResetEnabled(isValidEmail(email))
    }

    private func isValidEmail(_ text: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: text)
    }

    private func message(for error: Error) -> String {
        let nsError = error as NSError
        if let code = AuthErrorCode(rawValue: nsError.code) {
            switch code {
            case .invalidEmail:
                return NSLocalizedString("Неверный формат email", comment: "auth error")
            case .userNotFound:
                return NSLocalizedString("Пользователь не найден", comment: "auth error")
            case .networkError:
                return NSLocalizedString("Произошла ошибка сети", comment: "auth error")
            case .tooManyRequests:
                return NSLocalizedString("Слишком много попыток. Попробуйте позже", comment: "auth error")
            default:
                break
            }
        }
        return error.localizedDescription.isEmpty
        ? NSLocalizedString("Произошла неизвестная ошибка", comment: "auth error")
        : error.localizedDescription
    }

    private func showError(message: String) {
        let primary = ErrorAction(
            title: NSLocalizedString("Закрыть", comment: "close"),
            style: .default
        ) { }
        let model = ErrorModel(message: message, primaryAction: primary, secondaryAction: nil)
        view?.showError(model)
    }
}
