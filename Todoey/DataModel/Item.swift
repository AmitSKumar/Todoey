//
//  Item.swift
//  Todoey
//
//  Created by user243065 on 9/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic  var title : String = ""
    @objc dynamic var done : Bool = false
    // inverse relationship
    var parentvategory = LinkingObjects(fromType: Category.self, property: "items")
}
