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
    var leftTime:Int=0
    var TimeText:String = ""
    init(name:String) {
        self.name=name
        self.TimeText = "倒计时"
        self.leftTime = 61
        super.init()
    }
    init(name:String,LeftTime:Int){
        self.name = name
        self.leftTime = LeftTime
    }
    init(name:String,circleView:String,TimeText:String) {
        self.name=name
        self.circleView=circleView
        self.TimeText=TimeText
        super.init()
    }
}
