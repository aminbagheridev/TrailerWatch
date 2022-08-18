//
//  CapitalizeFirstLetter.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-20.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
