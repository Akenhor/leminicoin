//
//  AdListViewController.swift
//  leminicoin
//
//  Created by Pierre Semler on 14/05/2021.
//

import UIKit

final class AdListViewController: UITableViewController {
    
    var ads: [AdListModel] = []
    var categories: [CategoryModel] = []
    
    var output: AdListInteractorProtocol!
    var router: AdListRouterProtocol!
    
    fileprivate let defaultPadding: CGFloat = 10
    
    fileprivate lazy var filterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = L10n.AdList.Filter.title
        
        let clearButton = UIButton()
        clearButton.setTitle(L10n.AdList.Filter.Reset.Button.title, for: .normal)
        clearButton.setTitleColor(AppColor.primaryColor.color, for: .normal)
        clearButton.addTarget(self, action: #selector(clearFilter), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(clearButton)
        view.addSubview(filterCollectionView)
        
        label.anchor(top: view.topAnchor, left: view.leftAnchor, right: clearButton.leftAnchor, bottom: nil, paddingTop: defaultPadding, paddingLeft: defaultPadding, paddingRight: defaultPadding)
        clearButton.anchor(top: view.topAnchor, left: nil, right: view.rightAnchor, bottom: nil, paddingRight: defaultPadding)
        filterCollectionView.anchor(top: label.bottomAnchor, left: label.leftAnchor, right: clearButton.rightAnchor, bottom: view.bottomAnchor, paddingTop: defaultPadding, paddingBottom: defaultPadding)
        
        return view
    }()
    
    fileprivate lazy var filterCollectionView: UICollectionView = {
        
        let flow = UICollectionViewFlowLayout()
        flow.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flow.scrollDirection = .vertical
        flow.sectionInset = UIEdgeInsets(top: defaultPadding, left: 0, bottom: defaultPadding, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 0), collectionViewLayout: flow)
        collectionView.isUserInteractionEnabled = true
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    fileprivate lazy var pullRefresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: L10n.PullToRefresh.message)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    fileprivate lazy var searchBarController: UISearchController = {
        let searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.searchResultsUpdater = self
        definesPresentationContext = true
        
        if #available(iOS 13.0, *) {
            searchBarController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: L10n.AdList.SearchBar.placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        } else {
            searchBarController.searchBar.placeholder = L10n.AdList.SearchBar.placeholder
            searchBarController.searchBar.tintColor = .white
            let cancelButtonAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            cancelButtonAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        }
        searchBarController.obscuresBackgroundDuringPresentation = false
        return searchBarController
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        AdListConfigurator.configure(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.register(AdCell.self, forCellReuseIdentifier: AdCell.reuseIdentifier)
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.refreshControl = pullRefresh
        self.navigationItem.title = L10n.AdList.NavigationItem.title
        self.navigationItem.searchController = searchBarController
        self.navigationItem.hidesSearchBarWhenScrolling = false

        output.loadCategoriesAndAds()
        KitUI.showLoader()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdCell.reuseIdentifier, for: indexPath) as! AdCell
        let ad = ads[indexPath.item]
            
        cell.category = ad.category.name
        cell.name = ad.title
        cell.price = ad.price
        cell.isUrgentImage = ad.isUrgentImage
        
        cell.smallImage = nil
        
        let representedId = ad.id
        cell.representedIdentifier = ad.id

        output.downloadSmallImage(for: ad.smallImageUrl, forCell: cell, id: representedId)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ad = ads[indexPath.row]
        self.output.getDto(for: ad.id, categoryId: ad.category.id)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return filterView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    @objc private func refreshData() {
        KitUI.showLoader()
        clearFilter()
        output.loadCategoriesAndAds()
    }
    
    @objc private func clearFilter() {
        output.clearFilter()
    }
}

extension AdListViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        let category = categories[indexPath.row]
        cell.category = category
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        self.output.select(filter: category.id)
    }
}

extension AdListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        output.search(for: searchController.searchBar.text)
    }
}

extension AdListViewController: AdListViewControllerProtocol {
    
    func display(smallImage: UIImage, forCell: AdCell) {
        forCell.smallImage = smallImage
    }
    
    func display(categories: [CategoryModel], ads: [AdListModel]) {
        self.categories = categories
        self.ads = ads
        KitUI.hideLoader()
        pullRefresh.endRefreshing()
        self.tableView.reloadData()
        self.filterCollectionView.reloadData()
    }
    
    func displayDto(dto: AdDto, withCategory: String) {
        self.router.navigateToAdDetail(with: dto, withCategory: withCategory)
    }
    
    func display(error title: String, message: String?) {
        KitUI.showError(on: self, title: title, message: message, buttonTitle: L10n.Ok.title, completion: { [weak self] in
            KitUI.hideLoader()
            self?.pullRefresh.endRefreshing()
        })
    }
}
