//
//  TabViewController.swift
//  TestProjectCTO
//
//  Created by MacMini on 11.05.2022.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let zipViewController = ViewController()
        let historyViewController = HistoryViewController()
        
        self.viewControllers = [zipViewController, historyViewController]
       
        zipViewController.tabBarItem = UITabBarItem(title: "Zip Code", image: UIImage(systemName: "signpost.right.fill"), selectedImage: UIImage(systemName: "signpost.right.fill"))
        historyViewController.tabBarItem = UITabBarItem(title: "Recent", image: UIImage(systemName: "timer"), selectedImage: UIImage(systemName: "timer"))
        // Do any additional setup after loading the view.
    }
    

  

}
