//
//  User.swift
//  LoadDataDemo
//
//  Created by nicaho on 2024/5/2.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    
    var friends: [Friend]
}
