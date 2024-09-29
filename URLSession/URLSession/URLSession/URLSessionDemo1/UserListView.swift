//
//  UserListView.swift
//  URLSession
//
//  Created by 김동경 on 9/30/24.
//

import SwiftUI

struct UserListView: View {
    
    @StateObject private var viewModel: UserListViewModel = .init()
    
    var body: some View {
        NavigationStack {
            List(viewModel.users, id:\.id) { user in
                UserItemView(user: user)
            }
            .navigationTitle("Github Users")
        }
        .task {
            await viewModel.getUsers()
        }
    }
}

struct UserItemView: View {
    let user: UserModel
    
    var body: some View {
        HStack {
            AsyncImage(url: user.avaterImage) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 12))
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(user.login)
                    .font(.headline)
                
                Text(user.url)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    UserListView()
}
