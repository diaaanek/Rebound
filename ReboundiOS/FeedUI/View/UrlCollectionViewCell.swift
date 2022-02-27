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
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }

}
