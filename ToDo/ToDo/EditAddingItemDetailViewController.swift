//
//  EditAddingItemViewController.swift
//  ToDo
//
//  Created by hpc on 2020/1/22.
//  Copyright © 2020 hpc. All rights reserved.
//

import UIKit
protocol AddItemDetailViewControllerDelegate:class {
    func AddItemDetailerViewControllerDidCancel(_ controller:EditAddingItemDetailViewController)
    func AddItemDetailerController(_ controller:EditAddingItemDetailViewController,didFinishAdding item:Item)
    func AddItemDetailerController(_ controller:EditAddingItemDetailViewController,didFinishEditing item:Item)
}
class EditAddingItemDetailViewController: UIViewController {
    var ItemtoEdit:Item?
    var TitletoAdd:String?
    var CircleColor:String?
    var colortoAdd:String = "white"
    @IBOutlet var datePicker:UIDatePicker!
    @IBOutlet var textField:UITextField!
    @IBOutlet var chooseView:UIView!
    @IBOutlet weak var Donebutton: UIBarButtonItem!
    
    weak var delegate:AddItemDetailViewControllerDelegate!
    
    let FirstView = UIView(frame: CGRect(x: 20, y: 10, width: 20, height: 20))
    let SecondView = UIView(frame: CGRect(x: 60, y: 10, width: 20, height: 20))
    let ThirdView = UIView(frame: CGRect(x: 100, y: 10, width: 20, height: 20))
    let ForthView = UIView(frame: CGRect(x: 140, y: 10, width: 20, height: 20))
    let FifthView = UIView(frame: CGRect(x: 180, y: 10, width: 20, height: 20))
    var addCircleView = UIView(frame: CGRect(x: 220, y: 5, width: 30, height: 30))
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = ItemtoEdit{
            textField.text=item.name
            colortoAdd = item.colorString
        }
        else {
            textField.text = TitletoAdd
            Donebutton.isEnabled=false
        }
        textField.font = UIFont.systemFont(ofSize: 18)
        creatChooseView()
        // Do any additional setup after loading the view.
    }
    func creatChooseView(){
        FirstView.layer.cornerRadius = 10
        SecondView.layer.cornerRadius = 10
        ThirdView.layer.cornerRadius = 10
        ForthView.layer.cornerRadius = 10
        FifthView.layer.cornerRadius = 10
        addCircleView.layer.cornerRadius = 15
        FirstView.clipsToBounds=true
        SecondView.clipsToBounds=true
        ThirdView.clipsToBounds = true
        ForthView.clipsToBounds = true
        FifthView.clipsToBounds = true
        addCircleView.clipsToBounds = true
        addCircleView.layer.borderWidth=1.5
        FirstView.backgroundColor = UIColor.systemBlue
        SecondView.backgroundColor = UIColor.systemGreen
        ThirdView.backgroundColor = UIColor.systemRed
        ForthView.backgroundColor = UIColor.systemOrange
        FifthView.backgroundColor = UIColor.systemYellow
        FirstView.tag = 101
        SecondView.tag = 102
        ThirdView.tag = 103
        ForthView.tag = 104
        FifthView.tag = 105
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(addCircle(sender:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(addCircle(sender:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(addCircle(sender:)))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(addCircle(sender:)))
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(addCircle(sender:)))
        FirstView.addGestureRecognizer(tap1)
        SecondView.addGestureRecognizer(tap2)
        ThirdView.addGestureRecognizer(tap3)
        ForthView.addGestureRecognizer(tap4)
        FifthView.addGestureRecognizer(tap5)
        chooseView.addSubview(FirstView)
        chooseView.addSubview(SecondView)
        chooseView.addSubview(ThirdView)
        chooseView.addSubview(ForthView)
        chooseView.addSubview(FifthView)
    }
    @objc func addCircle(sender:UITapGestureRecognizer){
        let x = (sender.view!.tag - 100)*40 - 25
        addCircleView.layer.borderColor = sender.view?.backgroundColor?.cgColor
        addCircleView.frame=CGRect(x: x, y: 5, width: 30, height: 30)
        chooseView.addSubview(addCircleView)
        switch sender.view?.tag {
        case 101:do {
            Donebutton.isEnabled = true
            colortoAdd = "blue"
            }
        case 102:do {
            Donebutton.isEnabled = true
            colortoAdd = "green"
            }
        case 103:do {
            Donebutton.isEnabled = true
            colortoAdd = "red"
            }
        case 104:do{
            colortoAdd = "orange"
            Donebutton.isEnabled = true
            }
        case 105:do{
            colortoAdd = "yellow"
            Donebutton.isEnabled = true
            }
        default:do{
            colortoAdd = "white"
            }
        }
        print("click \(colortoAdd)")
    }
    @IBAction func done(){
        if let item = ItemtoEdit {
            ItemtoEdit?.removeNotification()
            item.name=textField.text!
            item.colorString = colortoAdd
            let leftTime = Int(datePicker.countDownDuration)
            item.leftTime = leftTime
            item.TimeInterval = datePicker.countDownDuration
            if item.leftTime > 0 {item.TimeOut = false}
            delegate?.AddItemDetailerController(self, didFinishEditing: item)
        }
        else {
            let item = Item(name: textField.text!)
            let leftTime = Int(datePicker.countDownDuration)
            item.colorString = colortoAdd
            item.leftTime = leftTime
            item.TimeInterval = datePicker.countDownDuration
            delegate?.AddItemDetailerController(self, didFinishAdding: item)
        }
    }
    @IBAction func cancel(){
        delegate?.AddItemDetailerViewControllerDidCancel(self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
