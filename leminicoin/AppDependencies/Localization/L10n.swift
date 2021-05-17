//
//  L10n.swift
//  leminicoin
//
//  Created by Pierre Semler on 17/05/2021.
//

import Foundation

public enum L10n {
    
    public enum Ok {
        
        public static let title = L10n.getLocalizedString(table: "Localizable", key: "ok.title")
    }
    
    public enum AdList {
        
        public enum NavigationItem {
            
            public static let title = L10n.getLocalizedString(table: "Localizable", key: "adList.navigationItem.title")
        }
        
        public enum Filter {
            
            public enum Reset {
                
                public enum Button {
                    
                    public static let title = L10n.getLocalizedString(table: "Localizable", key: "adList.filter.reset.button.title")
                }
            }
            
            public static let title = L10n.getLocalizedString(table: "Localizable", key: "adList.filter.title")
        }
        
        public enum SearchBar {
            public static let placeholder = L10n.getLocalizedString(table: "Localizable", key: "adList.searchBar.placeholder")
        }
    }
    
    public enum Error {
        public enum Generic {
            public static let title = L10n.getLocalizedString(table: "Localizable", key: "error.generic.title")
        }
        
        public enum DataTask {
            public static let message = L10n.getLocalizedString(table: "Localizable", key: "error.dataTask.message")
        }
        
        public enum BadResponse {
            public static let message = L10n.getLocalizedString(table: "Localizable", key: "error.badResponse.message")
        }
        
        public enum NoData {
            public static let message = L10n.getLocalizedString(table: "Localizable", key: "error.noData.message")
        }
    }
    
    public enum PullToRefresh {
        public static let message = L10n.getLocalizedString(table: "Localizable", key: "pullToRefresh.message")
    }

}

extension L10n {
    private static func getLocalizedString(table: String, key: String, args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle.main, comment: "")
        let str = args.count > 0 ? String(format: format, locale: .current, args) : format
        return (key != str) ? str : "N/A"
    }
}
