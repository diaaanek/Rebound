//
//  WkNavigationDelegateComposite.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/27/22.
//

import Foundation
import WebKit
class WkNavigationDelegateComposite:NSObject, WKNavigationDelegate {
    var list = [WKNavigationDelegate]()
    init(list: [WKNavigationDelegate]) {
        self.list = list
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.list.forEach { delegate in
            delegate.webView?(webView, didFinish: navigation)
        }
    }
}
