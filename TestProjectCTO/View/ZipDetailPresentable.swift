//
//  ZipDetailPresentable.swift
//  TestProjectCTO
//
//  Created by MacMini on 12.05.2022.
//

import Foundation
import UIKit


protocol ZipDetailPresentable {
    func presentResponse(_ zipResponse : ZipCodeResponse)
}


extension ZipDetailPresentable where Self : UIViewController {
    func presentResponse(_ zipResponse : ZipCodeResponse) {
        let alert = UIAlertController(title: zipResponse.postCode, message: zipResponse.places.first?.placeName ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
