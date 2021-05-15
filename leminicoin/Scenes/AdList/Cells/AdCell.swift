//
//  AdCell.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import UIKit

final class AdCell: UITableViewCell {
    
    static let reuseIdentifier: String = "\(AdCell.self)"
    
    var smallImage: UIImage? {
        didSet {
             if let _ = smallImage {
                spinner.stopAnimating()
             } else {
                spinner.startAnimating()
             }
            smallImageView.image = smallImage
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var category: String? {
        didSet {
            categoryLabel.text = category
        }
    }
    
    var price: String? {
        didSet {
            priceLabel.text = price
        }
    }
    
    var isUrgent: Bool? {
        didSet {
            urgentImageView.image = isUrgent ?? false ? #imageLiteral(resourceName: "AdIsUrgent") : nil
        }
    }
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        smallImageView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: smallImageView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: smallImageView.centerYAnchor).isActive = true
        
        return spinner
    }()
    
    fileprivate lazy var smallImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(imageView)
        imageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: nil, bottom: contentView.bottomAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, width: contentView.bounds.width/4)
        return imageView
    }()
    
    fileprivate lazy var urgentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(imageView)
        imageView.anchor(top: contentView.topAnchor, left: nil, right: contentView.rightAnchor, bottom: nil, width: 30, height: 30)
        
        return imageView
    }()
    
    fileprivate lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        
        contentView.addSubview(label)
        label.anchor(top: contentView.topAnchor, left: smallImageView.rightAnchor, right: urgentImageView.leftAnchor, bottom: nil, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        return label
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .left
        
        contentView.addSubview(label)
        label.anchor(top: categoryLabel.bottomAnchor, left: categoryLabel.leftAnchor, right: nil, bottom: contentView.bottomAnchor, paddingTop: 10, paddingBottom: 10, width: 2 * contentView.bounds.width / 3)
        
        return label
    }()
    
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        
        contentView.addSubview(label)
        label.anchor(top: nameLabel.topAnchor, left: nameLabel.rightAnchor, right: contentView.rightAnchor, bottom: nameLabel.bottomAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, paddingBottom: 10)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let _ = spinner
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
