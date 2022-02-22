//
//  MainPresenter.swift
//  Rebound
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation

protocol LoadingView {
    func displayLoading(loadingModelView: LoadingModelView)
}
protocol ErrorView {
    func displayError(errorModelView: ErrorModelView)
}
protocol MainView {
    func display(mainModelView: MainModelView)
}

public class FeedPresenter {
    var loadingView: LoadingView
    var errorView: ErrorView
    var mainView : MainView
    init(loadingView: LoadingView, errorView: ErrorView, mainView: MainView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.mainView = mainView
    }
    public static var feedError : String {
        return NSLocalizedString("MAIN_VIEW_ERROR",
            tableName: "Rebound",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    public static var title: String {
        return NSLocalizedString("MAIN_VIEW_TITLE",
            tableName: "Rebound",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the feed view")
    }
    
    public func didStartLoading() {
        loadingView.displayLoading(loadingModelView: LoadingModelView(isLoading: true))
        errorView.displayError(errorModelView: ErrorModelView(message: nil))
    }
    public func didHaveError(error: Error) {
        loadingView.displayLoading(loadingModelView: LoadingModelView(isLoading: false))
        errorView.displayError(errorModelView: .error(message: error.localizedDescription))
    }
    public func didDisplay(items: [RBUser], lastOpened: Date) {
        loadingView.displayLoading(loadingModelView: LoadingModelView(isLoading: false))
        mainView.display(mainModelView: MainModelView(users: items, lastOpened: lastOpened))
    }
}
