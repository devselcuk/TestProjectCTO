//
//  HistoryViewModel.swift
//  TestProjectCTO
//
//  Created by MacMini on 12.05.2022.
//

import Foundation


class HistoryViewModel : ObservableObject {
    
    @ZipCodeMemoryWrapper var recentSearches : [ZipCodeResponse]
    
    @Published var filteredSearches : [ZipCodeResponse] = []
    
    init() {
        
        self.filteredSearches = recentSearches
    }
    
    func filterHistory(with text : String) {
        filteredSearches =  text.isEmpty ? recentSearches : recentSearches.filter({ $0.postCode.contains(text)})
      
    }
    
    
}
