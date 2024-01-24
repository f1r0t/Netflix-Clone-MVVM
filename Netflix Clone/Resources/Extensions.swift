//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Fırat AKBULUT on 10.11.2023.
//

import Foundation

extension String{
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
