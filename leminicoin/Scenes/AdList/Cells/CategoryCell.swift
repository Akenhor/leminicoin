//
//  CategoryCell.swift
//  leminicoin
//
//  Created by Pierre Semler on 16/05/2021.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "\(CategoryCell.self)"
    fileprivate let defaultPadding: CGFloat = 10
    
    var category: CategoryModel? {
        didSet{
            
            contentView.backgroundColor = category?.backgroundColor
            categoryLabel.text = category?.name
            categoryLabel.textColor = category?.titleColor
        }
    }
    
    fileprivate lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        
        
        contentView.addSubview(label)
        label.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, bottom: contentView.bottomAnchor, paddingTop: defaultPadding, paddingLeft: defaultPadding, paddingRight: defaultPadding, paddingBottom: defaultPadding)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = AppColor.primaryColor.color.cgColor
        contentView.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
