//
//  AdDetailViewController.swift
//  leminicoin
//
//  Created by Pierre Semler on 16/05/2021.
//

import UIKit

final class AdDetailViewController: UIViewController {
    
    var output: AdDetailInteractorProtocol!
    private let defaultPadding: CGFloat = 10
    
    var ad: AdDetailModel? {
        didSet{
            self.navigationItem.title = ad?.categoryName
            urgentImageView.image = ad?.isUrgentImage
            nameLabel.text = ad?.title
            descriptionLabel.text = ad?.description
            priceLabel.text = ad?.price
            dateLabel.text = ad?.creationDate
        }
    }
    
    var thumbImage: UIImage? {
        didSet{
            spinner.stopAnimating()
            thumbImageView.image = thumbImage
        }
    }
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        
        return scrollView
    }()
    
    fileprivate lazy var contentView: UIScrollView = {
        let contentView = UIView()
        
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, width: self.view.bounds.width)
        
        return scrollView
    }()
    
    fileprivate lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        thumbImageView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: thumbImageView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: thumbImageView.centerYAnchor).isActive = true
        
        return spinner
    }()
    
    fileprivate lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        contentView.insertSubview(imageView, belowSubview: urgentImageView)
        imageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, bottom: nil, height: 300)
        
        return imageView
    }()
    
    fileprivate lazy var urgentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(imageView)
        imageView.anchor(top: contentView.topAnchor, left: nil, right: contentView.rightAnchor, bottom: nil, width: 50, height: 50)
        
        return imageView
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        
        contentView.addSubview(label)
        label.anchor(top: thumbImageView.bottomAnchor, left: thumbImageView.leftAnchor, right: nil, bottom: nil, paddingTop: defaultPadding, paddingLeft: defaultPadding, width: view.bounds.width / 2)
        
        return label
    }()
    
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        
        contentView.addSubview(label)
        label.anchor(top: nameLabel.topAnchor, left: nameLabel.rightAnchor, right: thumbImageView.rightAnchor, bottom: nameLabel.bottomAnchor, paddingLeft: defaultPadding, paddingRight: defaultPadding)
        return label
    }()
    
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        
        contentView.addSubview(label)
        label.anchor(top: nameLabel.bottomAnchor, left: nameLabel.leftAnchor, right: nil, bottom: nil, paddingTop: defaultPadding, width: nameLabel.bounds.width)
        
        return label
    }()
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        
        contentView.addSubview(label)
        label.anchor(top: dateLabel.bottomAnchor, left: nameLabel.leftAnchor, right: priceLabel.rightAnchor, bottom: contentView.bottomAnchor, paddingTop: defaultPadding)
        
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        output.loadDetail()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        AdDetailConfigurator.configure(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AdDetailViewController: AdDetailViewControllerProtocol {
    func display(ad: AdDetailModel) {
        self.ad = ad
    }
    
    func display(thumbImage: UIImage) {
        self.thumbImage = thumbImage
    }
}
