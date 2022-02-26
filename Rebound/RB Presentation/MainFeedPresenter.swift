//
//  MainPresenter.swift
//  Rebound
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation

public protocol LoadingView {
    func displayLoading(loadingModelView: LoadingModelView)
}
public protocol ErrorView {
    func displayError(errorModelView: ErrorModelView)
}
public protocol MainView {
    func display(mainModelView: MainModelView)
}

public class MainFeedPresenter {
    var loadingView: LoadingView
    var errorView: ErrorView
    var mainView : MainView
   public init(loadingView: LoadingView, errorView: ErrorView, mainView: MainView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.mainView = mainView
    }
    public static var feedError : String {
        return NSLocalizedString("MAIN_VIEW_ERROR",
            tableName: "Rebound",
            bundle: Bundle(for: MainFeedPresenter.self),
            comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    public static var title: String {
        return NSLocalizedString("MAIN_VIEW_TITLE",
            tableName: "Rebound",
            bundle: Bundle(for: MainFeedPresenter.self),
            comment: "Title for the feed view")
    }
    
    public static var updatesSectionTitle: String {
        return NSLocalizedString("MAIN_VIEW_SECTIONHEADER1",
            tableName: "Rebound",
            bundle: Bundle(for: MainFeedPresenter.self),
            comment: "Section Title for the feed view")
    }
    public static var noSectionTitle: String {
        return NSLocalizedString("MAIN_VIEW_SECTIONHEADER2",
            tableName: "Rebound",
            bundle: Bundle(for: MainFeedPresenter.self),
            comment: "Section Title for the feed view")
    }
    
    
    public func didStartLoading() {
        loadingView.displayLoading(loadingModelView: LoadingModelView(isLoading: true))
        errorView.displayError(errorModelView: ErrorModelView(message: nil))
    }
    public func didFinishLoading(error: Error) {
        loadingView.displayLoading(loadingModelView: LoadingModelView(isLoading: false))
        errorView.displayError(errorModelView: .error(message: error.localizedDescription))
    }
    public func didDisplay(rbUser: [RBUser]) {
        loadingView.displayLoading(loadingModelView: LoadingModelView(isLoading: false))
        mainView.display(mainModelView: MainModelView(rbUser: rbUser))
    }
}
