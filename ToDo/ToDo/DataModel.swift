//
//  Data.swift
//  ToDo
//
//  Created by hpc on 2020/2/12.
//  Copyright © 2020 hpc. All rights reserved.
//

import Foundation
class DataModel :NSObject{
    
    static var supportsSecureCoding: Bool{return true}
    var items:Dictionary<Int,[Item]> = [0:[],1:[]]
    var toItem:Item = Item(name: "Example")
    let userDefault = UserDefaults.standard
    func getItem(section:Int,row:Int) -> Item{
        return items[section]![row]
    }
    override init() {
        super.init()
    }
    func saveData(){
        userDefault.removeObject(forKey: "UndoneItems")
        userDefault.removeObject(forKey: "DoneItems")
        if items[0]!.count > 0 {
            let dataArray :NSMutableArray = []
            for item in items[0]! {
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: item,requiringSecureCoding: false)
                    dataArray.add(data)
                    print("UnDoneDataSaveSuccess")
                }catch {print("UndoneItemDataSaveError")}
            }
            let array:NSArray = NSArray (object: dataArray)
            userDefault.set(array, forKey: "UndoneItems")
        }
        if items[1]!.count > 0 {
            let dataArray :NSMutableArray = []
            for item in items[1]! {
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: false)
                    dataArray.add(data)
                    print("DoneDataSaveSuccess")
                }catch {print("doneItemDataSaveError")}
            }
            let array:NSArray = NSArray (object: dataArray)
            userDefault.set(array, forKey: "DoneItems")
        }
}
    func loadData(){
        let array = userDefault.object(forKey: "UndoneItems")
        let donearray = userDefault.object(forKey: "DoneItems")
        if array != nil{
            for arr in (array as! NSArray){
                for data in arr as! NSArray{
                    do{
                        let item = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data) as! Item
                        items[0]?.append(item)
                    }catch{print("UndoneItemLoadError")}
                }
            }
        }
        if donearray != nil{
            for arr in (donearray as! NSArray){
                for data in arr as! NSArray{
                    do{
                        let item = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data) as! Item
                        items[1]?.append(item)
                    }catch{print("DoneItemLoadError")}
                }
            }
        }
    }
    
}
