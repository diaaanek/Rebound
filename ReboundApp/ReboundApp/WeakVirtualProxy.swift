//
//  WeakVirtualProxy.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 2/24/22.
//

import Foundation
import Rebound
class WeakVirtualProxy<T:AnyObject> {
    weak var object : T?
    init(_ ob: T) {
        self.object = ob
    }
}
extension WeakVirtualProxy: MainView where T: MainView {
    func display(mainModelView: MainModelView) {
        object?.display(mainModelView: mainModelView)
    }
}
extension WeakVirtualProxy: LoadingView where T: LoadingView {
    func displayLoading(loadingModelView: LoadingModelView) {
        object?.displayLoading(loadingModelView: loadingModelView)
    }
}

extension WeakVirtualProxy: ErrorView where T: ErrorView {
    func displayError(errorModelView: ErrorModelView) {
        object?.displayError(errorModelView: errorModelView)
    }
}
extension WeakVirtualProxy: EditView where T: EditView {
    func display(modelView: EditItemModelView) {
        object?.display(modelView: modelView)
    }
    
}



