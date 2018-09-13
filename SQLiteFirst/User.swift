//
//  User.swift
//  SQLiteFirst
//
//  Created by Sujin Shrestha on 9/13/18.
//  Copyright © 2018 Sujin Shrestha. All rights reserved.
//

import Foundation

class User {
    var id: Int
    var name: String
    var address: String
    
    init(id: Int, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }
}
