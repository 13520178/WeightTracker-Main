//
//  HistoryCell.swift
//  WeightTracker-Main
//
//  Created by Phan Nhat Dang on 2/17/19.
//  Copyright © 2019 Phan Nhat Dang. All rights reserved.
//

import UIKit
import CoreData

protocol HistoryCellDelegate {
    func touchToDeleteCell(index : Int)
    func showDetailHistory(index : Int)
    func showFilterAction()
    func disableUserInteraction()
    func enableUserInteraction()
}

class HistoryCell: BaseCell, UITableViewDelegate, UITableViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate {
    
    var people = [Person]()
    var filterPeople = [Person]()
    var weightUnit = ""
    
    var showedFilter = false
    
    var delegate: HistoryCellDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tableView: UITableView = {
        var tb = UITableView()
        tb.backgroundColor = UIColor.clear
        tb.separatorStyle = .none
       
        return tb
    }()
    
    let headerTable:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6987634202)
        return v
    }()
    
    let headerTableLabel:UILabel = {
        let l = UILabel()
        l.text = "Daily records"
        l.font = UIFont.systemFont(ofSize: 25)
        l.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return l
    }()
    
    
    
    //MARK: - Filter setup
    
    let filterButton : UIButton = {
        let btn = UIButton()
        let image = UIImage(named: "filter")
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        btn.clipsToBounds = true
        btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6512054256)
        btn.setImage(image, for: .normal)
        return btn
      
    }()
    
    let filterStateLabel: UILabel = {
        let l = UILabel()
        l.text = "All records"
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return l
    }()
    
    let blurForFilterView: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2510784126)
        v.isHidden = true
        return v
    }()
    
    let filterView: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.isHidden = true
        return v
    }()
    
    let filterHeader: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.layer.cornerRadius = 8
        return v
    }()
    
    let filterDoneButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.layer.cornerRadius = 8
        btn.setTitleColor(#colorLiteral(red: 0.26, green: 0.47, blue: 0.96, alpha: 1), for: .normal)
        return btn
        
    }()
    
    let filterCancelButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.layer.cornerRadius = 8
        btn.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
        return btn
        
    }()
    
    
    let filterPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        picker.isHidden = false
        picker.layer.cornerRadius = 8
        return picker
    }()
    
    var pickerSelectedRow = 3
    let timeArray = ["All records", "This weak", "Previous weak", "This month", "Previous month", "This year"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = timeArray[row] as String
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)])
        
        return myTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelectedRow = row
    }
    
    
    override func setUpView() {
        super.setUpView()
        tableView.delegate = self
        tableView.dataSource = self
        
        filterPicker.delegate = self
        filterPicker.dataSource = self
        
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        
        let backgroundImage = UIImage(named: "toolCellBackground")
        let backgroundView = UIImageView(image: backgroundImage)
        backgroundView.contentMode = .scaleToFill
        
        self.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        addSubview(headerTable)
        headerTable.translatesAutoresizingMaskIntoConstraints = false
        headerTable.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        headerTable.heightAnchor.constraint(equalToConstant: 40).isActive = true
        headerTable.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true

        addSubview(filterStateLabel)
        filterStateLabel.translatesAutoresizingMaskIntoConstraints = false
        filterStateLabel.trailingAnchor.constraint(equalTo: headerTable.trailingAnchor, constant: -52).isActive = true
        filterStateLabel.centerYAnchor.constraint(equalTo: headerTable.centerYAnchor).isActive = true
        
        addSubview(headerTableLabel)
        headerTableLabel.translatesAutoresizingMaskIntoConstraints = false
        headerTableLabel.leadingAnchor.constraint(equalTo: headerTable.leadingAnchor, constant: 6).isActive = true
        headerTableLabel.centerYAnchor.constraint(equalTo: headerTable.centerYAnchor).isActive = true

        headerTable.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.centerYAnchor.constraint(equalTo: headerTable.centerYAnchor).isActive = true
        filterButton.trailingAnchor.constraint(equalTo: headerTable.trailingAnchor, constant: -5).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: 38).isActive = true
        filterButton.addTarget(self, action: #selector(showFilterAction), for: .touchUpInside)


        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkTouchInBlurView))
        addSubview(blurForFilterView)
        blurForFilterView.translatesAutoresizingMaskIntoConstraints = false
        blurForFilterView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        blurForFilterView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        blurForFilterView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        blurForFilterView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.blurForFilterView.addGestureRecognizer(gesture)
        
        filterView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        addSubview(filterView)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        filterView.widthAnchor.constraint(equalToConstant: self.frame.width - 24).isActive = true
        filterView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        filterView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        filterView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        filterView.addSubview(filterHeader)
        filterHeader.translatesAutoresizingMaskIntoConstraints = false
        filterHeader.bottomAnchor.constraint(equalTo: filterView.bottomAnchor, constant: -5).isActive = true
        filterHeader.widthAnchor.constraint(equalToConstant: self.frame.width - 24).isActive = true
        filterHeader.heightAnchor.constraint(equalToConstant: 40).isActive = true
        filterHeader.centerXAnchor.constraint(equalTo: filterView.centerXAnchor).isActive = true
        
        
        filterHeader.addSubview(filterDoneButton)
        filterDoneButton.translatesAutoresizingMaskIntoConstraints = false
        filterDoneButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        filterDoneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        filterDoneButton.topAnchor.constraint(equalTo: filterHeader.topAnchor, constant: 0).isActive = true
        filterDoneButton.leadingAnchor.constraint(equalTo: filterHeader.leadingAnchor, constant: 0).isActive = true
        filterDoneButton.addTarget(self, action: #selector(doneFilterAction), for: .touchUpInside)
        
        filterHeader.addSubview(filterCancelButton)
        filterCancelButton.translatesAutoresizingMaskIntoConstraints = false
        filterCancelButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        filterCancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        filterCancelButton.topAnchor.constraint(equalTo: filterHeader.topAnchor, constant: 0).isActive = true
        filterCancelButton.trailingAnchor.constraint(equalTo: filterHeader.trailingAnchor, constant: 0).isActive = true
        filterCancelButton.addTarget(self, action: #selector(hideFilterAction), for: .touchUpInside)
        
        
        filterPicker.selectRow(3, inComponent: 0, animated: true)
        filterView.addSubview(filterPicker)
        filterPicker.translatesAutoresizingMaskIntoConstraints = false
        filterPicker.topAnchor.constraint(equalTo: filterView.topAnchor, constant: 8).isActive = true
        
        filterPicker.widthAnchor.constraint(equalToConstant: self.frame.width - 24).isActive = true
        
        filterPicker.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        filterPicker.centerXAnchor.constraint(equalTo: filterView.centerXAnchor).isActive = true
        
        
        
        
        
        let request : NSFetchRequest<Person> = Person.fetchRequest()
        do {
            try people = context.fetch(request)
        } catch  {
            print("Error to fetch Item data")
        }
        
        for i in people {
            filterPeople.append(i)
        }

        
        //long press
        //Long Press
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.tableView.addGestureRecognizer(longPressGesture)
       
    }
    
    @objc func doneFilterAction() {
        if pickerSelectedRow == 1 {
            filterByTimes(datesTime: currentWeek())
            filterStateLabel.text = "This week"
        }else if pickerSelectedRow == 2{
            filterByTimes(datesTime: previousWeek())
            filterStateLabel.text = "Previous week"
        }else if pickerSelectedRow == 3{
            filterByTimes(datesTime: currentMonth())
            filterStateLabel.text = "This month"
        }else if pickerSelectedRow == 4{
            filterByTimes(datesTime: previousMonth())
            filterStateLabel.text = "Previous month"
        }else if pickerSelectedRow == 5{
            filterByTimes(datesTime: thisYear())
            filterStateLabel.text = "This year"
        }else {
            filterAll()
            filterStateLabel.text = "All records"
        }
        
     
        
        if blurForFilterView.isHidden == false {
            self.isUserInteractionEnabled = true
            self.delegate?.enableUserInteraction()
            self.filterView.isHidden = true
            self.blurForFilterView.isHidden = true
        }
    }
    
    //MARK: - Week, month, year funtion for filter
    func filterAll() {
        filterPeople = [Person]()
        for i in people {
            filterPeople.append(i)
        }
        tableView.reloadData()
    }
    func filterByTimes(datesTime:[String]) {
        let dates = datesTime
        filterPeople = [Person]()
        if let fromDate = Int(dates[0]), let toDate = Int(dates[1]) {
            for i in people {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let date = dateFormatter.date(from: i.date!)
                dateFormatter.dateFormat = "yyyyMMdd"
                let dateForUseToCompare = Int(dateFormatter.string(from: date!))
                if let dateForUseToCompare = dateForUseToCompare{
                    if dateForUseToCompare >= fromDate && dateForUseToCompare <= toDate {
                        filterPeople.append(i)
                    }
                }
            }
            tableView.reloadData()
        }
    }
    
    func currentWeek() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        let fromDay = Date().previous(.monday,considerToday: true)
        let fromDayInFormat = formatter.string(from: fromDay as Date)
        
        let toDay = Date().next(.sunday,considerToday: true)
        let toDayInFormat = formatter.string(from: toDay as Date)
        
        return [fromDayInFormat,toDayInFormat]
    }
    
    func previousWeek() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        let monday = Date().previous(.monday,considerToday: true)
        let fromDay = monday.previous(.monday)
        
        let fromDayInFormat = formatter.string(from: fromDay as Date)
        
        let toDay = fromDay.next(.sunday)
        let toDayInFormat = formatter.string(from: toDay as Date)
        
        return [fromDayInFormat,toDayInFormat]
        
        
    }
    
    func currentMonth() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        let previousMonth = Date().startOfMonth()
        let fromDayInFormat = formatter.string(from: previousMonth)
        
        let toDayInFormat = formatter.string(from: Date())
        print([fromDayInFormat,toDayInFormat])
        return [fromDayInFormat,toDayInFormat]
    }
    
    func previousMonth() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let middleDayInFormat = formatter.string(from: previousMonth!)
        
        let index1 = middleDayInFormat.index(middleDayInFormat.endIndex, offsetBy: -2)
        var fromDayInFormat = String(middleDayInFormat[..<index1])
        fromDayInFormat = fromDayInFormat + "01"
        
        let cal = Calendar(identifier: .gregorian)
        let monthRange = cal.range(of: .day, in: .month, for: previousMonth!)!
        let daysInMonth = monthRange.count
        
        var toDayInFormat = String(middleDayInFormat[..<index1])
        toDayInFormat = toDayInFormat + String(daysInMonth)
        
        print(toDayInFormat)
       
        
        return [fromDayInFormat,toDayInFormat]
    }
    
    func thisYear() -> [String] {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let stringYear = String(year)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        let fromDayInFormat = stringYear+"0101"
        let toDayInFormat = stringYear + "1231"
        print("Testststststtstststts")
        print(stringYear)
        return [fromDayInFormat,toDayInFormat]
    }
    
    @objc func checkTouchInBlurView(sender : UITapGestureRecognizer) {
        print("touched !!!")
        if blurForFilterView.isHidden == false {
            self.blurForFilterView.isHidden = true
            self.tableView.reloadData()
            self.isUserInteractionEnabled = true
            self.delegate?.enableUserInteraction()
            self.filterView.isHidden = true
            
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//                  self.filterView.frame.origin.y += 210
//                  self.tableView.frame.origin.y -= self.tableView.frame.height

//                self.layoutIfNeeded()
//            }, completion: {acion in
//                self.tableView.reloadData()
//                self.isUserInteractionEnabled = true
//                self.delegate?.enableUserInteraction()
//            })
        }

    }
    
    @objc func showFilterAction() {
//        self.blurForFilterView.isHidden = false
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//            self.filterView.frame.origin.y -= 210
//            self.tableView.frame.origin.y += self.tableView.frame.height
//            self.layoutIfNeeded()
//        }, completion: { action in
//            self.isUserInteractionEnabled = true
//            self.delegate?.disableUserInteraction()
//            self.tableView.reloadData()
//        })
        
        self.blurForFilterView.isHidden = false
        self.filterView.isHidden = false
        self.isUserInteractionEnabled = true
        self.delegate?.disableUserInteraction()
        self.tableView.reloadData()
        
    }
    
    @objc func hideFilterAction() {
//        self.blurForFilterView.isHidden = true
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//            self.filterView.frame.origin.y += 210
//            self.tableView.frame.origin.y -= self.tableView.frame.height
//            self.layoutIfNeeded()
//        }, completion: { action in
//
//            self.isUserInteractionEnabled = true
//            self.delegate?.enableUserInteraction()
//            self.tableView.reloadData()
//        })
        
        self.blurForFilterView.isHidden = true
        self.isUserInteractionEnabled = true
        self.delegate?.enableUserInteraction()
        self.tableView.reloadData()
        self.filterView.isHidden = true

    }
    
    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizer.State.began) {
            print("Long press on row, at \(indexPath!.row)")
            delegate?.touchToDeleteCell(index: indexPath!.row)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
        cell.selectionStyle = .none
        let max = filterPeople.count - 1
        if let date = filterPeople[max - indexPath.row].date {
            cell.dateLabel.text = String(date.description)
        }
        cell.weightLabel.text = "\(String(filterPeople[max - indexPath.row].weight)) \(weightUnit)"
        if filterPeople[max - indexPath.row].time == "Morning" {
            cell.timeLabel.text = "M"
            cell.timeLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }else if filterPeople[max - indexPath.row].time == "Afternoon" {
            cell.timeLabel.text = "A"
            cell.timeLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }else if filterPeople[max - indexPath.row].time == "Evening" {
            cell.timeLabel.text = "E"
            cell.timeLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }else {
            cell.timeLabel.text = "N"
            cell.timeLabel.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        }
        
        if filterPeople[max - indexPath.row].note! != "" {
            cell.noteImageView.isHidden = false
        }else {
            cell.noteImageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        delegate?.showDetailHistory(index: indexPath.row)
    }
    
 
}

class MyCell:UITableViewCell {
    
    var weightStackView: UIStackView!
    var weightLabel: UILabel = {
        var lb = UILabel()
        lb.text = "64.0 kg"
        lb.font = lb.font.withSize(16.0)
        lb.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    
    var dateLabel: UILabel = {
        var lb = UILabel()
        lb.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lb.text = "22/11/2018"
        lb.font = lb.font.withSize(16)
        return lb
    }()
    
    var timeLabel : UILabel = {
        var lb = UILabel()
        lb.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        lb.text = "M"
        lb.font = lb.font.withSize(18)
        return lb
    }()
    
    var showDetailLabel: UILabel = {
        var lb = UILabel()
        lb.text = "❯"
        lb.font = lb.font.withSize(30.0)
        lb.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    
    var lineView:UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6465802339)
        return view
    }()
    
    var noteImageView:UIImageView = {
        var view = UIImageView()
        let image = UIImage(named: "note")
        view.image = image
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        
        let weightTitleLabelView = UIView()
        let weightLabelView = UIView()
        
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2987202837)
        
        weightStackView = UIStackView(arrangedSubviews: [weightTitleLabelView,weightLabelView])
        weightStackView.axis = .horizontal
        weightStackView.distribution = .fillEqually
        
        addSubview(weightStackView)
        weightStackView.translatesAutoresizingMaskIntoConstraints = false
        weightStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0).isActive = true
        weightStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
        weightStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        

        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: weightTitleLabelView.topAnchor, constant: 5.0).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: weightTitleLabelView.leadingAnchor, constant: 0.0).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 105.0).isActive = true 
        
        
        addSubview(weightLabel)
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.topAnchor.constraint(equalTo: weightLabelView.topAnchor, constant: 5.0).isActive = true
        weightLabel.trailingAnchor.constraint(equalTo: weightLabelView.trailingAnchor, constant: -75).isActive = true
        

        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: weightTitleLabelView.topAnchor, constant: 4.0).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 5.0).isActive = true
        
        
        
        addSubview(showDetailLabel)
        showDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        showDetailLabel.topAnchor.constraint(equalTo: weightLabelView.topAnchor, constant: -5.0).isActive = true
        showDetailLabel.trailingAnchor.constraint(equalTo: weightLabelView.trailingAnchor, constant: -10).isActive = true
        
        addSubview(noteImageView)
        noteImageView.translatesAutoresizingMaskIntoConstraints = false
        noteImageView.topAnchor.constraint(equalTo: weightTitleLabelView.topAnchor, constant: 5.0).isActive = true
        noteImageView.trailingAnchor.constraint(equalTo: showDetailLabel.leadingAnchor, constant: -2.0).isActive = true
        noteImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        noteImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
}



