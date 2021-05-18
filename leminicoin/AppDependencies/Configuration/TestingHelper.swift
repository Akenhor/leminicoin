//
//  TestingHelper.swift
//  leminicoin
//
//  Created by Pierre Semler on 18/05/2021.
//

import Foundation

public enum TestMode: String {
    case uitest
    case unitest
}

public class TestingHelper {
    
    public static var mode: TestMode? {
        let argument = ProcessInfo.processInfo.arguments
        if argument.contains(TestMode.uitest.rawValue) {
            return .uitest
        } else if argument.contains(TestMode.unitest.rawValue) {
            return .unitest
        } else {
            return nil
        }
    }
    
    public static var isTesting: Bool { mode != nil }
}
