//
//  RBUrlPresenater.swift
//  Rebound
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation

public protocol RBUrlWebViewDelegate {
    func display(_ model: RBUrl)
}


class RBUrlPresenter {
   private let view: RBUrlWebViewDelegate
    init(view: RBUrlWebViewDelegate, ) {
        self.view = view
    }
    
    func didStartLoading() {
        view.display(RBUrlModelView(stateDescription: nil, html: nil, isLoading: true))
    }
    func didFinishedLoading(html: String, stateDescription: String) {
        view.display(RBUrlModelView(stateDescription: stateDescription, html: html, isLoading: false))
    }
    func didFinishedLoading(with error: Error) {
       // view.display(RBUrlModelView(stateDescription: stateDescription, html: html, isLoading: false))
    }
    
}
