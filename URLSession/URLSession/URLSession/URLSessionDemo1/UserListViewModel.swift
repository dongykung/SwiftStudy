//
//  UserListViewModel.swift
//  URLSession
//
//  Created by 김동경 on 9/30/24.
//

import Foundation

final class UserListViewModel: ObservableObject {
    
    @Published var users: [UserModel] = []
    
    
    func getUsers() async {
        do {
            let users = try await WebService.getUsersData()
            self.users = users
            print(users)
        } catch {
            print(error.localizedDescription)
        }
    }
}
