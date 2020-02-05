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
    func AddItemDetailerController(_ controller:EditAddingItemDetailViewController,didFinishAdding item:DoneItem)
    func AddItemDetailerController(_ controller:EditAddingItemDetailViewController,didFinishEditing item:DoneItem)
}
class EditAddingItemDetailViewController: UIViewController {
    var ItemtoEdit:DoneItem?
    var TitletoAdd:String?
    
    @IBOutlet var datePicker:UIDatePicker!
    @IBOutlet var textField:UITextField!
    
    weak var delegate:AddItemDetailViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = ItemtoEdit{
            textField.text=item.name
        }
        else {
            textField.text = TitletoAdd
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func done(){
        if let item = ItemtoEdit {
            item.name=textField.text!
            let leftTime = Int(datePicker.countDownDuration)
            item.leftTime = leftTime
            item.TimeText = "倒计时：\(leftTime/60)min 后提醒"
            delegate?.AddItemDetailerController(self, didFinishEditing: item)
        }
        else {
            let item = DoneItem(name: textField.text!)
            let leftTime = Int(datePicker.countDownDuration)
            item.leftTime=leftTime
            item.TimeText = "倒计时：\(leftTime/60)min 后提醒"
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
