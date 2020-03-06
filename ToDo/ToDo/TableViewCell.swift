//
//  TableViewCell.swift
//  ToDo
//
//  Created by hpc on 2020/2/3.
//  Copyright © 2020 hpc. All rights reserved.
//

import UIKit
class TableViewCell: UITableViewCell{
    var nameLabel:UILabel?
    var circleView:UIView!
    var timeLabel:UILabel?
    var leftTime = 0
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        creatCell()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func creatCell(){
        nameLabel = UILabel.init(frame: CGRect(x: 35, y: 0, width: 500, height:50))
        timeLabel = UILabel.init(frame: CGRect(x: 35, y:30, width: 500, height: 30))
        nameLabel!.font=UIFont.systemFont(ofSize: 18)
        timeLabel!.font=UIFont.systemFont(ofSize: 15)
        circleView = UIView.init(frame: CGRect(x: 10, y: 15, width: 18, height: 18))
        circleView.layer.cornerRadius = 9
        circleView.clipsToBounds = true
        self.addSubview(circleView)
        self.addSubview(nameLabel!)
        self.addSubview(timeLabel!)
    }
    func setValueForCell(item:Item){
        nameLabel!.text=item.name
        leftTime = item.leftTime
        if item.leftTime > 0 {
            timeLabel!.text = "倒计时：\(leftTime/60) min \(leftTime%60) s 后提醒"
        }
        else {
            timeLabel?.text = "已完成"
        }
        switch item.colorString{
        case "blue" :
            circleView.backgroundColor = UIColor.systemBlue
        case "green":
            circleView.backgroundColor = UIColor.systemGreen
        case "orange":
            circleView.backgroundColor = UIColor.systemOrange
        case "red":
            circleView.backgroundColor = UIColor.systemRed
        case "yellow":
            circleView.backgroundColor = UIColor.systemYellow
        default :
            circleView.backgroundColor = UIColor.white
        }
    }
    func refreshTime(item:Item){
        self.leftTime = item.leftTime
        if item.leftTime > 0 && item.leftTime<3600 {
            timeLabel!.text = "倒计时：\(leftTime/60) min \(leftTime%60) s 后提醒"
        }
        else if item.leftTime >= 3600{
            timeLabel!.text = "倒计时：\(leftTime/3600) hour \(leftTime%3600/60) min \(leftTime%60) s 后提醒"
        }
        else {
            timeLabel?.text = "已完成"
        }
    }
}
