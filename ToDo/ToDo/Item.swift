//
//  DoneItem.swift
//  ToDo
//
//  Created by hpc on 2020/1/20.
//  Copyright © 2020 hpc. All rights reserved.
//

import Foundation
import UserNotifications
class Item:NSObject,Codable,NSCoding{
    var name:String = ""
    var leftTime:Int = 1
    var colorString:String = ""
    var TimeOut:Bool = false
    var TimeInterval:TimeInterval = 0
    init(name:String) {
        self.name=name
        self.leftTime = 5
        super.init()
    }
    required init(coder decoder:NSCoder){
        self.name = decoder.decodeObject(forKey: "Name") as! String
        self.leftTime = decoder.decodeInteger(forKey: "LeftTime")
        self.TimeOut = decoder.decodeBool(forKey: "TimeOut")
        self.colorString = decoder.decodeObject(forKey: "ColorString") as! String
    }
    func encode(with coder: NSCoder) {
        coder.encode(name,forKey: "Name")
        coder.encode(leftTime,forKey: "LeftTime")
        coder.encode(colorString,forKey: "ColorString")
        coder.encode(TimeOut,forKey: "TimtOut")
    }
    init(name:String,LeftTime:Int){
        self.name = name
        self.leftTime = LeftTime
        super.init()
    }
    func countDown(){
        leftTime = leftTime - 1
    }
    func scheduleNotification(){
        if !TimeOut {
            let content = UNMutableNotificationContent()
            content.title = "ToDo Reminder:"
            content.body = "\(name) 倒计时已结束"
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: "\(name)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    func removeNotification (){
        if !TimeOut{
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: ["\(name)"])
        }
    }
}
