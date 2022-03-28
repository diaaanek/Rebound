//
//  WkNavigationDelegate.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/27/22.
//

import Foundation
import WebKit



public class RemoveHeadersWkNavigationDelegate:NSObject, WKNavigationDelegate{
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.querySelectorAll('nav')[0].remove();document.querySelectorAll('header')[0].remove();", completionHandler: { [weak self] (value: Any!, error: Error!) -> Void in
           
        })
    }

}
public class GetStatusWkNavigationDelegate:NSObject, WKNavigationDelegate{
    var completion: (Bool, Data)->()
    
    public init(completion: @escaping (Bool, Data)->()) {
        self.completion = completion
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML", completionHandler: { [weak self] (value: Any!, error: Error!) -> Void in
            if error != nil {
                return
            }
            guard let self = self else {
                return
            }
            if let result = value as? String {
                var pageData = result.data(using: .utf8)!
                if result.contains("Sorry") {
                    self.completion(false,pageData)
                }
                else {
                    self.completion(true,pageData)
                }
            }
        })
    }

}
