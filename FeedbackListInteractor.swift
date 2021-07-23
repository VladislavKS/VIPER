//
//  FeedbackListInteractor.swift
//  DNS-SHOP
//
//  Created by Владислав Костромин on 28.05.2021.
//  
//

import Foundation

// MARK: Protocol: TicketPresenterToInteractorProtocol (Presenter -> Interactor)
protocol FeedbackListPresenterToInteractorProtocol: AnyObject {
    var listMenu: [FeedbackListSection] { get }
    func formingMenuTicket()
    func formingCollectionHead()
}

class FeedbackListInteractor {

    // MARK: Properties
    weak var presenter: FeedbackListInteractorToPresenterProtocol!
    var apiManager: FeedbackToApiProtocol!
    private var headTitles: [FeedbackListSection]!
    
    private func fetchSettings() {
        apiManager.fetchFeedbackSettings { [self] (response) in
            switch response {
            case .success(let settings):
                GlobalData.feedbackSettings = settings
                formingCollectionHead()
            case .failure(let error): presenter.didEndFetchSettings(withError: error)
            }
        }
    }
}

// MARK: Extension: FeedbackListPresenterToInteractorProtocol
extension FeedbackListInteractor: FeedbackListPresenterToInteractorProtocol {
    var listMenu: [FeedbackListSection] {
        return headTitles
    }
    
    func formingCollectionHead() {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        if GlobalData.feedbackSettings == nil {
            fetchSettings()
        } else {
            headTitles = []
            guard let array = GlobalData.feedbackSettings?.ticketGroups else { return }
            array.forEach { (key, value) in
                self.headTitles.append(FeedbackListSection(title: value, idTitle: key, isSelected: false))
            }

            headTitles.first?.isSelected = true
            presenter.formingCollectionHead(listStatus: headTitles)
        }
    }

    func formingMenuTicket() {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        let itemJob = FeedbackListModel(status: .processing, name: "Обращение № 01468894 от 26.03.2021")
        let itemRejected = FeedbackListModel(status: .closed, name: "Обращение № 03464287 от 12.08.2020")
        let itemDecided = FeedbackListModel(status: .restarted, name: "Обращение № 01255412 от 06.04.2020")
        let items = [itemJob, itemRejected, itemDecided]
        
        presenter.formingMenuTicket(menuListTicket: items)
    }
}
