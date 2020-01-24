//
//  DoneItem.swift
//  ToDo
//
//  Created by hpc on 2020/1/20.
//  Copyright © 2020 hpc. All rights reserved.
//

import Foundation
class DoneItem:NSObject{
    var name:String = ""
    var circleView:String = "⭕️"
    init(name:String) {
        self.name=name
        super.init()
    }
}
