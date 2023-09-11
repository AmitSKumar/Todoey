//
//  Category.swift
//  Todoey
//
//  Created by user243065 on 9/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var  name : String = ""
    //forwaard realationship
    let items = List<Item>()
}
