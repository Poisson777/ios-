//
//  ViewController.swift
//  ToDo
//
//  Created by hpc on 2020/1/19.
//  Copyright © 2020 hpc. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AddItemDetailViewControllerDelegate {
    var doneItems:Dictionary<Int,[DoneItem]> = [
        0:[],1:[]]
    let doneitem1 = DoneItem(name: "未完成1")
    let doneitem2 = DoneItem(name: "未完成2")
    let undoneitem1=DoneItem(name:"已完成1")
    
    @IBOutlet weak var AddButton: UIButton!
    
    @IBOutlet weak var AddTitle: UITextField!
    
    @IBOutlet weak var FirstTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstTableView.delegate=self
        FirstTableView.dataSource=self
        AddButton.isEnabled=false
        doneItems[0]?.append(doneitem1)
        doneItems[0]?.append(doneitem2)
        doneItems[1]?.append(undoneitem1)
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
        return 18
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView=UIView()
        footerView.backgroundColor=UIColor.white
        return footerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = doneItems[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text=arr![indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        doneItems[indexPath.section]?.remove(at: indexPath.row)
        let indexPaths=[indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range,in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        AddButton.isEnabled = !newText.isEmpty
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            let controller = segue.destination as!EditAddingItemDetailViewController
            controller.delegate=self
            controller.TitletoAdd = AddTitle.text!
            AddTitle.text=""
        }
    }
    
    func AddItemDetailerViewControllerDidCancel(_ controller: EditAddingItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    func AddItemDetailerController(_ controller: EditAddingItemDetailViewController, didFinishAdding item: DoneItem) {
        let newRowIndex = doneItems[0]!.count
        doneItems[0]?.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        FirstTableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
}

