//
//  NSObject+Extension.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/16/20.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
    
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
