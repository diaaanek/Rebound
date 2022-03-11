//
//  WkWebViewController.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/8/22.
//

import Foundation
import UIKit
import WebKit

class WkWebViewController: UIViewController, WKNavigationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       let wkWebview = WKWebView(frame: view.frame)
        view.addSubview(wkWebview)
     //   wkWebview.navigationDelegate = self
     //   wkWebview.load(URLRequest(url: URL(string:"https://instagram.com/itsethankeiser")!))
        
    }
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation){


        webView.evaluateJavaScript("document.querySelector('.NXc7H jLuN9  ').remove();", completionHandler: { (response, error) -> Void in

        })

    }


}
