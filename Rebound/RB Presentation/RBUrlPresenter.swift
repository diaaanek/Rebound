//
//  RBUrlPresenater.swift
//  Rebound
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation

protocol RBUrlWebViewDelegate {
    func display(_ model: RBUrlModelView)
}


class RBUrlPresenter {
   private let view: RBUrlWebViewDelegate
    public init(view: RBUrlWebViewDelegate) {
        self.view = view
    }
    
  public func didStartLoading() {
        view.display(RBUrlModelView(stateDescription: nil, html: nil, isLoading: true))
    }
    public func didFinishedLoading(html: String, stateDescription: String) {
        view.display(RBUrlModelView(stateDescription: stateDescription, html: html, isLoading: false))
    }
    public func didFinishedLoading(with error: Error) {
       // view.display(RBUrlModelView(stateDescription: stateDescription, html: html, isLoading: false))
    }
    
}
