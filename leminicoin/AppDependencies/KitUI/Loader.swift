//
//  Loader.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import UIKit

final class Loader {
    
    fileprivate let restorationIdentifier = "LoaderRestorationIdentifier"
    
    init() {}
    
    func show(){
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        containerView.restorationIdentifier = restorationIdentifier
        
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.startAnimating()
        
        containerView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        keyWindow.addSubview(containerView)
        
        containerView.anchor(top: keyWindow.topAnchor, left: keyWindow.leftAnchor, right: keyWindow.rightAnchor, bottom: keyWindow.bottomAnchor)
    }
    
    func hide() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }

        for item in keyWindow.subviews
            where item.restorationIdentifier == restorationIdentifier {
                item.removeFromSuperview()
        }
    }
}
