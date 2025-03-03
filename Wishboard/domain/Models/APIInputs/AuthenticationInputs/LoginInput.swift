//
//  LoginInput.swift
//  Wishboard
//
//  Created by gomin on 2022/09/26.
//


struct LoginInput: Encodable {
    let email: String
    let password: String
    let fcmToken: String
}

struct ModifyPasswordInput: Encodable {
    let newPassword: String
}
