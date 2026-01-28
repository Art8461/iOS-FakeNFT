//
//  UsersService.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 28.01.2026.
//

typealias UsersCompletion = (Result<[User], Error>) -> Void

protocol UsersService {
    func loadUsers(page: Int, completion: @escaping UsersCompletion)
}

final class UsersServiceImpl: UsersService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadUsers(page: Int, completion: @escaping UsersCompletion) {
        networkClient.send(
            request: UsersRequest(page: page),
            type: [User].self,
            onResponse: completion
        )
    }
}
