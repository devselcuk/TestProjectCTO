//
//  ZipCodeTask.swift
//  TestProjectCTO
//
//  Created by MacMini on 11.05.2022.
//

import Foundation


struct ZipCodeTask : NetworkTask {
   
    
    typealias Request = ZipCodeRequest
    
    typealias Response = ZipCodeResponse
    
    var endpoint: String
    
    var method: HTTPMethod = .get
    
    var request: Request
    
    
}
