//
//  ToDoModel.swift
//  Todoey
//
//  Created by Ravi Inder Manshahia on 14/05/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

class Item {
    let title : String
    var done: Bool
    
    init(title: String, done: Bool = false) {
        self.title = title
        self.done = done
    }
}
