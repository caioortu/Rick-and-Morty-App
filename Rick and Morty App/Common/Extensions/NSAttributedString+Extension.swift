//
//  NSAttributedString+Extension.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/16/20.
//

import UIKit

extension NSAttributedString {
    /// Highlights the ranges where a string occourence happen.
    ///
    /// - Parameters:
    ///   - text: the text that should be highlighted
    ///   - completeString: the string where the text can be contained
    ///   - highlightAttributes: the attributes that should be highlighted
    ///   - defaultAttributes: the default attributes of the not highlighted part of the string
    ///   - ignoringUppercase: it'll search ignoring the case differentiation
    /// - Returns: an NSAttributedString with the highlights
    class func highlightOccurrence(of text: String,
                                   in completeString: String,
                                   highlightAttributes: [NSAttributedString.Key : Any],
                                   defaultAttributes: [NSAttributedString.Key : Any]? = nil,
                                   ignoringUppercase: Bool = true) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: completeString, attributes: defaultAttributes)
        
        let textRangesInCompleteString: [NSRange]
        if ignoringUppercase {
            textRangesInCompleteString = (completeString.uppercased() as NSString).ranges(of: text.uppercased())
        } else {
            textRangesInCompleteString = (completeString as NSString).ranges(of: text)
        }
        
        attributedString.setAttributes(highlightAttributes, ranges: textRangesInCompleteString)
        
        return attributedString
    }
}

extension NSMutableAttributedString {
    /// Set the attributes in multiple ranges of the AttributedString
    ///
    /// - Parameters:
    ///   - attrs: the attributes that should be set in the ranges
    ///   - ranges: the ranges where the attributes will be set
    open func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, ranges: [NSRange]) {
        ranges.forEach { (range) in
            setAttributes(attrs, range: range)
        }
    }
}

extension NSString {
    /// Ranges where an occourence of a string happen
    ///
    /// - Parameter searchString: the string that should be found
    /// - Returns: an array of the ranges where the search string is found
    open func ranges(of searchString: String) -> [NSRange] {
        var ranges = [NSRange]()
        var searchRange = NSRange()
        var range: NSRange = self.range(of: searchString)
        while range.location != NSNotFound {
            ranges.append(range)
            searchRange = NSRange(location: NSMaxRange(range), length: self.length - NSMaxRange(range))
            range = self.range(of: searchString, options: [], range: searchRange)
        }
        return ranges
    }
}
