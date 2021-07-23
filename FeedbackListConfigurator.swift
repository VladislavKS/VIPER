//
//  FeedbackListConfigurator.swift
//  Created by Владислав Костромин on 28.05.2021.
//  
//

import UIKit

class FeedbackListConfigurator {
    func configure() -> UIViewController {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        let view = FeedbackListViewController()
        let presenter = FeedbackListPresenter()
        let router = FeedbackListRouter()
        let interactor = FeedbackListInteractor()
        
        view.presenter = presenter
        
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = view
        
        interactor.presenter = presenter
        interactor.apiManager = ApiManager()
        
        router.view = view
        
        return view
    }
}
