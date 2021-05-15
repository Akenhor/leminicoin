//
//  AdListViewController.swift
//  leminicoin
//
//  Created by Pierre Semler on 14/05/2021.
//

import UIKit

final class AdListViewController: UITableViewController {
    
    var ads: [AdModel] = []
    var categories: [CategoryModel] = []
    
    var output: AdListInteractorProtocol!
    
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
        self.navigationItem.title = "Recherchez une annonce"
        
        output.loadCategoriesAndAds()
        KitUI.showLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        cell.smallImage = nil
        
        cell.category = ad.category.name
        cell.name = ad.title
        cell.price = ad.price
        cell.isUrgent = ad.isUrgent

        output.downloadSmallImage(for: ad.smallImageUrl, forCell: cell)
        
        return cell
    }
}

extension AdListViewController: AdListViewControllerProtocol {
    
    func display(smallImage: UIImage, forCell: AdCell) {
        forCell.smallImage = smallImage
    }
    
    func display(categories: [CategoryModel], ads: [AdModel]) {
        self.categories = categories
        self.ads = ads
        KitUI.hideLoader()
        self.tableView.reloadData()
    }
}
