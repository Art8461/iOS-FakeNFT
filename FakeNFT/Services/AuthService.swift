//
//  BasketService.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 27.01.2026.
//

import FirebaseAuth

typealias AuthCompletion = (Result<Void, Error>) -> Void

protocol AuthService {
    var isAuthorized: Bool { get }
    func signIn(email: String, password: String, completion: @escaping AuthCompletion)
    func signUp(email: String, password: String, completion: @escaping AuthCompletion)
    func resetPassword(email: String, completion: @escaping AuthCompletion)
    func signOut() throws
}

final class AuthServiceImpl: AuthService {
    var isAuthorized: Bool {
        Auth.auth().currentUser != nil
    }

    func signIn(email: String, password: String, completion: @escaping AuthCompletion) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping AuthCompletion) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func resetPassword(email: String, completion: @escaping AuthCompletion) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
