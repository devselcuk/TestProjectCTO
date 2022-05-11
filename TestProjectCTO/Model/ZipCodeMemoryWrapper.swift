//
//  ZipCodeMemoryWrapper.swift
//  TestProjectCTO
//
//  Created by MacMini on 12.05.2022.
//

import Foundation



@propertyWrapper
struct ZipCodeMemoryWrapper {
    
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("zips").appendingPathExtension("plist")
    let decoder = PropertyListDecoder()
    let encoder = PropertyListEncoder()
    var wrappedValue : [ZipCodeResponse] {
        get {
            do {
                let data = try Data(contentsOf: url)
                return try decoder.decode([ZipCodeResponse].self, from: data)
            } catch {
                return []
            }
        }
        
        set {
            do {
                let data = try encoder.encode(newValue)
                try data.write(to: url)
            } catch {
                print("error while saving")
            }
        }
    }
    
}
