//
//  AuthViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 26.01.2026.
//

import UIKit

final class AuthViewController: UIViewController {
    private let presenter: AuthPresenter
    private let hidesNavigationBar: Bool

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(resource: .blackApp)
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailField: UITextField = makeTextField(
        placeholder: NSLocalizedString("Email", comment: "email placeholder"),
        keyboardType: .emailAddress,
        isSecure: false
    )

    private lazy var passwordField: UITextField = makeTextField(
        placeholder: NSLocalizedString("Пароль", comment: "password placeholder"),
        keyboardType: .default,
        isSecure: true
    )

    private lazy var confirmPasswordField: UITextField = makeTextField(
        placeholder: NSLocalizedString("Повторите пароль", comment: "confirm password placeholder"),
        keyboardType: .default,
        isSecure: true
    )

    private lazy var signUpEmailErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(resource: .redUniversal)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.alpha = 0
        return label
    }()

    private lazy var signUpEmailErrorContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 34).isActive = true
        view.addSubview(signUpEmailErrorLabel)
        NSLayoutConstraint.activate([
            signUpEmailErrorLabel.topAnchor.constraint(equalTo: view.topAnchor),
            signUpEmailErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpEmailErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpEmailErrorLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return view
    }()

    private lazy var credentialsErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(resource: .redUniversal)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.alpha = 0
        return label
    }()

    private lazy var credentialsErrorContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 34).isActive = true
        view.addSubview(credentialsErrorLabel)
        NSLayoutConstraint.activate([
            credentialsErrorLabel.topAnchor.constraint(equalTo: view.topAnchor),
            credentialsErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            credentialsErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            credentialsErrorLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return view
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(resource: .blackApp)
        button.setTitleColor(UIColor(resource: .whiteApp), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        return button
    }()

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Забыли пароль?", comment: "forgot password"), for: .normal)
        button.setTitleColor(UIColor(resource: .blackApp), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        button.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Зарегистрироваться", comment: "sign up button"), for: .normal)
        button.setTitleColor(UIColor(resource: .blackApp), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(didTapShowSignUp), for: .touchUpInside)
        return button
    }()

    private lazy var fieldsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            emailField,
            passwordField,
            credentialsErrorContainer,
            confirmPasswordField,
            signUpEmailErrorContainer
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setCustomSpacing(16, after: passwordField)
        return stack
    }()

    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            actionButton,
            forgotPasswordButton
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    init(presenter: AuthPresenter, hidesNavigationBar: Bool) {
        self.presenter = presenter
        self.hidesNavigationBar = hidesNavigationBar
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupTextFields()
        setupLayout()
        setupKeyboardDismiss()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(hidesNavigationBar, animated: animated)
    }

    private func setupTextFields() {
        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(confirmPasswordChanged), for: .editingChanged)

        emailField.returnKeyType = .next
        passwordField.returnKeyType = .next
        confirmPasswordField.returnKeyType = .done

        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(fieldsStack)
        view.addSubview(buttonStack)
        
        view.addSubview(activityIndicator)
        view.addSubview(registerButton)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 132),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            fieldsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            fieldsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            fieldsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            buttonStack.topAnchor.constraint(equalTo: fieldsStack.bottomAnchor, constant: 84),
            buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            registerButton.topAnchor.constraint(greaterThanOrEqualTo: buttonStack.bottomAnchor, constant: 24),
            registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func makeTextField(
        placeholder: String,
        keyboardType: UIKeyboardType,
        isSecure: Bool
    ) -> UITextField {
        let field = InsetClearButtonTextField()
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        field.leftView = padding
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = placeholder
        field.keyboardType = keyboardType
        field.isSecureTextEntry = isSecure
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.clearButtonMode = .whileEditing
        field.borderStyle = .none
        field.layer.cornerRadius = 12
        field.layer.masksToBounds = true
        field.layer.borderWidth = 0
        field.backgroundColor = UIColor(resource: .lightGreyApp)
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return field
    }

    @objc private func didTapAction() {
        presenter.didTapAction()
    }

    @objc private func didTapForgotPassword() {
        presenter.didTapForgotPassword()
    }

    @objc private func didTapShowSignUp() {
        presenter.didTapShowSignUp()
    }

    @objc private func emailChanged() {
        presenter.didUpdateEmail(emailField.text ?? "")
    }

    @objc private func passwordChanged() {
        presenter.didUpdatePassword(passwordField.text ?? "")
    }

    @objc private func confirmPasswordChanged() {
        presenter.didUpdateConfirmPassword(confirmPasswordField.text ?? "")
    }

    @objc private func endEditing() {
        view.endEditing(true)
    }
}

private final class InsetClearButtonTextField: UITextField {
    private static let rightInset: CGFloat = 8

    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.x -= Self.rightInset
        return rect
    }
}

extension AuthViewController: AuthView {
    func display(mode: AuthModeViewModel) {
        titleLabel.text = mode.title
        actionButton.setTitle(mode.actionTitle, for: .normal)
        confirmPasswordField.isHidden = !mode.isConfirmVisible
        credentialsErrorContainer.isHidden = mode.isConfirmVisible
        signUpEmailErrorContainer.isHidden = !mode.isConfirmVisible
        forgotPasswordButton.isHidden = mode.isConfirmVisible
        registerButton.isHidden = mode.isConfirmVisible
        passwordField.returnKeyType = mode.isConfirmVisible ? .next : .done
        if !mode.isConfirmVisible {
            confirmPasswordField.text = ""
        }
    }

    func setActionEnabled(_ isEnabled: Bool) {
        actionButton.isEnabled = isEnabled
        actionButton.alpha = isEnabled ? 1.0 : 0.5
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        view.isUserInteractionEnabled = !isLoading
    }

    func showCredentialsError(message: String) {
        credentialsErrorLabel.text = message
        credentialsErrorLabel.alpha = 1
        setFieldsErrorVisible(true)
    }

    func hideCredentialsError() {
        credentialsErrorLabel.text = nil
        credentialsErrorLabel.alpha = 0
        setFieldsErrorVisible(false)
    }

    func showSignUpEmailError(message: String) {
        signUpEmailErrorLabel.text = message
        signUpEmailErrorLabel.alpha = 1
    }

    func hideSignUpEmailError() {
        signUpEmailErrorLabel.text = nil
        signUpEmailErrorLabel.alpha = 0
    }
}

private extension AuthViewController {
    func setFieldsErrorVisible(_ isVisible: Bool) {
        let color = UIColor(resource: .redUniversal).cgColor
        let width: CGFloat = isVisible ? 1 : 0
        [emailField, passwordField].forEach { field in
            field.layer.borderWidth = width
            field.layer.borderColor = isVisible ? color : UIColor.clear.cgColor
        }
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailField {
            passwordField.becomeFirstResponder()
        } else if textField === passwordField, !confirmPasswordField.isHidden {
            confirmPasswordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

final class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    private let presenter: ResetPasswordPresenter
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = NSLocalizedString("Сброс пароля" , comment: "basket is empty state")
        label.numberOfLines = 0
        label.textColor = UIColor(resource: .blackApp)
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailField: UITextField = makeTextField(
        placeholder: NSLocalizedString("Email", comment: "email placeholder"),
        keyboardType: .emailAddress,
        isSecure: false
    )

    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(resource: .blackApp)
        button.setTitle(
            NSLocalizedString("Сбросить пароль", comment: "reset password button"),
            for: .normal
        )
        button.setTitleColor(UIColor(resource: .whiteApp), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
        return button
    }()

    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(resource: .greenUniversal)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.isHidden = true
        return label
    }()
    
    init(presenter: ResetPasswordPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTextField()
        setupLayout()
        setupKeyboardDismiss()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(resetButton)
        view.addSubview(successLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 132),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            emailField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emailField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            resetButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 36),
            resetButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            resetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            successLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 18),
            successLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            successLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }

    private func setupTextField() {
        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
    }

    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func makeTextField(
        placeholder: String,
        keyboardType: UIKeyboardType,
        isSecure: Bool
    ) -> UITextField {
        let field = UITextField()
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        field.leftView = padding
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = placeholder
        field.keyboardType = keyboardType
        field.isSecureTextEntry = isSecure
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.clearButtonMode = .whileEditing
        field.borderStyle = .none
        field.layer.cornerRadius = 12
        field.layer.masksToBounds = true
        field.backgroundColor = UIColor(resource: .lightGreyApp)
        field.heightAnchor.constraint(equalToConstant: 46).isActive = true
        field.returnKeyType = .done
        field.delegate = self
        return field
    }

    @objc private func endEditing() {
        view.endEditing(true)
    }
    
    @objc private func emailChanged() {
        presenter.didUpdateEmail(emailField.text ?? "")
    }

    @objc private func didTapReset() {
        presenter.didTapReset()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ResetPasswordViewController: ResetPasswordView {
    func setResetEnabled(_ isEnabled: Bool) {
        resetButton.isEnabled = isEnabled
        resetButton.alpha = isEnabled ? 1.0 : 0.5
    }

    func setLoading(_ isLoading: Bool) {
        view.isUserInteractionEnabled = !isLoading
    }

    func showSuccess(message: String) {
        resetButton.isHidden = true
        successLabel.text = message
        successLabel.isHidden = false
    }
}
