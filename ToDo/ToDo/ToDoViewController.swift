//
//  ViewController.swift
//  ToDo
//
//  Created by hpc on 2020/1/19.
//  Copyright © 2020 hpc. All rights reserved.
//

import UIKit


class TodoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AddItemDetailViewControllerDelegate,TimeCountDownDelegate{
    
    
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var AddTitle: UITextField!
    @IBOutlet weak var FirstTableView: UITableView!
    var ItemtoEdit:DoneItem?
    var doneItems:Dictionary<Int,[DoneItem]> = [
        0:[],1:[]]
    let doneitem1 = DoneItem(name: "未完成1",LeftTime: 5)
    let doneitem2 = DoneItem(name: "未完成2",LeftTime: 3)
    let undoneitem1=DoneItem(name:"已完成1",LeftTime: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstTableView.delegate=self
        FirstTableView.dataSource=self
        AddButton.isEnabled=false
        doneItems[0]?.append(doneitem1)
        doneItems[0]?.append(doneitem2)
        doneItems[1]?.append(undoneitem1)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TodoViewController.timerEvent), userInfo: nil, repeats:true)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneItems[section]!.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 0 else {
            return "已完成"
        }
        return "未完成"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView=UIView()
        footerView.backgroundColor=UIColor.white
        return footerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewCell(style: .default, reuseIdentifier: "cell")
        let cellItem=doneItems[indexPath.section]![indexPath.row]
        cell.setValueForCell(item: cellItem)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        doneItems[indexPath.section]?.remove(at: indexPath.row)
        let indexPaths=[indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ItemtoEdit = doneItems[indexPath.section]![indexPath.row]
        performSegue(withIdentifier: "EditItem", sender: nil)
        FirstTableView.deselectRow(at: indexPath, animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range,in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        AddButton.isEnabled = !newText.isEmpty
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !textField.text!.isEmpty else {
            return true
        }
        clickAddButton()
        textField.resignFirstResponder()
        return true
    }
    @IBAction func clickAddButton(){
        performSegue(withIdentifier: "AddItem", sender:nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            let controller = segue.destination as!EditAddingItemDetailViewController
            controller.delegate=self
            controller.TitletoAdd = AddTitle.text!
            AddTitle.text=""
            AddButton.isEnabled=false
        }
        else if segue.identifier=="EditItem"{
            let controller = segue.destination as! EditAddingItemDetailViewController
            controller.delegate = self
            controller.ItemtoEdit = ItemtoEdit
        }
    }
    
    func AddItemDetailerViewControllerDidCancel(_ controller: EditAddingItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    func AddItemDetailerController(_ controller: EditAddingItemDetailViewController, didFinishAdding ItemtoEdit: DoneItem) {
        let newRowIndex = doneItems[0]!.count
        doneItems[0]?.append(ItemtoEdit)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        FirstTableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    func AddItemDetailerController(_ controller: EditAddingItemDetailViewController, didFinishEditing item: DoneItem) {
        if let index = doneItems[0]!.firstIndex(of:item){
            let indexPath = IndexPath(row:index,section: 0)
            let cell = FirstTableView.cellForRow(at: indexPath) as! TableViewCell
            cell.setValueForCell(item: item)
        }
        else if let index = doneItems[1]!.firstIndex(of:item){
            let indexPath = IndexPath(row: index, section: 1)
            let cell = FirstTableView.cellForRow(at: indexPath) as! TableViewCell
            cell.setValueForCell(item:item)
        }
        navigationController?.popViewController(animated: true)
    }
    func MoveItem(_ CountDownFinishCell: TableViewCell, CountEndItem: DoneItem) {
        print("1")
        let Alert = UIAlertController(title: "Done", message: "\(CountEndItem.name) 倒计时已结束", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.addAction(okAction)
        Alert.addAction(cancelAction)
        present(Alert,animated: false,completion: nil)
    }
    
    var timer:Timer!
    @objc func timerEvent(){
        for item in doneItems[0]! {
            if !item.TimeOut{
                item.countDown()
                if let index = doneItems[0]!.firstIndex(of:item){
                    let indexPath = IndexPath(row:index,section: 0)
                    let cell = FirstTableView.cellForRow(at: indexPath) as! TableViewCell
                    cell.setValueForCell(item: item)
                }
                if item.leftTime <= 0{
                    item.TimeOut = true
                    let alert = UIAlertController(title: "Done", message: "\(item.name)倒计时已结束", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)}
            }
        }
    }
}
