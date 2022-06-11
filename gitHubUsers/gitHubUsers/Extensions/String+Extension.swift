//
//  String+Extension.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 14.05.2022.
//

import Foundation

extension String {
    
    /// Returns string without whitespaces and newlines, returns nil if it is emty
    func nonBlankOrNil() -> String? {
        let newString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if newString.isEmpty {
            return nil
        }
        return newString
    }
}
