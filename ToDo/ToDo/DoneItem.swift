//
//  DoneItem.swift
//  ToDo
//
//  Created by hpc on 2020/1/20.
//  Copyright © 2020 hpc. All rights reserved.
//

import Foundation
import UserNotifications
class DoneItem:NSObject{
    var name:String = ""
    var leftTime:Int = 0
    var colorString:String = ""
    var TimeOut:Bool = false
    var TimeText:String = ""
    init(name:String) {
        self.name=name
        self.TimeText = "倒计时"
        self.leftTime = 5
        super.init()
    }
    init(name:String,LeftTime:Int){
        self.name = name
        self.leftTime = LeftTime
        super.init()
    }
    init(name:String,TimeText:String) {
        self.name=name
        self.TimeText=TimeText
        super.init()
    }
    func countDown(){
        leftTime = leftTime - 1
    }
}
