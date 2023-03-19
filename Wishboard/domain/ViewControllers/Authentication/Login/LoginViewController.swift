//
//  LoginViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: TitleCenterViewController {
    let loginView = LoginView()
    private let loginViewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = Title.login

        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        
        setUpTextField()
        setUpButton()
        
        bind()
    }
    // MARK: - Set Up
    func setUpTextField() {
        loginView.emailTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditingChanged), for: .editingChanged)
        
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    func setUpButton() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        loginView.loginButtonKeyboard.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        loginView.lostPasswordButton.addTarget(self, action: #selector(lostPasswordButtonDidTap), for: .touchUpInside)
        loginView.lostPasswordButtonKeyboard.addTarget(self, action: #selector(lostPasswordButtonDidTap), for: .touchUpInside)
    }
    // MARK: - Actions
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let trimString = text.trimmingCharacters(in: .whitespaces)
        self.loginView.emailTextField.text = trimString
        loginViewModel.emailTextFieldEditingChanged(trimString)
    }
    @objc func passwordTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let trimString = text.trimmingCharacters(in: .whitespaces)
        self.loginView.passwordTextField.text = trimString
        loginViewModel.passwordTextFieldEditingChanged(trimString)
    }
    @objc func loginButtonDidTap() {
        UIDevice.vibrate()
        self.view.endEditing(true)
        let email = loginViewModel.email ?? ""
        let pw = loginViewModel.password ?? ""
        let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        let loginInput = LoginInput(email: email, password: pw, fcmToken: deviceToken)
        LoginDataManager().loginDataManager(loginInput, self)
    }
    @objc func lostPasswordButtonDidTap() {
        UIDevice.vibrate()
        let lostPwVC = LostPasswordViewController(title: "1/2 단계")
        self.navigationController?.pushViewController(lostPwVC, animated: true)
    }
    //MARK: - Methods
    private func bind() {
        loginViewModel.isValidID.bind { isValidID in
            guard let isValid = isValidID else {return}
            if isValid {
                self.loginView.loginButton.isActivate = true
                self.loginView.loginButtonKeyboard.isActivate = true
                
            } else {
                self.loginView.loginButton.isActivate = false
                self.loginView.loginButtonKeyboard.isActivate = false
            }
        }

    }
}
// MARK: - API Success
extension LoginViewController {
    func loginAPISuccess(_ result: APIModel<TokenResultModel>) {
        let accessToken = result.data?.token.accessToken
        let refreshToken = result.data?.token.refreshToken
        let tempNickname = result.data?.tempNickname
        
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
        UserDefaults.standard.set(false, forKey: "isFirstLogin")
        UserDefaults.standard.set(loginViewModel.email, forKey: "email")
        UserDefaults.standard.set(loginViewModel.password, forKey: "password")
        UserDefaults.standard.set(tempNickname, forKey: "tempNickname")
        
        // FCM
//        sendFCM()
        // go Main
        ScreenManager().goMain(self)
    }
    func loginAPIFail() {
        SnackBar(self, message: .login)
        for loginButton in [self.loginView.loginButton, self.loginView.loginButtonKeyboard] {
            loginButton.isActivate = false
        }
    }
//    // MARK: FCM API
//    func sendFCM() {
//        // Send FCM token to server
//        let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
//        print("device Token:", deviceToken)
//        let fcmInput = FCMInput(fcm_token: deviceToken)
//        FCMDataManager().fcmDataManager(fcmInput, self)
//    }
//    func fcmAPISuccess(_ result: APIModel<TokenResultModel>) {
//        print(result.message)
//    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
