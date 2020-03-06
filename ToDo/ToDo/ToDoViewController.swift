//
//  ViewController.swift
//  ToDo
//
//  Created by hpc on 2020/1/19.
//  Copyright © 2020 hpc. All rights reserved.
//

import UIKit
import UserNotifications

class TodoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AddItemDetailViewControllerDelegate,UINavigationControllerDelegate{
    
    var AddButton = UIButton(frame: CGRect(x: 10, y: 0, width: 60, height: 80))
    var AddTextField = UITextField(frame: CGRect(x: 70, y: 20, width: 300, height: 40))
    var FirstTableView = UITableView(frame: CGRect(x: 0, y:150, width: 500, height: 800))
    var TopCell = UICollectionViewCell(frame: CGRect(x: 0, y: 80, width: 500, height:80 ))
    
    var ItemtoEdit:Item?
    var timer:Timer!
    
    var datamodel:DataModel = DataModel()
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstTableView.delegate = self
        FirstTableView.dataSource = self
        setUI()
        datamodel.loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBack), name: UIApplication.didEnterBackgroundNotification, object: nil)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TodoViewController.timerEvent), userInfo: nil, repeats:true)
//        var timer :DispatchSourceTimer?
//        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global()) as DispatchSourceTimer
//        timer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.seconds(1))
//        timer?.setEventHandler(handler: [self] in
//            self.timerEvent())
        
        datamodel.items[0]?.append(Item(name: "dsaj"))
    }
    @objc func didEnterBack(){
        let stopTime = Date()
        UserDefaults.standard.removeObject(forKey: "StopTime")
        UserDefaults.standard.set(stopTime, forKey: "StopTime")
        print("StopTime save success ")
    }
    @objc func didBecomeActive(){
        let StopTime = UserDefaults.standard.object(forKey: "StopTime")
        if StopTime != nil{
            let stopTime = StopTime as! Date
            let interval = Int(stopTime.timeIntervalSinceNow)
            timeCountDown(with: interval)
        }
    }
    func setUI(){
        AddButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        AddButton.setTitle("+", for:.normal)
        AddButton.setTitleColor(UIColor.systemGray, for: .normal)
        AddButton.isEnabled = false
        AddButton.addTarget(self, action: #selector(clickAddButton), for: .touchUpInside)
        
        AddTextField.delegate = self
        AddTextField.borderStyle = .roundedRect
        AddTextField.placeholder = "请输入所要添加的事件标题"
        
        TopCell.addSubview(AddButton)
        TopCell.addSubview(AddTextField)
        TopCell.backgroundColor=UIColor.white
        self.view.addSubview(TopCell)
        self.view.addSubview(FirstTableView)
        
        FirstTableView.delegate = self
        FirstTableView.dataSource = self
        FirstTableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datamodel.items[section]!.count
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
        let cellItem=datamodel.getItem(section: indexPath.section, row: indexPath.row)
        cell.setValueForCell(item: cellItem)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        datamodel.items[indexPath.section]![indexPath.row].removeNotification()
        
        datamodel.items[indexPath.section]?.remove(at: indexPath.row)
        
        datamodel.saveData()
        
        let indexPaths=[indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        ItemtoEdit = datamodel.getItem(section: indexPath.section, row: indexPath.row)
        performSegue(withIdentifier: "EditItem", sender: nil)
        FirstTableView.deselectRow(at: indexPath, animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range,in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        AddButton.isEnabled = !newText.isEmpty
        if AddButton.isEnabled {
            AddButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        else {
            AddButton.setTitleColor(UIColor.systemGray, for: .normal)
        }
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
    @objc func clickAddButton(){
        performSegue(withIdentifier: "AddItem", sender:nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            let controller = segue.destination as!EditItemViewController
            controller.delegate=self
            controller.TitletoAdd = AddTextField.text!
            AddTextField.text=""
            AddButton.isEnabled=false
            AddButton.setTitleColor(UIColor.systemGray, for: .normal)
        }
        else if segue.identifier=="EditItem"{
            let controller = segue.destination as! EditItemViewController
            controller.delegate = self
            controller.ItemtoEdit = ItemtoEdit
        }
    }
    
    func ItemDetailerViewControllerDidCancel(_ controller: EditItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    func AddItemDetailerController(_ controller: EditItemViewController, didFinishAdding ItemtoEdit: Item) {
        let newRowIndex = datamodel.items[0]!.count
        datamodel.items[0]?.append(ItemtoEdit)
        ItemtoEdit.scheduleNotification()
        datamodel.toItem = ItemtoEdit
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        FirstTableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    func EditItemDetailerController(_ controller: EditItemViewController, didFinishEditing item: Item) {
        item.scheduleNotification()
        if let index = datamodel.items[0]?.firstIndex(of:item){
            let indexPath = IndexPath(row:index,section: 0)
            let cell = FirstTableView.cellForRow(at: indexPath) as! TableViewCell
            cell.setValueForCell(item: item)
        }
        else if let index = datamodel.items[1]?.firstIndex(of:item){
            let indexPath = IndexPath(row: index, section: 1)
            let cell = FirstTableView.cellForRow(at: indexPath) as! TableViewCell
            cell.setValueForCell(item:item)
            if item.leftTime > 0 {
                MoveItem(item: item,from: 1,to:0)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    func MoveItem(item:Item,from oldSection:Int,to newSection:Int){
        if let oldIndex = datamodel.items[oldSection]?.firstIndex(of:item){
            datamodel.items[oldSection]?.remove(at: oldIndex)
            let indexPath = IndexPath(row: oldIndex, section: oldSection)
            let indexPaths = [indexPath]
            FirstTableView.deleteRows(at: indexPaths, with: .automatic)
        }
        let newIndex = datamodel.items[newSection]!.count
        datamodel.items[newSection]?.append(item)
        let newIndexPath = IndexPath(row: newIndex, section: newSection)
        let indexPaths = [newIndexPath]
        FirstTableView.insertRows(at: indexPaths, with: .automatic)
    }
    @objc func timerEvent(){
        timeCountDown(with: 1)
    }
    func timeCountDown(with interval:Int){
        for item in datamodel.items[0]! {
            if !item.TimeOut{
                if interval == 1{
                    item.countDown()}
                else {
                    item.leftTime += interval
                }
                if let index = datamodel.items[0]?.firstIndex(of:item){
                    let indexPath = IndexPath(row:index,section: 0)
                    let cell = FirstTableView.cellForRow(at: indexPath) as!TableViewCell
                    cell.refreshTime(item: item)
                }
                if item.leftTime <= 0{
                    item.TimeOut = true
                    let alert = UIAlertController(title: "Done", message: "\(item.name)倒计时已结束", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style:.default, handler:nil)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: false, completion: nil)
                    print("alarm \(item.name)")
                    MoveItem(item: item,from: 0,to: 1)
                }
            }
        }
    }
}
