//
//  ZipCodeResponse.swift
//  TestProjectCTO
//
//  Created by MacMini on 11.05.2022.
//

import Foundation


struct ZipCodeResponse : Codable, Hashable {
    let postCode, country, countryAbbreviation : String
    let places : [Place]
    
    enum CodingKeys: String, CodingKey {
        case postCode = "post code"
        case country = "country"
        case countryAbbreviation = "country abbreviation"
        case places = "places"
    }
}

struct Place : Codable, Hashable {
    let placeName, longitude, state, stateAbbreviation, latitude : String
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place name"
        case longitude = "longitude"
        case state = "state"
        case stateAbbreviation = "state abbreviation"
        case latitude = "latitude"
    }
}
