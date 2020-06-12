//
//  String+Exts.swift
//  Lavoro
//
//  Created by Manish on 07/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

extension String {
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    func removePhoneFormating() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
