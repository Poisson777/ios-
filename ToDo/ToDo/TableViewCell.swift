//
//  TableViewCell.swift
//  ToDo
//
//  Created by hpc on 2020/2/3.
//  Copyright © 2020 hpc. All rights reserved.
//

import UIKit
class TableViewCell: UITableViewCell {
    var nameLabel:UILabel?
    var circleLabel:UILabel?
    var timeLabel:UILabel?
    var timer:Timer!
    var leftTime:Int=0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        creatCell()
        startClick()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func creatCell(){
        circleLabel = UILabel.init(frame: CGRect(x: 15, y: 0, width: 50, height: 50))
        nameLabel = UILabel.init(frame: CGRect(x: 35, y: 0, width: 500, height:50))
        timeLabel = UILabel.init(frame: CGRect(x: 35, y:30, width: 500, height: 30))
        circleLabel!.font = UIFont.systemFont(ofSize: 13)
        nameLabel!.font=UIFont.systemFont(ofSize: 18)
        timeLabel!.font=UIFont.systemFont(ofSize: 15)
        self.addSubview(circleLabel!)
        self.addSubview(nameLabel!)
        self.addSubview(timeLabel!)
    }
    func setValueForCell(item:DoneItem){
        circleLabel!.text=item.circleView
        nameLabel!.text=item.name
        leftTime = item.leftTime
        timeLabel!.text="倒计时：\(leftTime/60) min 后提醒"
    }
    @objc func startClick(){
        timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TableViewCell.tickDown), userInfo: nil, repeats: true)
    }
    @objc func tickDown(){
        timeLabel!.text = "倒计时：\(leftTime/60) min 后提醒"
        leftTime-=1
        if leftTime < 1 {
            timer.invalidate()
            timeLabel!.text = "已完成"
        }
        else if leftTime <= 60 {
            timeLabel!.text = "倒计时：\(leftTime) seconds 后提醒"
        }
    }
}
