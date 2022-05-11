//
//  Network.swift
//  TestProjectCTO
//
//  Created by MacMini on 11.05.2022.
//

import Foundation



struct Constants {
    static let baseURLString  = "https://api.zippopotam.us/us/"
}
enum HTTPMethod : String {
    case get = "GET"
}

protocol NetworkTask {
    associatedtype Request : Codable
    associatedtype Response : Codable
    
    var endpoint : String { get set}
    var method : HTTPMethod { get set}
    
    var request : Request { get set}
}

extension NetworkTask {
    
    var urlRequest : URLRequest? {
        
        guard let url = URL(string: Constants.baseURLString + endpoint) else { return nil}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}




