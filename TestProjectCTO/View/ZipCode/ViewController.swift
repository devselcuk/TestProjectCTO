//
//  ViewController.swift
//  TestProjectCTO
//
//  Created by MacMini on 11.05.2022.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    lazy var textField : UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type zip code here"
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 1
        let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        bar.items = [reset]
        bar.sizeToFit()
        textField.inputAccessoryView = bar
        return textField
    }()
    
    lazy var button : UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = button.configuration
        config?.title = "GET LOCATION"
        config?.imagePadding = 8
        button.configurationUpdateHandler = { [weak self] button in
            var config = button.configuration
            config?.showsActivityIndicator = self!.fetching
            
            button.configuration = config
        }
        button.addAction(UIAction(handler: { _ in
            self.viewModel.fetchLocationInfo(from: self.textField.text ?? "")
        }), for: .touchUpInside)
        
        button.configuration = config
        return button
    }()
    
    lazy var cityLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var countryLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    lazy var vStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(self.cityLabel)
        stackView.addArrangedSubview(self.countryLabel)
        
        return stackView
    }()
    
    
    let viewModel = ZipViewModel()
    
    var fetching = false
    
    var cancellables : [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
  
       
       setUpUI()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
  
    func bindViewModel() {
        viewModel.$fetching
            .receive(on: RunLoop.main)
            .sink { fetching in
            self.fetching  = fetching
            self.button.setNeedsUpdateConfiguration()
            print(fetching)
        }
        .store(in: &cancellables)
        
        viewModel.$response
            .receive(on: RunLoop.main)
            .sink { response in
                self.countryLabel.text = response?.places.first?.state ?? ""
                self.cityLabel.text = response?.places.first?.placeName ?? ""
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { errorMessage in
                guard let message = errorMessage else { return}
                self.showError(message: message)
            }
            .store(in: &cancellables)
    }
    
    func setUpUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(textField)
        view.addSubview(button)
        view.addSubview(vStackView)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            textField.heightAnchor.constraint(equalToConstant: 44),
            button.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vStackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50),
            vStackView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            vStackView.trailingAnchor.constraint(equalTo: textField.trailingAnchor)
        ])
        
    }
    
    
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

}

extension ViewController : ZipErrorPresentable {}
