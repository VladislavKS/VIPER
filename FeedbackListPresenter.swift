//
//  FeedbackListPresenter.swift
//  DNS-SHOP
//
//  Created by Владислав Костромин on 28.05.2021.
//  
//

import UIKit
import Foundation

// MARK: Protocol: FeedbackListViewToPresenterProtocol (View -> Presenter)
protocol FeedbackListViewToPresenterProtocol: AnyObject {
    func backButton()
    func listTopicButton()
    func pressCellCollection(withIndexPath indexPath: IndexPath)
    func viewDidLoad()
}

// MARK: Protocol: FeedbackListInteractorToPresenterProtocol (Interactor -> Presenter)
protocol FeedbackListInteractorToPresenterProtocol: AnyObject {
    func formingMenuTicket(menuListTicket: [FeedbackListModel])
    func formingCollectionHead(listStatus: [FeedbackListSection])
    func didEndFetchSettings(withError error: ApiError)
}

private var menuArray = [FeedbackListModel]()

class FeedbackListPresenter {
    
    // MARK: Properties
    var router: FeedbackListPresenterToRouterProtocol!
    var interactor: FeedbackListPresenterToInteractorProtocol!
    weak var view: FeedbackListPresenterToViewProtocol!
}

// MARK: Extension: FeedbackListViewToPresenterProtocol
extension FeedbackListPresenter: FeedbackListViewToPresenterProtocol {
    func pressCellCollection(withIndexPath indexPath: IndexPath) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        let array = interactor.listMenu
        array.forEach { (item) in
            item.isSelected = false
        }
        array[indexPath.row].isSelected = true
    }
    
    func backButton() {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        view.popViewController()
    }
    
    func listTopicButton() {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        router.navigateTolistTopic()
    }
    
    func TicketCellTableView(_ indexPath: IndexPath) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
    }
    
    func viewDidLoad() {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        interactor.formingMenuTicket()
        interactor.formingCollectionHead()
    }
}


// MARK: Extension: FeedbackListInteractorToPresenterProtocol
extension FeedbackListPresenter: FeedbackListInteractorToPresenterProtocol {
    func formingCollectionHead(listStatus: [FeedbackListSection]) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        view.upadeCollection(list: listStatus)
    }
    
    func formingMenuTicket(menuListTicket: [FeedbackListModel]) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        view.upadeTable(list: menuListTicket)
    }
    
    func didEndFetchSettings(withError error: ApiError) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        view.showErrorView(withTextError: Tx.ErrorView.checkConnection)
    }
}
