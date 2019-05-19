//
//  InputWeightCell.swift
//  WeightTracker-Main
//
//  Created by Phan Nhat Dang on 2/17/19.
//  Copyright © 2019 Phan Nhat Dang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol InputWeightCellDelegate {
    func changeAndUpdateCell(didChange: Bool, person:Person)
    func checkIfWrongInput()
    func checkIfOverInput()
    func disableUserInteraction()
    func enableUserInteraction()
    func showUpgradeInTabOne()
    func resetData()
    func showSub1()
    func showSub2()
    func showSub3()
    func showSub4()
}

class InputWeightCell: BaseCell,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate{
   
    //MARK: - MainView variables
    let inputWeightView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return v
    }()
    
    //MARK: - Textfield setup
    
    let inputWeightTextfield :UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string:"Weight...", attributes:[NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),NSAttributedString.Key.font :UIFont(name: "Arial", size: 25)!])
        tf.font = UIFont.systemFont(ofSize: 25)
        tf.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        tf.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        tf.textAlignment = .center
        tf.keyboardType = .decimalPad
        tf.isUserInteractionEnabled = true
        tf.setBottomBorder()
        return tf
    }()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("tf touch")
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        
        if hour >= 6 && hour < 12 {
            print("Morning")
            timePicker.selectRow(0, inComponent: 0, animated: true)
            pickerSelectedRow = 0
        }else if hour >= 12 && hour < 17 {
            print("Afternoom")
            timePicker.selectRow(1, inComponent: 0, animated: true)
            pickerSelectedRow = 1
        }else if hour >= 17 && hour < 20 {
            print("Everning")
            timePicker.selectRow(2, inComponent: 0, animated: true)
            pickerSelectedRow = 2
        }else {
            print("night")
            timePicker.selectRow(3, inComponent: 0, animated: true)
            pickerSelectedRow = 3
        }
    }
    
    let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "  Note (optional)"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "  Time"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    let noteTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        tv.layer.cornerRadius = 12.0
        tv.layer.borderWidth = 1
        tv.layer.borderColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
        tv.layer.masksToBounds = true
        return tv
    }()
    
    let kgLabel:UILabel = {
        let label = UILabel()
        label.text = "Kg."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        return label
    }()
    
    let imageBelowEnterButton: UIImageView = {
        let image = UIImage(named: "enterButtonImage")
        let iu = UIImageView(image: image)
        iu.layer.cornerRadius = 23
        iu.clipsToBounds = true
        return iu
    }()
    
  
    
    let enterButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.roundedRect)
        bt.setTitle("Enter", for: .normal)
        bt.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        bt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        bt.titleLabel?.font = UIFont(name:"TrebuchetMS", size: 30)
        bt.layer.cornerRadius = 23

        return bt
    }()
    
    
    //UIPicker set up
    var pickerSelectedRow = 0
    let timeArray = ["Morning", "Afternoon", "Evening", "Night"]
    let timePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.isHidden = false
        return picker
    }()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeArray.count
    }

    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = timeArray[row] as String
        if row == 0 {
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)])
            return myTitle
        }else if row == 1 {
             let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)])
            return myTitle
        }else if row == 2 {
             let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
            return myTitle
        }else {
             let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)])
            return myTitle
        }

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelectedRow = row
    }
    
    let resetButton: UIButton = {
        let bt = UIButton()
        let image = UIImage(named: "showCalculatorButton")
        bt.setImage(image, for: .normal)
        bt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9972919862)
        bt.layer.cornerRadius = 8
        return bt
    }()
    

    


    
    let shadowResetbuttonView : UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        v.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowOpacity = 0.3
        v.layer.shadowRadius = 6.0
        return v
    }()
    
    let resetInBlurViewButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.roundedRect)
        bt.setTitle("⊗", for: .normal)
        bt.titleLabel?.font = UIFont(name:"Avenir-Light", size: 25)
        bt.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        bt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return bt
    }()
    
    let blurView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5497507669)
        
        return v
    }()
    
    let caculatorView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.layer.cornerRadius = 25
        v.layer.borderWidth = 1
        v.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        v.clipsToBounds = true
        return v
    }()
    
    let titleCaculatorView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        v.clipsToBounds = true
        return v
    }()
    
    let calculationToolsLabel : UILabel =  {
        let label = UILabel()
        label.text = "Calculation tools"
        label.font = UIFont(name:"TrebuchetMS", size: 18)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    var delegate: InputWeightCellDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request : NSFetchRequest<Person> = Person.fetchRequest()
    
    
    //MARK: - SubsView Variable
    let subView1 = InputWeightSubView()
    let subView2 = InputWeightSubView()
    let subView3 = InputWeightSubView()
    let subView4 = InputWeightSubView()
    
    override func setUpView() {
        super.setUpView()
        // add image to Detail View
        let backgroundImage = UIImage(named: "toolCellBackground")
        let backgroundView = UIImageView(image: backgroundImage)
        backgroundView.contentMode = .scaleToFill
        
        self.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        
        self.timePicker.dataSource = self
        self.timePicker.delegate = self
        self.inputWeightTextfield.delegate = self
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        
        inputWeightView.layer.cornerRadius = 15.0
        inputWeightView.layer.borderWidth = 1.5
        inputWeightView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        inputWeightView.layer.masksToBounds = true
        
        
        let selfWidth = self.layer.frame.width
        let selfHeight = self.layer.frame.height
        addSubview(inputWeightView)
        inputWeightView.translatesAutoresizingMaskIntoConstraints = false
        inputWeightView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        inputWeightView.topAnchor.constraint(equalTo: self.topAnchor, constant: (selfHeight-330)/2).isActive = true
        inputWeightView.widthAnchor.constraint(equalToConstant: selfWidth - 40).isActive = true
        inputWeightView.heightAnchor.constraint(equalToConstant: 315.0).isActive = true
        
        inputWeightView.addSubview(inputWeightTextfield)
        inputWeightTextfield.translatesAutoresizingMaskIntoConstraints = false
        inputWeightTextfield.centerXAnchor.constraint(equalTo: inputWeightView.centerXAnchor).isActive = true
        inputWeightTextfield.topAnchor.constraint(equalTo: inputWeightView.topAnchor, constant: 18.0).isActive = true
        inputWeightTextfield.widthAnchor.constraint(equalToConstant: selfWidth - 100).isActive = true
        inputWeightTextfield.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        let trailingTextField = (self.layer.frame.width - 240.0)/(-2)
        print(trailingTextField)
        addSubview(kgLabel)
        kgLabel.translatesAutoresizingMaskIntoConstraints = false
        kgLabel.topAnchor.constraint(equalTo: inputWeightTextfield.bottomAnchor, constant: 8).isActive = true
        kgLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingTextField).isActive = true
        
        addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.topAnchor.constraint(equalTo: kgLabel.bottomAnchor, constant: 4).isActive = true
        noteLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 50 ).isActive = true
        
        addSubview(noteTextView)
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 0).isActive = true
        noteTextView.centerXAnchor.constraint(equalTo: inputWeightView.centerXAnchor).isActive = true
        noteTextView.widthAnchor.constraint(equalToConstant: selfWidth - 100).isActive = true
        noteTextView.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 40).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 50 ).isActive = true
        
        addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 7).isActive = true
        timePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 100 ).isActive = true
        timePicker.widthAnchor.constraint(equalToConstant: selfWidth - 200).isActive = true
        timePicker.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        
        
        
        addSubview(imageBelowEnterButton)
        imageBelowEnterButton.translatesAutoresizingMaskIntoConstraints = false
        imageBelowEnterButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        imageBelowEnterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        imageBelowEnterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22).isActive = true
        imageBelowEnterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22).isActive = true
        
        
        addSubview(enterButton)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        enterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        enterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22).isActive = true
        enterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22).isActive = true
        enterButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        
        addSubview(shadowResetbuttonView)
        shadowResetbuttonView.translatesAutoresizingMaskIntoConstraints = false
        shadowResetbuttonView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        shadowResetbuttonView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        shadowResetbuttonView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        shadowResetbuttonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        
        shadowResetbuttonView.addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        resetButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        resetButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        resetButton.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
        
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkTouchInBlurView))
        blurView.isHidden = true
        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.widthAnchor.constraint(equalToConstant: self.layer.frame.width ).isActive = true
        blurView.heightAnchor.constraint(equalToConstant: self.layer.frame.height).isActive = true
        blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        blurView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.blurView.addGestureRecognizer(gesture)
        
        
        addSubview(caculatorView)
        caculatorView.translatesAutoresizingMaskIntoConstraints = false
        caculatorView.widthAnchor.constraint(equalToConstant: self.layer.frame.width).isActive = true
        caculatorView.heightAnchor.constraint(equalToConstant: 380).isActive = true
        caculatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 380).isActive = true
        caculatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        caculatorView.addSubview(titleCaculatorView)
        titleCaculatorView.translatesAutoresizingMaskIntoConstraints = false
        titleCaculatorView.widthAnchor.constraint(equalToConstant: self.layer.frame.width).isActive = true
        titleCaculatorView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        titleCaculatorView.topAnchor.constraint(equalTo: caculatorView.topAnchor, constant: 0).isActive = true
        titleCaculatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
       

        caculatorView.addSubview(resetInBlurViewButton)
        resetInBlurViewButton.translatesAutoresizingMaskIntoConstraints = false
        resetInBlurViewButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        resetInBlurViewButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        resetInBlurViewButton.topAnchor.constraint(equalTo: caculatorView.topAnchor, constant: 0).isActive = true
        resetInBlurViewButton.trailingAnchor.constraint(equalTo: caculatorView.trailingAnchor, constant: -2).isActive = true
        resetInBlurViewButton.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
        
        setupsubsCalculatorView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tap)
        
    }
    
    //MARK: - setup SubsCalculatorView
    @objc func checkTouchInBlurView(sender : UITapGestureRecognizer) {
        print("touched !!!")
        if blurView.isHidden == false {
            blurView.isHidden = true
            self.isUserInteractionEnabled = true
            delegate?.enableUserInteraction()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.caculatorView.frame.origin.y += 355
            }, completion: nil)
        }
        
    }
    
    func setupsubsCalculatorView() {
        caculatorView.addSubview(calculationToolsLabel)
        calculationToolsLabel.translatesAutoresizingMaskIntoConstraints = false
        calculationToolsLabel.topAnchor.constraint(equalTo: caculatorView.topAnchor, constant: 7.0).isActive = true
        calculationToolsLabel.leadingAnchor.constraint(equalTo: caculatorView.leadingAnchor, constant: 12.0).isActive = true
        
        
        let subView1Tap = UITapGestureRecognizer(target: self, action: #selector(subView1HandleTap(_:)))
        subView1.addGestureRecognizer(subView1Tap)
        subView1.setupProperty(captionText: "BMI", contentText: "Determine reasonable weight",imageName: "BMI", imageBackGround: "green")
        caculatorView.addSubview(subView1)
        subView1.translatesAutoresizingMaskIntoConstraints = false
        subView1.topAnchor.constraint(equalTo: caculatorView.topAnchor, constant: 45.0).isActive = true
        subView1.centerXAnchor.constraint(equalTo: caculatorView.centerXAnchor).isActive = true
        subView1.widthAnchor.constraint(equalToConstant: self.layer.frame.width - 16).isActive = true
        subView1.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        
        
        let subView2Tap = UITapGestureRecognizer(target: self, action: #selector(subView2HandleTap(_:)))
        subView2.addGestureRecognizer(subView2Tap)
        subView2.setupProperty(captionText: "BMR (TDEE)", contentText: "Total daily calories using",imageName: "BMR", imageBackGround: "orange")
        caculatorView.addSubview(subView2)
        subView2.translatesAutoresizingMaskIntoConstraints = false
        subView2.topAnchor.constraint(equalTo: subView1.bottomAnchor, constant: 12.0).isActive = true
        subView2.centerXAnchor.constraint(equalTo: caculatorView.centerXAnchor).isActive = true
        subView2.widthAnchor.constraint(equalToConstant: self.layer.frame.width - 16).isActive = true
        subView2.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        
        
        let subView3Tap = UITapGestureRecognizer(target: self, action: #selector(subView3HandleTap(_:)))
        subView3.addGestureRecognizer(subView3Tap)
        subView3.setupProperty(captionText: "YMCA", contentText: "Body fat calculator",imageName: "bodyFat",imageBackGround: "blue")
        caculatorView.addSubview(subView3)
        subView3.translatesAutoresizingMaskIntoConstraints = false
        subView3.topAnchor.constraint(equalTo: subView2.bottomAnchor, constant: 12.0).isActive = true
        subView3.centerXAnchor.constraint(equalTo: caculatorView.centerXAnchor).isActive = true
        subView3.widthAnchor.constraint(equalToConstant: self.layer.frame.width - 16).isActive = true
        subView3.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        
        
        let subView4Tap = UITapGestureRecognizer(target: self, action: #selector(subView4HandleTap(_:)))
        subView4.addGestureRecognizer(subView4Tap)
        subView4.setupProperty(captionText: "WHR", contentText: "Waist-to-Hip ratio",imageName: "WHR", imageBackGround: "pink")
        caculatorView.addSubview(subView4)
        subView4.translatesAutoresizingMaskIntoConstraints = false
        subView4.topAnchor.constraint(equalTo: subView3.bottomAnchor, constant: 12.0).isActive = true
        subView4.centerXAnchor.constraint(equalTo: caculatorView.centerXAnchor).isActive = true
        subView4.widthAnchor.constraint(equalToConstant: self.layer.frame.width - 16).isActive = true
        subView4.heightAnchor.constraint(equalToConstant: 64.0).isActive = true

    }
    
    
    //MARK: - Action Handle
    @objc func subView1HandleTap( _ sender: UITapGestureRecognizer? = nil) {
        delegate?.showSub1()
    }
    
    @objc func subView2HandleTap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.showSub2()
    }
    
    @objc func subView3HandleTap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.showSub3()
    }
    
    @objc func subView4HandleTap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.showSub4()
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        endEditing(true)
    }
    
    @objc func resetButtonAction(sender: UIButton!) {
       if caculatorView.frame.origin.y == self.layer.frame.height {
            blurView.isHidden = false
            self.isUserInteractionEnabled = true
            delegate?.disableUserInteraction()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.caculatorView.frame.origin.y -= 355
            }, completion: nil)
        }else {
            blurView.isHidden = true
            self.isUserInteractionEnabled = true
            delegate?.enableUserInteraction()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.caculatorView.frame.origin.y += 355
            }, completion: nil)
        }
        
        
       
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        
        
        if inputWeightTextfield.text != ""
        {
            if var w = inputWeightTextfield.text {
                w = w.replacingOccurrences(of: ",", with: ".")
                if let w = Float(w) {
                    if w > 1 && w <= 400 {
                        let person = Person(context: context)
                        person.weight = w
                        person.date = Date().string(format: "dd-MM-yyyy")
                        person.note = noteTextView.text!
                        person.time = timeArray[pickerSelectedRow]
                        savePerson()
                
                        var people = [Person]()
                        do {
                            try people = self.context.fetch(self.request)
                        } catch  {
                            print("Error to fetch Item data")
                        }
                        
                        if(people.count >= 4) {
                            delegate?.showUpgradeInTabOne()
                        }
                        
                        delegate?.changeAndUpdateCell(didChange: true, person: person)
                    }else {
                        delegate?.checkIfOverInput()
                    }
                }else {
                    delegate?.checkIfWrongInput()
                }
            }
        }else {
            delegate?.checkIfWrongInput()
        }
        inputWeightTextfield.text = ""
        noteTextView.text = ""
    }
    
    func savePerson() {
        do {
            try context.save()
        } catch  {
            print("Error to saving data")
        }
    }

}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0.5563300252, green: 0.3507795036, blue: 0.9688282609, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
