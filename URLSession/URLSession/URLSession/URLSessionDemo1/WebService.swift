//
//  WebService.swift
//  URLSession
//
//  Created by 김동경 on 9/30/24.
//

import Foundation

final class WebService {
    
    static func getUsersData() async throws -> [UserModel] {
        let urlString = "https://api.github.com/users"
        
        guard let url = URL(string: urlString) else {
            throw ErrorCases.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ErrorCases.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([UserModel].self, from: data)
        } catch {
            throw ErrorCases.invalidData
        }
    }
}


enum ErrorCases: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .invalidResponse:
            "Invalid Response"
        case .invalidData:
            "Invalid Data"
        }
    }
}
