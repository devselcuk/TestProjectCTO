//
//  APIClient.swift
//  TestProjectCTO
//
//  Created by MacMini on 11.05.2022.
//

import Foundation

enum CustomError : Error {
    case invalidURL
    case serverError(String)
    case emptyZip
}

struct APIClient {
    
    
    static func execute<T : NetworkTask>(task : T) async throws -> T.Response {
        guard let urlRequest = task.urlRequest else { throw CustomError.invalidURL}
        if task.endpoint.isEmpty { throw CustomError.emptyZip}
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let response = (response as? HTTPURLResponse), response.statusCode != 200 {
            throw CustomError.serverError(response.description)
        }
        
        let responseModel = try JSONDecoder().decode(T.Response.self, from: data)
        
        return responseModel
    }
    
}
