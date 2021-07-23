//
//  FeedbackListRouter.swift
//  DNS-SHOP
//
//  Created by Владислав Костромин on 28.05.2021.
//  
//

import Foundation

// MARK: Protocol: FeedbackListPresenterToRouterProtocol (Presenter -> Router)
protocol FeedbackListPresenterToRouterProtocol: AnyObject {
    func navigateTolistTopic()
}

class FeedbackListRouter {

    // MARK: Properties
    weak var view: FeedbackListRouterToViewProtocol!
}

// MARK: Extension: FeedbackListPresenterToRouterProtocol
extension FeedbackListRouter: FeedbackListPresenterToRouterProtocol {
    func navigateTolistTopic() {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        let listTopicViewController = FeedbackListTopicsConfigurator().configure()
        view?.pushView(view: listTopicViewController)
        
    }
    
}
