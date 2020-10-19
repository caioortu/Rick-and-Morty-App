//
//  NSAttributedStringTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/19/20.
//

import XCTest
import UIKit
@testable import Rick_and_Morty_App

class NSAttributedStringTests: XCTestCase {
    
    func testHighlightOccurrenceOfText() {
        // Given
        let sut = "highlight default highlight"
        let highlightedText = "highlight"
        let highlightAttributes: [NSAttributedString.Key : UIColor] = [.foregroundColor: .blue]
        let defaultAttributes: [NSAttributedString.Key : UIColor] = [.foregroundColor: .black]
        
        var firstRange = NSRange(location: 0, length: 9)
        var defaultRange = NSRange(location: 9, length: 9)
        var lastRange = NSRange(location: 18, length: 9)
        
        // When
        let attributedString = NSAttributedString.highlightOccurrence(of: highlightedText,
                                                                      in: sut,
                                                                      highlightAttributes: highlightAttributes,
                                                                      defaultAttributes: defaultAttributes,
                                                                      ignoringUppercase: true)
        let firstAttributes = attributedString.attributes(at: firstRange.location, effectiveRange: &firstRange)
        let midleAttributes = attributedString.attributes(at: defaultRange.location, effectiveRange: &defaultRange)
        let lastAttributes = attributedString.attributes(at: lastRange.location, effectiveRange: &lastRange)
        
        // Then
        for (key, value) in highlightAttributes {
            XCTAssertEqual(value, firstAttributes[key] as! UIColor)
            XCTAssertEqual(value, lastAttributes[key] as! UIColor)
        }
        
        for (key, value) in defaultAttributes {
            XCTAssertEqual(value, midleAttributes[key] as! UIColor)
        }
    }
    
    func testSetAttributesInRanges() {
        // Given
        let sut = NSMutableAttributedString(string: "Test of ranges")
        let attributes: [NSAttributedString.Key : UIColor] = [.foregroundColor: .blue,
                                                              .backgroundColor: .red]
        var firstRange = NSRange(location: 0, length: 4)
        var lastRange = NSRange(location: 8, length: 6)
        var anotherRange = NSRange(location: 4, length: 4)
        
        // When
        sut.setAttributes(attributes, ranges: [firstRange, lastRange])
        let firstAttributes = sut.attributes(at: firstRange.location, effectiveRange: &firstRange)
        let lastAttributes = sut.attributes(at: lastRange.location, effectiveRange: &lastRange)
        let attributesForAnotherRange = sut.attributes(at: anotherRange.location, effectiveRange: &anotherRange)
        
        // Then
        for (key, value) in attributes {
            XCTAssertEqual(value, firstAttributes[key] as! UIColor)
            XCTAssertEqual(value, lastAttributes[key] as! UIColor)
        }
        
        XCTAssertTrue(attributesForAnotherRange.isEmpty)
    }

    func testRangesOfSearchString() {
        // Given
        let sut = "test of test"
        let searchString = "test"
        let expectedRanges: [NSRange] = [NSRange(location: 0, length: 4),
                                         NSRange(location: 8, length: 4)]
        
        // When
        let ranges = sut.ranges(of: searchString)
        let emptyRanges = sut.ranges(of: "")
        
        // Then
        XCTAssertEqual(ranges.count, 2)
        XCTAssertEqual(ranges, expectedRanges)
        XCTAssertEqual(emptyRanges, [])
    }

}
