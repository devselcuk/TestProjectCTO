//
//  ErrorPresentable.swift
//  TestProjectCTO
//
//  Created by MacMini on 11.05.2022.
//

import Foundation
import UIKit


protocol ZipErrorPresentable {
    func showError(message : String)
}


extension ZipErrorPresentable where Self : UIViewController {
    func showError(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
