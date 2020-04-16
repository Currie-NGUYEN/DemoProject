//
//  AboutController.swift
//  demo1
//
//  Created by Currie on 4/14/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import SWRevealViewController

class AboutController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var menuBar: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuBar.target = self.revealViewController()
        menuBar.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.revealViewController()?.rearViewRevealWidth = 350
        
        navigationController?.navigationBar.barTintColor = .systemIndigo
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "About"
        
        webView.delegate = self
        
        let url = URL(string: "https://www.themoviedb.org/")
        let myRequest = URLRequest(url: url!)
        webView.loadRequest(myRequest)
    }

}
