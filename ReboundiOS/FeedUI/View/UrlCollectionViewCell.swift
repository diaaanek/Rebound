//
//  UrlCollectionViewCell.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 2/26/22.
//

import UIKit
import WebKit

class UrlCollectionViewCell: UICollectionViewCell, WKNavigationDelegate {
    
    @IBOutlet weak var bottomCenterLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    override func layoutSubviews() {
        webView.navigationDelegate = self
        webView.contentScaleFactor = 2.0
        webView.isUserInteractionEnabled = false
        webView.clipsToBounds = true
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation){
        self.perform(#selector(f), with: nil, afterDelay: 0.5)
        if !webView.isLoading {
        }
        
      
    }
    @objc func f () {
        
        webView.scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0, y: 300), size: CGSize(width: 10, height: 10)), animated: true)

    }

}
