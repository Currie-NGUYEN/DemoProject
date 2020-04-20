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
    let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBar.target = self.revealViewController()
        menuBar.action = #selector(SWRevealViewController.revealToggle(_:))
        self.revealViewController()?.rearViewRevealWidth = 350
        
        navigationController?.navigationBar.barTintColor = .systemIndigo
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "About"
        
        webView.delegate = self
        
        let url = URL(string: "https://www.themoviedb.org/")
        let myRequest = URLRequest(url: url!)
        webView.loadRequest(myRequest)
        
        activityView.color = .black
        activityView.frame = CGRect(x: view.frame.midX - 100/2 , y: view.frame.midY - 100/2, width: 100, height: 100)
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        view.addSubview(activityView)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityView.stopAnimating()
    }
}
