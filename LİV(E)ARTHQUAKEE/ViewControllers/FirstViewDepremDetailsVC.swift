//
//  FirstViewDepremDetailsVC.swift
//  LİV(E)ARTHQUAKEE
//
//  Created by Mehmet Dora on 8.08.2023.
//

import UIKit
import WebKit

class FirstViewDepremDetailsVC: UIViewController {

    
    @IBOutlet weak var webview: UIWebView!
    
    let webView = WKWebView()
    var Url = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let url = URL(string: Url)!
        webview.layer.cornerRadius = 0.5
        webView.load(URLRequest(url:url))
        webview.loadRequest(URLRequest(url: url))
    }
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
