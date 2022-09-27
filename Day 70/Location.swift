//
//  Location.swift
//  Day 70
//
//  Created by Guntars Reiss on 27/09/2022.
//

import Foundation

struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}
