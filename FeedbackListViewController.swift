//
//  FeedbackListViewController.swift
//
//  Created by Владислав Костромин on 28.05.2021.
//  
//

import UIKit

// MARK: Protocol: FeedbackListPresenterToViewProtocol (Presenter -> View)
protocol FeedbackListPresenterToViewProtocol: AnyObject {
    func popViewController()
    func upadeTable(list: [FeedbackListModel])
    func upadeCollection(list: [FeedbackListSection])
    func showErrorView(withTextError textError: String)
}

// MARK: Protocol: FeedbackListRouterToViewProtocol (Router -> View)
protocol FeedbackListRouterToViewProtocol: AnyObject {
    func presentView(view: UIViewController)
    func pushView(view: UIViewController)
    func showAlert(_ text: String)
}

class FeedbackListViewController: UIViewController {
    
    // MARK: - Enum for UITableViewDiffableDataSource
    enum SectionTable: CaseIterable {
        case section
    }

    enum SectionCollection: CaseIterable {
        case section
    }

    // MARK: - property
    var presenter: FeedbackListViewToPresenterProtocol!
    
    private lazy var collection: UICollectionView = {
        let collection = UICollectionView()
        return collection
    }()
    
    private var navigationView: CustomNavigationView = {
        
        let navigationView = CustomNavigationView()
        navigationView.title = Tx.Ticket.Navigation
        
        let leftButton = UIButton(frame: .zero)
        leftButton.setImage(UIImage(named: "back"), for: .normal)
        leftButton.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
        navigationView.leftButton = leftButton
        leftButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(4)
        }
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "create_tiket"), for: .normal)
        rightButton.addTarget(self, action: #selector(listTopicButton), for: .touchUpInside)
        navigationView.rightButton = rightButton
        rightButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(4)
        }
        return navigationView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(FeedbackListTableViewCell.self, forCellReuseIdentifier: FeedbackListTableViewCell.reuseIdentifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 82.0
        return tableView
    }()
    
    private lazy var dataSource = UITableViewDiffableDataSource<SectionTable, FeedbackListModel>(tableView: tableView) { tableView, indexPath, currentItem in
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackListTableViewCell.reuseIdentifier, for: indexPath) as? FeedbackListTableViewCell
        else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }
        
        cell.configuration(withItemModel: currentItem)
        return cell
    }
    
    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = PaletteApp.gray
        
        return view
    }()
    
    private lazy var dataSourceCollection = UICollectionViewDiffableDataSource<SectionCollection, FeedbackListSection>(collectionView: collection) {
        (collection, indexPath, item) -> FeedbackListCollectionViewCell? in
        
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: FeedbackListCollectionViewCell.reuseIdentifier, for: indexPath) as? FeedbackListCollectionViewCell else { return nil }
        cell.configure(withItemModel: item)
        return cell
    }
    
    // MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Objective-C
    @objc private func backButton(_ sender: UIButton) {
        presenter.backButton()
    }
    
    @objc private func listTopicButton(_ sender: UIButton) {
        presenter.listTopicButton()
    }
    
    // MARK: - private func
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 8)
            section.interGroupSpacing = 10
            return section
        }
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        layout.configuration = configuration
        return layout
    }
    
    private func configureHierarchy() {
        
        collection = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.keyboardDismissMode = .onDrag
        collection.register(FeedbackListCollectionViewCell.self, forCellWithReuseIdentifier: FeedbackListCollectionViewCell.reuseIdentifier)
        collection.delegate = self
        collection.dataSource = dataSourceCollection
    }
    
    private func configureUI() {
        view.backgroundColor = PaletteApp.white
        
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view)
            make.height.equalTo(58)
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
        
        tableView.register(FeedbackListTableViewCell.self, forCellReuseIdentifier: FeedbackListTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(68)
            make.left.right.equalToSuperview().inset(2)
        }
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.top.equalTo(collection.snp.bottom).offset(1)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: Extension: UICollectionViewDelegate
extension FeedbackListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.pressCellCollection(withIndexPath: indexPath)
        
        collection.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        collection.reloadData()
    }
}

// MARK: Extension: UITableViewDelegate
extension FeedbackListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Нажимаем на строку
    }
}

// MARK: Extension: FeedbackListPresenterToViewProtocol
extension FeedbackListViewController: FeedbackListPresenterToViewProtocol {
    
    func upadeTable(list: [FeedbackListModel]) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionTable, FeedbackListModel>()
        snapshot.appendSections(SectionTable.allCases)
        snapshot.appendItems(list, toSection: SectionTable.section)
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    func upadeCollection(list: [FeedbackListSection]) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionCollection, FeedbackListSection>()
        snapshot.appendSections(SectionCollection.allCases)
        snapshot.appendItems(list, toSection: SectionCollection.section)
        dataSourceCollection.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func popViewController() {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        navigationController?.popViewController(animated: true)
    }
    
    func showErrorView(withTextError textError: String) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        let errorView = ErrorView(frame: CGRect.zero)
        errorView.delegate = self
        errorView.textFirstLabel = Tx.ErrorView.somethingWrong
        errorView.textSecondLabel = textError
        contentView.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
}

// MARK: Extension: FeedbackListRouterToViewProtocol
extension FeedbackListViewController: FeedbackListRouterToViewProtocol{
    func presentView(view: UIViewController) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        present(view, animated: true, completion: nil)
    }
    
    func pushView(view: UIViewController) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        navigationController?.pushViewController(view, animated: true)
    }
    
    func showAlert(_ text: String) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        AlertManager.shared.showEasyAler(withTitle: "ЗАГЛУШКА", message: text)
    }
}

// MARK: Extension: ErrorViewProtocol
extension FeedbackListViewController: ErrorViewProtocol {
    func pressedButtonRefresh(view: UIView) {
        logger.debugMessage("\(#fileID) -> \(#function)")
        
        view.removeFromSuperview()
        presenter.viewDidLoad()
    }
}
