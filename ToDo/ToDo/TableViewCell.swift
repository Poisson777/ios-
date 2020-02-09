//
//  TableViewCell.swift
//  ToDo
//
//  Created by hpc on 2020/2/3.
//  Copyright © 2020 hpc. All rights reserved.
//

import UIKit
protocol TimeCountDownDelegate:class{
    func MoveItem(_ CountDownFinishCell:TableViewCell,CountEndItem:DoneItem)
}
class TableViewCell: UITableViewCell{
    var nameLabel:UILabel?
    var circleView:UIView!
    var timeLabel:UILabel?
    var leftTime = 0
    weak var delegate:TimeCountDownDelegate!
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
    func setValueForCell(item:DoneItem){
        nameLabel!.text=item.name
        leftTime = item.leftTime
        timeLabel!.text="倒计时：\(leftTime/60) min \(leftTime%60) second 后提醒"
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
}
