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
}
class EditAddingItemDetailViewController: UIViewController {
    var TitletoAdd:String = ""
    @IBOutlet var textField:UITextField!
    weak var delegate:AddItemDetailViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text=TitletoAdd
        // Do any additional setup after loading the view.
    }
    @IBAction func done(){
        let ItemToAdd=DoneItem(name: "")
        ItemToAdd.name = textField.text!
        delegate?.AddItemDetailerController(self,didFinishAdding: ItemToAdd)
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
