//
//  ZipViewModel.swift
//  TestProjectCTO
//
//  Created by MacMini on 11.05.2022.
//

import Foundation



class ZipViewModel : ObservableObject {
    
    @Published var response : ZipCodeResponse?
    @Published var errorMessage : String?
    @Published var fetching = false
    
    @ZipCodeMemoryWrapper var recentSearches : [ZipCodeResponse]
    
    init() {
        
    }
    
    
    func fetchLocationInfo(from zipcode : String ) {
        self.fetching = true
        Task {
            let task = ZipCodeTask(endpoint: zipcode, request: ZipCodeRequest())
            
            Task {
                do {
                  let response =   try await APIClient.execute(task: task)
                    print(response)
                    
                    self.response = response
                    self.fetching = false
                    if !self.recentSearches.contains(response) {
                        self.recentSearches.append(response)
                    }
                    
                } catch let error {
                    self.fetching = false
                    if let customError =  error as? CustomError {
                        switch customError {
                        case .invalidURL :
                            self.errorMessage = "invalid url"
                        case .serverError(let error) :
                            print(error)
                            self.errorMessage = "Location with this zip code can not be found"
                        case .emptyZip:
                            self.errorMessage = "Zip code is empty, please type a zip code"
                        }
                    } else {
                        self.errorMessage = "Location with this zipcode not found"
                    }
                    
                    
                }
            }
        }
    }
    
    
}


