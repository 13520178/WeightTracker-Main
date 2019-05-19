//
//  ToolCell.swift
//  WeightTracker-Main
//
//  Created by Phan Nhat Dang on 3/6/19.
//  Copyright © 2019 Phan Nhat Dang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol ToolCellDelegate {
    func checkIfWrongInputToolCell()
    func enterWeightFirst()
    func enterInitialWeight()
    func enterDesiredWeight(dWeight:Double)
    func upgradeToPro()
    func showPrediction()
}


class ToolCell: BaseCell,UITextFieldDelegate {
    
    var delegate: ToolCellDelegate?
    var people = [Person]()
    var weightUnit = ""
    var heightUnit = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request : NSFetchRequest<Person> = Person.fetchRequest()
    
    let defaults = UserDefaults.standard
    var height: Double = -1
    var ftHeight:Double = -1
    var inHeight:Double = -1
    var desiredWeight:Double = -1
    var completedRate: Double = 0.0
    
    //MARK: - Input View Var
   
    
    let profileView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      
        return v
    }()
    

    
    let roundView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.839170162, green: 0.7727752205, blue: 0.9737234748, alpha: 0.799091737)
        v.layer.cornerRadius = 6.0
        v.layer.masksToBounds = true
        
        return v
    }()
    
    let profileLabel:UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        return label
    }()
    
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.text = "( This table only appears when you start or want to change your weight goal. )"
        label.font = UIFont(name:"TrebuchetMS-Italic", size: 15)
        label.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    let cmLabel:UILabel = {
        let label = UILabel()
        label.text = "cm"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        return label
    }()
    
    let kgLabel:UILabel = {
        let label = UILabel()
        label.text = "kg"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        return label
    }()
    
    let enterButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.roundedRect)
        bt.setTitle("Let's go !!!", for: .normal)
        bt.setTitleColor(#colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1), for: .normal)
        bt.titleLabel?.font = UIFont(name:"Avenir-Light", size: 20)
        bt.layer.cornerRadius = 18
        bt.layer.borderWidth = 1.5
        bt.layer.borderColor =  #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        
        return bt
    }()
    
    let inputHeightTextfield :UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string:"Your height ", attributes:[NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),NSAttributedString.Key.font :UIFont(name: "Arial", size: 18)!])
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tf.textAlignment = .center
        tf.keyboardType = .numberPad
        tf.isUserInteractionEnabled = true
        tf.setBottomBorder()
        return tf
    }()
    
    // ft vs in input
    let inputFtHeightTextfield :UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string:" ", attributes:[NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),NSAttributedString.Key.font :UIFont(name: "Arial", size: 18)!])
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tf.textAlignment = .center
        tf.keyboardType = .numberPad
        tf.isUserInteractionEnabled = true
        tf.setBottomBorder()
        return tf
    }()
    
    let inputInHeightTextfield :UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string:" ", attributes:[NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),NSAttributedString.Key.font :UIFont(name: "Arial", size: 18)!])
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tf.textAlignment = .center
        tf.keyboardType = .decimalPad
        tf.isUserInteractionEnabled = true
        tf.setBottomBorder()
        return tf
    }()
    
    let ftLabel:UILabel = {
        let label = UILabel()
        label.text = "ft"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        return label
    }()
    
    let inLabel:UILabel = {
        let label = UILabel()
        label.text = "in"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        return label
    }()
    
    let desiredWeightTextfield :UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string:"Your desired weight", attributes:[NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),NSAttributedString.Key.font :UIFont(name: "Arial", size: 18)!])
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tf.textAlignment = .center
        tf.keyboardType = .decimalPad
        tf.isUserInteractionEnabled = true
        tf.setBottomBorder()
        return tf
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        return label
    }()
    
    let targetWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "Desired weight"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        return label
    }()
    
    //MARK: - DetailView var
    
    var weightPredictionStackView: UIStackView!
    var predict7DaysStackview: UIStackView!
    var predict14DaysStackview: UIStackView!
    var predict30DaysStackview: UIStackView!
    
    
    let scrollView : UIScrollView = {
        let sV = UIScrollView()
        sV.translatesAutoresizingMaskIntoConstraints = false
        sV.contentSize.height = 750
        
        return sV
    }()
    
    let detailView:UIView = {
       let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return v
    }()
    
    let progressView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        v.layer.cornerRadius = 12.0
        v.layer.borderWidth = 1.5
        v.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.layer.masksToBounds = true
        return v
    }()
    
    let progressTitleView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        v.layer.borderWidth = 1
        v.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        v.layer.masksToBounds = true
        return v
    }()
    
    let predictView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        return v
    }()
    
    let bmiView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3476802147)
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        return v
    }()
    
    let predictTitleView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        v.layer.cornerRadius = 0
        v.layer.masksToBounds = true
        return v
    }()
    
    let bmiTitleView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        v.layer.cornerRadius = 0
        v.layer.masksToBounds = true
        return v
    }()
    
    
    let weightTrendLineView1:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5527583397)
        v.layer.cornerRadius = 1
        v.clipsToBounds = true
        return v
    }()
    let weightTrendLineView2:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5527583397)
        v.layer.cornerRadius = 1
        v.clipsToBounds = true
        return v
    }()
    
    
    let changeProfileImageButton: UIImageView =  {
        let image = UIImage(named: "enterButtonImage")
        let ui = UIImageView(image: image)
        ui.layer.cornerRadius = 12
        ui.clipsToBounds = true
        
        return ui
    }()
    
    let changeProfileButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.roundedRect)
        bt.setTitle("Set target  ", for: .normal)
        bt.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        bt.titleLabel?.font = UIFont(name:"TrebuchetMS", size: 18)
        bt.layer.cornerRadius = 12
        bt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        return bt
    }()
    
    let predictTitleLabel:UILabel = {
        let l = UILabel()
        l.text = "Weight prediction"
        l.font = UIFont(name:"TrebuchetMS", size: 18)
        l.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return l
    }()
    
    let lastInputWeightTitleLabel:UILabel = {
        let l = UILabel()
        l.text = "Last weight record: "
        l.font = UIFont(name:"TrebuchetMS", size: 15)
        l.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return l
    }()
    let lastInputWeightValueLabel:UILabel = {
        let l = UILabel()
        l.text = "17/05/2019"
        l.font = UIFont(name:"TrebuchetMS", size: 15)
        l.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return l
    }()
    
    let weightPredictionNoteLabel:UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.text = "Results are calculated at the date of the last weight recorded."
        l.font = UIFont(name:"TrebuchetMS-Italic", size: 12)
        l.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        return l
    }()
    
    let bmiTitleLabel:UILabel = {
        let l = UILabel()
        l.text = "Body mass index"
        l.font = UIFont(name:"TrebuchetMS", size: 18)
        l.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return l
    }()
    
    var predictIn7DaysTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Next 7 days"
        lb.font = lb.font.withSize(13.0)
        lb.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    
    var predictIn7DaysLabel: UILabel = {
        let lb = UILabel()
        lb.text = "-3.0"
        lb.font = lb.font.withSize(16.0)
        lb.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    
    var predictIn14DaysTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Next 14 days"
        lb.font = lb.font.withSize(13.0)
        lb.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    
    var predictIn14DaysLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Upgrade"
        lb.font = lb.font.withSize(16.0)
        lb.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    
    var predictIn30DaysTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Next 30 days"
        lb.font = lb.font.withSize(13.0)
        lb.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    
    var predictIn30DaysLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Upgrade"
        lb.font = lb.font.withSize(16.0)
        lb.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    
    var predictNoteButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 11
        btn.layer.borderWidth = 1
        btn.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btn.clipsToBounds = true
        btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        btn.setTitle("!", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        return btn
    }()
    
    let BMILabel:UILabel = {
        let label = UILabel()
        label.text = "BMI"
        label.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)
        label.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    let BMIValueLabel:UILabel = {
        let label = UILabel()
        label.text = "20.54"
        label.font = UIFont.systemFont(ofSize: 52, weight: UIFont.Weight.bold)
        label.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    let kgValueLabel:UILabel = {
        let label = UILabel()
        label.text = "65 kg"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        label.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        return label
    }()
    
    let cmValueLabel:UILabel = {
        let label = UILabel()
        label.text = "168 cm"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        label.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        return label
    }()
    
    var kgCmStackView = UIStackView()
    
    let bmiCategoryView1:UIView = {
        let v = UIView()
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
        return v
    }()
    let bmiCategoryView1Label: UILabel = {
        let l = UILabel()
        l.text = "BMI ≤ 18.5"
        l.font = UIFont(name:"TrebuchetMS", size: 15)
        l.textAlignment = NSTextAlignment.center
        l.backgroundColor = UIColor.clear
        l.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return l
    }()
    let bmiCategoryValueView1Label: UILabel = {
        let l = UILabel()
        l.text = "Underweight"
        l.font = UIFont(name:"TrebuchetMS", size: 15)
        l.textAlignment = NSTextAlignment.center
        l.backgroundColor = UIColor.clear
        l.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return l
    }()
    
    let bmiCategoryView2:UIView = {
        let v = UIView()
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
        return v
    }()
    let bmiCategoryView2Label: UILabel = {
        let l = UILabel()
        l.text = "18.5 < BMI ≤ 25 "
        l.font = UIFont(name:"TrebuchetMS", size: 15)
        l.textAlignment = NSTextAlignment.center
        l.backgroundColor = UIColor.clear
        l.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return l
    }()
    let bmiCategoryValueView2Label: UILabel = {
        let l = UILabel()
        l.text = "Normal weight"
        l.font = UIFont(name:"TrebuchetMS", size: 15)
        l.textAlignment = NSTextAlignment.center
        l.backgroundColor = UIColor.clear
        l.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return l
    }()
    
    
    let bmiCategoryView3:UIView = {
        let v = UIView()
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
        return v
    }()
    let bmiCategoryView3Label: UILabel = {
        let l = UILabel()
        l.text = "25 < BMI ≤ 30"
        l.font = UIFont(name:"TrebuchetMS", size: 15)
        l.textAlignment = NSTextAlignment.center
        l.backgroundColor = UIColor.clear
        l.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return l
    }()
    let bmiCategoryValueView3Label: UILabel = {
        let l = UILabel()
        l.text = "Overweight"
        l.font = UIFont(name:"TrebuchetMS", size: 15)
        l.textAlignment = NSTextAlignment.center
        l.backgroundColor = UIColor.clear
        l.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return l
    }()
    
    
    let bmiCategoryView4:UIView = {
        let v = UIView()
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
        return v
    }()
    let bmiCategoryView4Label: UILabel = {
        let l = UILabel()
        l.text = "30 ≤ BMI"
        l.font = UIFont(name:"TrebuchetMS", size: 15)
        l.textAlignment = NSTextAlignment.center
        l.backgroundColor = UIColor.clear
        l.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return l
    }()
    let bmiCategoryValueView4Label: UILabel = {
        let l = UILabel()
        l.text = "Obesity"
        l.font = UIFont(name:"TrebuchetMS", size: 15)
        l.textAlignment = NSTextAlignment.center
        l.backgroundColor = UIColor.clear
        l.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return l
    }()


    let lineDetailView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9991492523)
        
        return v
    }()
    
    let categoryLabel:UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.textColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        return label
    }()
    
    let categoryValueLabel:UILabel = {
        let label = UILabel()
        label.text = "Normal (healthy weight)"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    let riskLabel:UILabel = {
        let label = UILabel()
        label.text = "Risks of diseases (obesity)"
        label.font = UIFont(name:"TrebuchetMS", size: 16)
        label.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    let riskValueLabel:UILabel = {
        let label = UILabel()
        label.text = "Medium"
        label.font = UIFont(name:"TrebuchetMS", size: 18)
        label.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    //Progress View
    var shapeLayer: CAShapeLayer!
    var backgoundShapeLayer:CAShapeLayer!
    var lineShapeLayer:CAShapeLayer!
    var borderBackgoundShapeLayer:CAShapeLayer!
    let percentlabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
        l.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        return l
    }()
    
    let currentWeightlabel : UILabel = {
        let l = UILabel()
        l.text = "Current weight: 64 kg"
        l.font = UIFont(name:"TrebuchetMS", size: 16)
        l.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return l
    }()
    
    let progressTitlelabel : UILabel = {
        let l = UILabel()
        l.text = "Weight change process"
        l.font = UIFont(name:"TrebuchetMS", size: 18)
        l.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return l
    }()
    
    let initWeightlabel : UILabel = {
        let l = UILabel()
        l.text = "70.0 kg"
        l.font = UIFont.systemFont(ofSize: 17)
        l.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        return l
    }()
    
    let initWeightButton : UIButton = {
        let btn = UIButton()
        let image = UIImage(named: "resetIcon")
        btn.layer.cornerRadius = 15
        btn.layer.borderWidth = 1
        btn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.clipsToBounds = true
        btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6512054256)
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    let targetWeightlabel : UILabel = {
        let l = UILabel()
        l.text = "60.0 kg"
        l.font = UIFont.systemFont(ofSize: 17)
        l.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        return l
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField ==  inputFtHeightTextfield {
            return range.location <= 1
        } else if textField ==  inputInHeightTextfield {
            return range.location <= 2
        }
        else {
            return range.location <= 10
        }
    }
    
    //MARK: - Setup View
    override func setUpView() {
        super.setUpView()
        backgroundColor = #colorLiteral(red: 0.839170162, green: 0.7727752205, blue: 0.9737234748, alpha: 0.799091737)
        
        inputInHeightTextfield.delegate = self
        inputFtHeightTextfield.delegate = self
        
        setInputView()
        setDetailView()
        setupWeightPrediction()
        setProgressView()
       
        
        do {
            try people = context.fetch(request)
        } catch  {
            print("Error to fetch Item data")
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tap)
        
        if defaults.bool(forKey: "wasShowInput") == true {
            setProfileViewPosition()
          
        }
        
        setWeightPrediction()
        
        if people.count != 0 {
            calculateAndShowBMIValue()
        }
        
        let tapToUpgade14 = UITapGestureRecognizer(target: self, action: #selector(showUpdateAlert))
        let tapToUpgade30 = UITapGestureRecognizer(target: self, action: #selector(showUpdateAlert))
        predict14DaysStackview.addGestureRecognizer(tapToUpgade14)
        predict30DaysStackview.addGestureRecognizer(tapToUpgade30)
        
    }
    
    @objc func showUpdateAlert() {
        delegate?.upgradeToPro()
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        endEditing(true)
    }
    //MARK: - ProgressView SETUP
    func setProgressView() {
        borderBackgoundShapeLayer = initialChart(withStrokeColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), withLineWidth: 9, byFillColor: UIColor.clear.cgColor, withStrokeEnd: 1)
        
        backgoundShapeLayer = initialChart(withStrokeColor: #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1), withLineWidth: 8, byFillColor: UIColor.clear.cgColor, withStrokeEnd: 1)
        
         lineShapeLayer = initialChart(withStrokeColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), withLineWidth: 1, byFillColor: UIColor.clear.cgColor, withStrokeEnd: 1)
        
        shapeLayer = initialChart(withStrokeColor: UIColor.red.cgColor, withLineWidth: 6, byFillColor: UIColor.clear.cgColor, withStrokeEnd: 0)
        
        progressView.layer.addSublayer(borderBackgoundShapeLayer)
        progressView.layer.addSublayer(backgoundShapeLayer)
        progressView.layer.addSublayer(lineShapeLayer)
        progressView.layer.addSublayer(shapeLayer)
        
        //Add % Label
        progressView.addSubview(percentlabel)
        percentlabel.translatesAutoresizingMaskIntoConstraints = false
        percentlabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor).isActive = true
        percentlabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor, constant: 5).isActive = true
        
        
        // Add currentWeightlabel
        progressView.addSubview(currentWeightlabel)
        currentWeightlabel.translatesAutoresizingMaskIntoConstraints = false
        currentWeightlabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 12.0).isActive = true
        currentWeightlabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: -5.0).isActive = true
        
        progressView.addSubview(progressTitlelabel)
        progressTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        progressTitlelabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 10.0).isActive = true
        progressTitlelabel.topAnchor.constraint(equalTo: progressView.topAnchor, constant: 3.0).isActive = true
        
        // Add currentWeightlabel
        progressView.addSubview(initWeightlabel)
        initWeightlabel.translatesAutoresizingMaskIntoConstraints = false
        initWeightlabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: -28).isActive = true
        initWeightlabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor, constant: -70.0).isActive = true
        
        
        progressView.addSubview(initWeightButton)
        initWeightButton.translatesAutoresizingMaskIntoConstraints = false
        initWeightButton.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: -25).isActive = true
        initWeightButton.trailingAnchor.constraint(equalTo: initWeightlabel.leadingAnchor, constant: -5.0).isActive = true
        initWeightButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        initWeightButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        initWeightButton.addTarget(self, action: #selector(seInitialWeight), for: .touchUpInside)
        
        
        
        
        
        // Add targetWeightlabel
        progressView.addSubview(targetWeightlabel)
        targetWeightlabel.translatesAutoresizingMaskIntoConstraints = false
        targetWeightlabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: -28.0).isActive = true
        targetWeightlabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor, constant: 70).isActive = true
        
        startChart()
    }
    
    
    
    //MARK: - Chart SETUP
    func startChart() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = completedRate
        basicAnimation.duration = 2

        //percentlabel.text = String(round(10*(completedRate*100))/10) + "%"

        shapeLayer.strokeColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    func initialChart(withStrokeColor strokeColor: CGColor, withLineWidth lineWidth:CGFloat, byFillColor fillColor: CGColor, withStrokeEnd strockEnd:CGFloat)->CAShapeLayer {
        
        let centerpoint = CGPoint.zero
        let circularPath = UIBezierPath(arcCenter: centerpoint, radius: 85, startAngle: 0.9 * CGFloat.pi, endAngle: 2.1 * CGFloat.pi, clockwise: true)
        
        let chart = CAShapeLayer()
        
        chart.path = circularPath.cgPath
        chart.strokeColor = strokeColor
        chart.lineWidth = lineWidth
        chart.fillColor = fillColor
        chart.lineCap = CAShapeLayerLineCap.round
        chart.strokeEnd = strockEnd
        chart.position = CGPoint(x: self.frame.width/2 - 55/3, y: 120.0)
        chart.name = "myLayer"
        print(self.frame.height/2)
        
        return chart
    }
    
    @objc func seInitialWeight() {
        delegate?.enterInitialWeight()
    }
    
    //MARK: - Setup Prediction Weight
    
    func setWeightPrediction() {
        
        let averageWeight = caculateAverageWeight()
        if people.count > 0 {
            lastInputWeightValueLabel.text = people.last!.date!
            if averageWeight == -9999 {
                predictIn7DaysLabel.text = String(people.last!.weight)
               
            }else if averageWeight == 0 {
                predictIn7DaysLabel.text = String(people.last!.weight)
               
            }else {
                let weightChangeNext7Days = averageWeight * 7 * 0.75
              
                
                
                var weightIn7Days = people.last!.weight + weightChangeNext7Days
               
                
                
                if weightIn7Days < people.last!.weight {
                    //Giam can
                    if(weightIn7Days/people.last!.weight) < 0.88 {
                        weightIn7Days = people.last!.weight * 0.92
                       
                    }
                }else {
                    //Tang can
                    if(people.last!.weight/weightIn7Days) < 0.88 {
                        weightIn7Days = people.last!.weight * 1.08
                      
                    }
                }
                
                weightIn7Days = round(weightIn7Days * 100)/100
            
                
                predictIn7DaysLabel.text = String(weightIn7Days)
             
            }
        }
        
    }
    func caculateAverageWeight() -> Float {
        var sevenPeople = get7DaysBeforePeopleArray()
        if sevenPeople.count >= 2 {
            sevenPeople = sevenPeople.reversed()
            if sevenPeople.first!.date! != sevenPeople.last!.date! {
                let numberOfDays = numberOfDaysBetweenDates(startDate: sevenPeople.first!.date!, endDate: sevenPeople.last!.date!)
                return Float((sevenPeople.last!.weight - sevenPeople.first!.weight)/Float(numberOfDays))
                
            }else {
                return 0
            }
            
        }else {
            return -9999
        }
    }
    
    func numberOfDaysBetweenDates(startDate:String, endDate:String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formatedStartDate = dateFormatter.date(from: startDate)
        let formatedEndDate = dateFormatter.date(from: endDate)
        let difference = formatedEndDate!.timeIntervalSince(formatedStartDate!)
        let differenceInDays = Int(difference/(60 * 60 * 24 ))
        
        return differenceInDays
    }
    
    func get7DaysBeforePeopleArray() -> [Person] {
        var sevenPeople = [Person]()
        if people.count > 0 {
            let sevenDaysBefore = get7DaysBefore()
            for i in people.reversed() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let formatedDate = dateFormatter.date(from: i.date!)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
                
                let stringDate =  formatter.string(from: formatedDate!)
                
                if let intDate = Int(stringDate) {
                    if intDate >= sevenDaysBefore {
                        sevenPeople.append(i)
                    }else {
                        return sevenPeople
                    }
                }
            }
        }
        return sevenPeople
    }
    
    func get7DaysBefore() -> Int {
        let date = people.last!.date!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formatedStartDate = dateFormatter.date(from: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        let sevenDaysBefore = Calendar.current.date(byAdding: .day, value: -6, to: formatedStartDate!)
        
        let sevenDaysBeforeInFormat = formatter.string(from: sevenDaysBefore!)
        
        if let sevenDaysBeforeInFormat = Int(sevenDaysBeforeInFormat) {
            return sevenDaysBeforeInFormat
        }else {
            return -1
        }
        
        
    }
    
    //MARK: - Setup Detail View
    func setDetailView(){
        
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        // add image to Detail View
        let backgroundImage = UIImage(named: "toolCellBackground")
        let backgroundView = UIImageView(image: backgroundImage)
        backgroundView.contentMode = .scaleToFill
        
        
        scrollView.isHidden = true
        self.scrollView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        
        scrollView.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        detailView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        detailView.widthAnchor.constraint(equalToConstant: self.layer.frame.width).isActive = true
        //detailView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        detailView.heightAnchor.constraint(equalToConstant: 750).isActive = true
        
        
        
        
        // add image to Progress View
        let backgroundProgressImage = UIImage(named: "progressBackground")
        let backgroundProgressView = UIImageView(image: backgroundProgressImage)
        backgroundProgressView.contentMode = .scaleToFill
        


        
        self.detailView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 20).isActive = true
        progressView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 12).isActive = true
        progressView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -12).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        
        self.progressView.addSubview(backgroundProgressView)
        backgroundProgressView.translatesAutoresizingMaskIntoConstraints = false
        backgroundProgressView.topAnchor.constraint(equalTo: progressView.topAnchor, constant: 0).isActive = true
        backgroundProgressView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 0).isActive = true
        backgroundProgressView.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 0).isActive = true
        backgroundProgressView.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 0).isActive = true
        
        progressView.addSubview(progressTitleView)
        progressTitleView.translatesAutoresizingMaskIntoConstraints = false
        progressTitleView.topAnchor.constraint(equalTo: progressView.topAnchor, constant: 0).isActive = true
        progressTitleView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 0).isActive = true
        progressTitleView.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 0).isActive = true
        progressTitleView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        detailView.addSubview(predictView)
        predictView.translatesAutoresizingMaskIntoConstraints = false
        predictView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 12).isActive = true
        predictView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 0).isActive = true
        predictView.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 0).isActive = true
        predictView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        predictView.addSubview(predictTitleView)
        predictTitleView.translatesAutoresizingMaskIntoConstraints = false
        predictTitleView.topAnchor.constraint(equalTo: predictView.topAnchor, constant: 0).isActive = true
        predictTitleView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 0).isActive = true
        predictTitleView.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 0).isActive = true
        predictTitleView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        predictTitleView.addSubview(predictNoteButton)
        predictNoteButton.translatesAutoresizingMaskIntoConstraints = false
        predictNoteButton.topAnchor.constraint(equalTo: predictTitleView.topAnchor, constant: 3).isActive = true
        predictNoteButton.trailingAnchor.constraint(equalTo: predictTitleView.trailingAnchor, constant: -8).isActive = true
        predictNoteButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        predictNoteButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        predictNoteButton.addTarget(self, action: #selector(showPredictionNote), for: .touchUpInside)
        
        predictTitleView.addSubview(predictTitleLabel)
        predictTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        predictTitleLabel.topAnchor.constraint(equalTo: predictTitleView.topAnchor, constant: 2).isActive = true
        predictTitleLabel.leadingAnchor.constraint(equalTo: predictTitleView.leadingAnchor, constant: 12).isActive = true
        
        
        detailView.addSubview(bmiView)
        bmiView.translatesAutoresizingMaskIntoConstraints = false
        bmiView.topAnchor.constraint(equalTo: predictView.bottomAnchor, constant: 12).isActive = true
        bmiView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 0).isActive = true
        bmiView.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 0).isActive = true
        bmiView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        bmiView.addSubview(bmiTitleView)
        bmiTitleView.translatesAutoresizingMaskIntoConstraints = false
        bmiTitleView.topAnchor.constraint(equalTo: bmiView.topAnchor, constant: 0).isActive = true
        bmiTitleView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 0).isActive = true
        bmiTitleView.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 0).isActive = true
        bmiTitleView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        self.bmiTitleView.addSubview(bmiTitleLabel)
        bmiTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bmiTitleLabel.topAnchor.constraint(equalTo: bmiTitleView.topAnchor, constant: 2).isActive = true
        bmiTitleLabel.leadingAnchor.constraint(equalTo: bmiTitleView.leadingAnchor, constant: 12).isActive = true
        
        self.detailView.addSubview(BMILabel)
        BMILabel.translatesAutoresizingMaskIntoConstraints = false
        BMILabel.topAnchor.constraint(equalTo: bmiView.topAnchor, constant: 28).isActive = true
        BMILabel.centerXAnchor.constraint(equalTo: detailView.centerXAnchor).isActive = true
        
        self.detailView.addSubview(BMIValueLabel)
        BMIValueLabel.translatesAutoresizingMaskIntoConstraints = false
        BMIValueLabel.topAnchor.constraint(equalTo: BMILabel.bottomAnchor, constant: -8).isActive = true
        BMIValueLabel.centerXAnchor.constraint(equalTo: detailView.centerXAnchor).isActive = true
        
       
        
        //Set kgCmStackView
        let kgLabelView = UIView()
        let cmLabelView = UIView()
        
        kgCmStackView = UIStackView(arrangedSubviews: [kgLabelView,cmLabelView])
        kgCmStackView.axis = .vertical
        kgCmStackView.distribution = .fillEqually
        
        self.detailView.addSubview(kgCmStackView)
        kgCmStackView.translatesAutoresizingMaskIntoConstraints = false
        kgCmStackView.topAnchor.constraint(equalTo: BMIValueLabel.bottomAnchor, constant: -14.0).isActive = true
        kgCmStackView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -12.0).isActive = true
        kgCmStackView.widthAnchor.constraint(equalToConstant: 75.0).isActive = true
        kgCmStackView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        self.detailView.addSubview(kgValueLabel)
        kgValueLabel.translatesAutoresizingMaskIntoConstraints = false
        kgValueLabel.topAnchor.constraint(equalTo: kgLabelView.topAnchor, constant: 0.0).isActive = true
        kgValueLabel.leadingAnchor.constraint(equalTo: kgLabelView.leadingAnchor, constant: 0.0).isActive = true

        self.detailView.addSubview(cmValueLabel)
        cmValueLabel.translatesAutoresizingMaskIntoConstraints = false
        cmValueLabel.topAnchor.constraint(equalTo: cmLabelView.topAnchor, constant: 0.0).isActive = true
        cmValueLabel.leadingAnchor.constraint(equalTo: cmLabelView.leadingAnchor, constant: 0.0).isActive = true
        
        
        //Category BMI result
        //Sub view 1
        detailView.addSubview(bmiCategoryView1)
        bmiCategoryView1.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryView1.centerXAnchor.constraint(equalTo: detailView.centerXAnchor).isActive = true
        bmiCategoryView1.topAnchor.constraint(equalTo: cmValueLabel.bottomAnchor, constant: 6).isActive = true
        bmiCategoryView1.widthAnchor.constraint(equalToConstant: self.frame.width - 40).isActive = true
        bmiCategoryView1.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        bmiCategoryView1.addSubview(bmiCategoryView1Label)
        bmiCategoryView1Label.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryView1Label.leadingAnchor.constraint(equalTo: bmiCategoryView1.leadingAnchor, constant: 0).isActive = true
        bmiCategoryView1Label.topAnchor.constraint(equalTo: bmiCategoryView1.topAnchor, constant: 0).isActive = true
        bmiCategoryView1Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bmiCategoryView1Label.widthAnchor.constraint(equalToConstant: (self.frame.width - 40)/2).isActive = true
        
        bmiCategoryView1.addSubview(bmiCategoryValueView1Label)
        bmiCategoryValueView1Label.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryValueView1Label.trailingAnchor.constraint(equalTo: bmiCategoryView1.trailingAnchor, constant: 0).isActive = true
        bmiCategoryValueView1Label.topAnchor.constraint(equalTo: bmiCategoryView1.topAnchor, constant: 0).isActive = true
        bmiCategoryValueView1Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bmiCategoryValueView1Label.widthAnchor.constraint(equalToConstant: ((self.frame.width - 40)/2)-1).isActive = true
        
        //Sub view 2
        detailView.addSubview(bmiCategoryView2)
        bmiCategoryView2.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryView2.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bmiCategoryView2.topAnchor.constraint(equalTo: bmiCategoryView1.bottomAnchor, constant: -1).isActive = true
        bmiCategoryView2.widthAnchor.constraint(equalToConstant: self.frame.width - 40).isActive = true
        bmiCategoryView2.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        bmiCategoryView2.addSubview(bmiCategoryView2Label)
        bmiCategoryView2Label.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryView2Label.leadingAnchor.constraint(equalTo: bmiCategoryView2.leadingAnchor, constant: 0).isActive = true
        bmiCategoryView2Label.topAnchor.constraint(equalTo: bmiCategoryView2.topAnchor, constant: 0).isActive = true
        bmiCategoryView2Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bmiCategoryView2Label.widthAnchor.constraint(equalToConstant: (self.frame.width - 40)/2).isActive = true
        
        bmiCategoryView2.addSubview(bmiCategoryValueView2Label)
        bmiCategoryValueView2Label.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryValueView2Label.trailingAnchor.constraint(equalTo: bmiCategoryView2.trailingAnchor, constant: 0).isActive = true
        bmiCategoryValueView2Label.topAnchor.constraint(equalTo: bmiCategoryView2.topAnchor, constant: 0).isActive = true
        bmiCategoryValueView2Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bmiCategoryValueView2Label.widthAnchor.constraint(equalToConstant: ((self.frame.width - 40)/2)-1).isActive = true
        
        
        //Sub view 3
        detailView.addSubview(bmiCategoryView3)
        bmiCategoryView3.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryView3.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bmiCategoryView3.topAnchor.constraint(equalTo: bmiCategoryView2.bottomAnchor, constant: -1).isActive = true
        bmiCategoryView3.widthAnchor.constraint(equalToConstant: self.frame.width - 40).isActive = true
        bmiCategoryView3.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        bmiCategoryView3.addSubview(bmiCategoryView3Label)
        bmiCategoryView3Label.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryView3Label.leadingAnchor.constraint(equalTo: bmiCategoryView3.leadingAnchor, constant: 0).isActive = true
        bmiCategoryView3Label.topAnchor.constraint(equalTo: bmiCategoryView3.topAnchor, constant: 0).isActive = true
        bmiCategoryView3Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bmiCategoryView3Label.widthAnchor.constraint(equalToConstant: (self.frame.width - 40)/2).isActive = true
        
        bmiCategoryView3.addSubview(bmiCategoryValueView3Label)
        bmiCategoryValueView3Label.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryValueView3Label.trailingAnchor.constraint(equalTo: bmiCategoryView3.trailingAnchor, constant: 0).isActive = true
        bmiCategoryValueView3Label.topAnchor.constraint(equalTo: bmiCategoryView3.topAnchor, constant: 0).isActive = true
        bmiCategoryValueView3Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bmiCategoryValueView3Label.widthAnchor.constraint(equalToConstant: ((self.frame.width - 40)/2)-1).isActive = true
        
        
        //Sub view 4
        detailView.addSubview(bmiCategoryView4)
        bmiCategoryView4.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryView4.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bmiCategoryView4.topAnchor.constraint(equalTo: bmiCategoryView3.bottomAnchor, constant: -1).isActive = true
        bmiCategoryView4.widthAnchor.constraint(equalToConstant: self.frame.width - 40).isActive = true
        bmiCategoryView4.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        bmiCategoryView4.addSubview(bmiCategoryView4Label)
        bmiCategoryView4Label.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryView4Label.leadingAnchor.constraint(equalTo: bmiCategoryView4.leadingAnchor, constant: 0).isActive = true
        bmiCategoryView4Label.topAnchor.constraint(equalTo: bmiCategoryView4.topAnchor, constant: 0).isActive = true
        bmiCategoryView4Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bmiCategoryView4Label.widthAnchor.constraint(equalToConstant: (self.frame.width - 40)/2).isActive = true
        
        bmiCategoryView4.addSubview(bmiCategoryValueView4Label)
        bmiCategoryValueView4Label.translatesAutoresizingMaskIntoConstraints = false
        bmiCategoryValueView4Label.trailingAnchor.constraint(equalTo: bmiCategoryView4.trailingAnchor, constant: 0).isActive = true
        bmiCategoryValueView4Label.topAnchor.constraint(equalTo: bmiCategoryView4.topAnchor, constant: 0).isActive = true
        bmiCategoryValueView4Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bmiCategoryValueView4Label.widthAnchor.constraint(equalToConstant: ((self.frame.width - 40)/2)-1).isActive = true
        
        //End BMI category result
        
        
        self.detailView.addSubview(lineDetailView)
        lineDetailView.translatesAutoresizingMaskIntoConstraints = false
        lineDetailView.topAnchor.constraint(equalTo: kgCmStackView.bottomAnchor, constant: 104.0).isActive = true
        lineDetailView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 32.0).isActive = true
        lineDetailView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -32.0).isActive = true
        lineDetailView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        
        self.detailView.addSubview(riskLabel)
        riskLabel.translatesAutoresizingMaskIntoConstraints = false
        riskLabel.topAnchor.constraint(equalTo: lineDetailView.topAnchor, constant: 8.0).isActive = true
        riskLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.detailView.addSubview(riskValueLabel)
        riskValueLabel.translatesAutoresizingMaskIntoConstraints = false
        riskValueLabel.topAnchor.constraint(equalTo: riskLabel.bottomAnchor, constant: 2.0).isActive = true
        riskValueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        //add image Button
        changeProfileImageButton.isHidden = true
        addSubview(changeProfileImageButton)
        changeProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        changeProfileImageButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        changeProfileImageButton.widthAnchor.constraint(equalToConstant: 104).isActive = true
        
        changeProfileImageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        changeProfileImageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -23).isActive = true
        
        
        //add profile Button
        changeProfileButton.isHidden = true
        addSubview(changeProfileButton)
        changeProfileButton.translatesAutoresizingMaskIntoConstraints = false
        changeProfileButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        changeProfileButton.widthAnchor.constraint(equalToConstant: 104).isActive = true
        
        changeProfileButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        changeProfileButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -23).isActive = true
        changeProfileButton.addTarget(self, action: #selector(editProfileButtonAction), for: .touchUpInside)
    }
    
    @objc func showPredictionNote() {
        delegate?.showPrediction()
    }

    
    func setupWeightPrediction() {
        
        
        let days7PredictionView = UIView()
        let days14PredictionView = UIView()
        let days30PredictionView = UIView()
        
        weightPredictionStackView = UIStackView(arrangedSubviews: [days7PredictionView,days14PredictionView,days30PredictionView])
        weightPredictionStackView.axis = .horizontal
        weightPredictionStackView.distribution = .fillEqually
        
        predictView.addSubview(weightPredictionStackView)
        weightPredictionStackView.translatesAutoresizingMaskIntoConstraints = false
        weightPredictionStackView.topAnchor.constraint(equalTo: predictView.topAnchor, constant: 25).isActive = true
        weightPredictionStackView.leadingAnchor.constraint(equalTo: predictView.leadingAnchor, constant: 0.0).isActive = true
        weightPredictionStackView.trailingAnchor.constraint(equalTo: predictView.trailingAnchor, constant: 0.0).isActive = true
        weightPredictionStackView.bottomAnchor.constraint(equalTo: predictView.bottomAnchor, constant: -50.0).isActive = true
        
        predictView.addSubview(weightTrendLineView1)
        weightTrendLineView1.translatesAutoresizingMaskIntoConstraints = false
        weightTrendLineView1.topAnchor.constraint(equalTo: predictTitleView.bottomAnchor, constant: 5).isActive = true
        weightTrendLineView1.trailingAnchor.constraint(equalTo: days7PredictionView.trailingAnchor, constant: -1).isActive = true
        weightTrendLineView1.widthAnchor.constraint(equalToConstant: 2).isActive = true
        weightTrendLineView1.bottomAnchor.constraint(equalTo: predictView.bottomAnchor, constant: -57.0).isActive = true
        
        predictView.addSubview(weightTrendLineView2)
        weightTrendLineView2.translatesAutoresizingMaskIntoConstraints = false
        weightTrendLineView2.topAnchor.constraint(equalTo: predictTitleView.bottomAnchor, constant: 5).isActive = true
        weightTrendLineView2.trailingAnchor.constraint(equalTo: days14PredictionView.trailingAnchor, constant: -1).isActive = true
        weightTrendLineView2.widthAnchor.constraint(equalToConstant: 2).isActive = true
        weightTrendLineView2.bottomAnchor.constraint(equalTo: predictView.bottomAnchor, constant: -57.0).isActive = true
        
        //add all time
        let currentKgTitleLabelView = UIView()
        let currentKgLabelView = UIView()
        
        predict7DaysStackview = UIStackView(arrangedSubviews: [currentKgTitleLabelView,currentKgLabelView])
        predict7DaysStackview.axis = .vertical
        predict7DaysStackview.distribution = .fillEqually
        
        predictView.addSubview(predict7DaysStackview)
        predict7DaysStackview.translatesAutoresizingMaskIntoConstraints = false
        predict7DaysStackview.topAnchor.constraint(equalTo: days7PredictionView.topAnchor, constant: -6).isActive = true
        predict7DaysStackview.leadingAnchor.constraint(equalTo: days7PredictionView.leadingAnchor, constant: 0.0).isActive = true
        predict7DaysStackview.trailingAnchor.constraint(equalTo: days7PredictionView.trailingAnchor, constant: 0.0).isActive = true
        predict7DaysStackview.bottomAnchor.constraint(equalTo: days7PredictionView.bottomAnchor, constant: 0.0).isActive = true
        
        predictView.addSubview(predictIn7DaysTitleLabel)
        predictIn7DaysTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        predictIn7DaysTitleLabel.bottomAnchor.constraint(equalTo: currentKgTitleLabelView.bottomAnchor, constant: 0.0).isActive = true
        predictIn7DaysTitleLabel.centerXAnchor.constraint(equalTo: currentKgTitleLabelView.centerXAnchor).isActive = true
        
        
        predictView.addSubview(predictIn7DaysLabel)
        predictIn7DaysLabel.translatesAutoresizingMaskIntoConstraints = false
        predictIn7DaysLabel.centerXAnchor.constraint(equalTo: currentKgLabelView.centerXAnchor).isActive = true
        predictIn7DaysLabel.topAnchor.constraint(equalTo: currentKgLabelView.topAnchor, constant: 0).isActive = true
        
        
        //add 7 day time
        let change7DayTitleLabelView = UIView()
        let change7DayLabelView = UIView()
        
        predict14DaysStackview = UIStackView(arrangedSubviews: [change7DayTitleLabelView,change7DayLabelView])
        predict14DaysStackview.axis = .vertical
        predict14DaysStackview.distribution = .fillEqually
        
        predictView.addSubview(predict14DaysStackview)
        predict14DaysStackview.translatesAutoresizingMaskIntoConstraints = false
        predict14DaysStackview.topAnchor.constraint(equalTo: days14PredictionView.topAnchor, constant: -6).isActive = true
        predict14DaysStackview.leadingAnchor.constraint(equalTo: days14PredictionView.leadingAnchor, constant: 0.0).isActive = true
        predict14DaysStackview.trailingAnchor.constraint(equalTo: days14PredictionView.trailingAnchor, constant: 0.0).isActive = true
        predict14DaysStackview.bottomAnchor.constraint(equalTo: days14PredictionView.bottomAnchor, constant: 0.0).isActive = true
        
        predictView.addSubview(predictIn14DaysTitleLabel)
        predictIn14DaysTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        predictIn14DaysTitleLabel.bottomAnchor.constraint(equalTo: change7DayTitleLabelView.bottomAnchor, constant: 0.0).isActive = true
        predictIn14DaysTitleLabel.centerXAnchor.constraint(equalTo: change7DayTitleLabelView.centerXAnchor).isActive = true
        
        
        predictView.addSubview(predictIn14DaysLabel)
        predictIn14DaysLabel.translatesAutoresizingMaskIntoConstraints = false
        predictIn14DaysLabel.centerXAnchor.constraint(equalTo: change7DayLabelView.centerXAnchor).isActive = true
        predictIn14DaysLabel.topAnchor.constraint(equalTo: change7DayLabelView.topAnchor, constant: 0).isActive = true
        
        //add 30 day time
        let change30DayTitleLabelView = UIView()
        let change30DayLabelView = UIView()
        
        predict30DaysStackview = UIStackView(arrangedSubviews: [change30DayTitleLabelView,change30DayLabelView])
        predict30DaysStackview.axis = .vertical
        predict30DaysStackview.distribution = .fillEqually
        
        predictView.addSubview(predict30DaysStackview)
        predict30DaysStackview.translatesAutoresizingMaskIntoConstraints = false
        predict30DaysStackview.topAnchor.constraint(equalTo: days30PredictionView.topAnchor, constant: -6).isActive = true
        predict30DaysStackview.leadingAnchor.constraint(equalTo: days30PredictionView.leadingAnchor, constant: 0.0).isActive = true
        predict30DaysStackview.trailingAnchor.constraint(equalTo: days30PredictionView.trailingAnchor, constant: 0.0).isActive = true
        predict30DaysStackview.bottomAnchor.constraint(equalTo: days30PredictionView.bottomAnchor, constant: 0.0).isActive = true
        
        predictView.addSubview(predictIn30DaysTitleLabel)
        predictIn30DaysTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        predictIn30DaysTitleLabel.bottomAnchor.constraint(equalTo: change30DayTitleLabelView.bottomAnchor, constant: 0.0).isActive = true
        predictIn30DaysTitleLabel.centerXAnchor.constraint(equalTo: change30DayTitleLabelView.centerXAnchor).isActive = true
        
        
        predictView.addSubview(predictIn30DaysLabel)
        predictIn30DaysLabel.translatesAutoresizingMaskIntoConstraints = false
        predictIn30DaysLabel.centerXAnchor.constraint(equalTo: change30DayLabelView.centerXAnchor).isActive = true
        predictIn30DaysLabel.topAnchor.constraint(equalTo: change30DayLabelView.topAnchor, constant: 0).isActive = true
        
        
        //add last input weight.
        predictView.addSubview(lastInputWeightTitleLabel)
        lastInputWeightTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        lastInputWeightTitleLabel.leadingAnchor.constraint(equalTo: predictView.leadingAnchor, constant: 12).isActive = true
        lastInputWeightTitleLabel.topAnchor.constraint(equalTo: predictView.topAnchor, constant: 76).isActive = true
        
        predictView.addSubview(lastInputWeightValueLabel)
        lastInputWeightValueLabel.translatesAutoresizingMaskIntoConstraints = false
        lastInputWeightValueLabel.leadingAnchor.constraint(equalTo: lastInputWeightTitleLabel.trailingAnchor, constant: 2).isActive = true
        lastInputWeightValueLabel.topAnchor.constraint(equalTo: predictView.topAnchor, constant: 76).isActive = true
        
        predictView.addSubview(weightPredictionNoteLabel)
        weightPredictionNoteLabel.translatesAutoresizingMaskIntoConstraints = false
        weightPredictionNoteLabel.leadingAnchor.constraint(equalTo: predictView.leadingAnchor, constant: 8).isActive = true
        weightPredictionNoteLabel.trailingAnchor.constraint(equalTo: predictView.trailingAnchor, constant: -8).isActive = true
        weightPredictionNoteLabel.bottomAnchor.constraint(equalTo: predictView.bottomAnchor, constant: -4).isActive = true
    }
    
    func calculateAndShowBMIValue() {
        let weight = people.last?.weight
        let height = defaults.double(forKey: "height")
        let ftHeight =  defaults.integer(forKey: "ftHeight")
        let inHeight =  defaults.double(forKey: "inHeight")
        
        if var  weight = weight {
            weight = round(weight*100)/100
            var height2 = (height*height)/10000
            if heightUnit == "ft:in" {
                let heightToCm = Double(ftHeight) * 30.48 + inHeight * 2.54
                height2 = (heightToCm*heightToCm)/10000
            }
            
            var BMI = Double(weight) / (height2)
            BMI = round(BMI * 100)/100
            if weightUnit == "lbs" {
                BMI = BMI * 0.45359237
                BMI = round(BMI * 100)/100
            }
    
            BMIValueLabel.text = " \(BMI) "
            kgValueLabel.text = "\(weight) \(weightUnit)"

            
            kgLabel.text = "\(weightUnit)"
            
            if heightUnit == "cm" {
                cmValueLabel.text = "\(height) cm"
            }else if heightUnit == "ft:in" {
                cmValueLabel.text = "\(ftHeight) ft \(inHeight) in"
            }else {
                cmValueLabel.text = "\(height) cm"
            }
            
            bmiCategoryView1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            bmiCategoryView1Label.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            bmiCategoryValueView1Label.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            bmiCategoryView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            bmiCategoryView2Label.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            bmiCategoryValueView2Label.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            bmiCategoryView3.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            bmiCategoryView3Label.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            bmiCategoryValueView3Label.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            bmiCategoryView4.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            bmiCategoryView4Label.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            bmiCategoryValueView4Label.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            
            if BMI <= 18.5 {
                bmiCategoryView1.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                bmiCategoryView1Label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
                bmiCategoryValueView1Label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
                riskValueLabel.text = "Low"
            }else if 18.5 < BMI && BMI <= 25 {
                bmiCategoryView2.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                bmiCategoryView2Label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
                bmiCategoryValueView2Label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
                riskValueLabel.text = "Medium"
            }else if 25 < BMI && BMI <= 30 {
                bmiCategoryView3.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                bmiCategoryView3Label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
                bmiCategoryValueView3Label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
                riskValueLabel.text = "High"
            }else {
                bmiCategoryView4.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                bmiCategoryView4Label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
                bmiCategoryValueView4Label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990749617)
                riskValueLabel.text = "Very high"
            }
            
            
            var targetWeight = defaults.float(forKey: "desizedWeight")
            targetWeight = round(targetWeight*100)/100
            currentWeightlabel.text = "Current weight: \(weight) \(weightUnit)"

            targetWeightlabel.text = "\(targetWeight) \(weightUnit)"
            if let iw = people.first?.weight {
                initWeightlabel.text = "\(iw) \(weightUnit)"
                //set chart and percent
                if iw > targetWeight {
                    // Loss weihgt
                    if (targetWeight <= weight) {
                        if(iw >= weight) {
                            var percent = ((iw - weight)/(iw - targetWeight)) * 100
                            completedRate = Double((iw - weight)/(iw - targetWeight))
                            startChart()
                            percent = round(percent * 100)/100
                            percentlabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
                            percentlabel.text = "\(percent) %"
                        }else {
                            percentlabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
                            percentlabel.text = "0.0 % "
                            completedRate = 0
                            startChart()
                        }
                    }else {
                        percentlabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
                        percentlabel.text = "100.0 % "
                        completedRate = 1
                        startChart()
                    }
                }else if iw < targetWeight {
                    if (targetWeight >= weight) {
                        if(iw <= weight) {
                            var percent = ((weight - iw)/(targetWeight - iw)) * 100
                            completedRate = Double((weight - iw)/(targetWeight - iw))
                            startChart()
                            percent = round(percent * 100)/100
                            percentlabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
                            percentlabel.text = "\(percent) %"
                        }else {
                            completedRate = 0
                            percentlabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
                            percentlabel.text = "0.0 % "
                            startChart()
                        }
                    }else {
                        percentlabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
                        percentlabel.text = "100.0 % "
                        completedRate = 1
                        startChart()
                    }
                }else {
                    percentlabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
                    percentlabel.text = "100.0 %"
                    completedRate = 1
                    startChart()
                }
               
            }
        }
    }
    
    //MARK: - Setup Input View
    func setInputView(){
        
        

        profileView.layer.cornerRadius = 15.0
        profileView.clipsToBounds = true
        

        addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -42.0).isActive = true
        profileView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 350.0).isActive = true
        profileView.widthAnchor.constraint(equalToConstant: self.frame.width - 48.0).isActive = true
        
        //add round to input view
        addSubview(roundView)
        roundView.translatesAutoresizingMaskIntoConstraints = false
        roundView.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 16.0).isActive = true
         roundView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 16.0).isActive = true
        roundView.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
        roundView.widthAnchor.constraint(equalToConstant:  12.0).isActive = true
        
        //add profile label
        addSubview(profileLabel)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 12.0).isActive = true
        profileLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        
        
        //add height label
        addSubview(heightLabel)
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 12.0).isActive = true
        heightLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 48.0).isActive = true
        heightLabel.widthAnchor.constraint(equalToConstant:  150.0).isActive = true
        
        
        //add height textField
        addSubview(inputHeightTextfield)
        inputHeightTextfield.translatesAutoresizingMaskIntoConstraints = false
        inputHeightTextfield.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 8.0).isActive = true
        inputHeightTextfield.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 45.0).isActive = true
        inputHeightTextfield.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -45.0).isActive = true


        
        //add cm label
        addSubview(cmLabel)
        cmLabel.translatesAutoresizingMaskIntoConstraints = false
        cmLabel.topAnchor.constraint(equalTo: inputHeightTextfield.bottomAnchor, constant: 3.0).isActive = true
        cmLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -24.0).isActive = true
        cmLabel.widthAnchor.constraint(equalToConstant:  50.0).isActive = true
        
        //add ft height textfield
        inputFtHeightTextfield.isHidden = true
        addSubview(inputFtHeightTextfield)
        inputFtHeightTextfield.translatesAutoresizingMaskIntoConstraints = false
        inputFtHeightTextfield.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 8.0).isActive = true
        inputFtHeightTextfield.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 45.0).isActive = true
        inputFtHeightTextfield.widthAnchor.constraint(equalToConstant: self.layer.frame.height/4 - 60).isActive = true
        
        //add ft label
        ftLabel.isHidden = true
        addSubview(ftLabel)
        ftLabel.translatesAutoresizingMaskIntoConstraints = false
        ftLabel.topAnchor.constraint(equalTo: inputFtHeightTextfield.bottomAnchor, constant: 3.0).isActive = true
        ftLabel.leadingAnchor.constraint(equalTo: inputFtHeightTextfield.trailingAnchor, constant: 0.0).isActive = true
        ftLabel.widthAnchor.constraint(equalToConstant:  30.0).isActive = true
        
        
        //add in height textfield
        inputInHeightTextfield.isHidden = true
        addSubview(inputInHeightTextfield)
        inputInHeightTextfield.translatesAutoresizingMaskIntoConstraints = false
        inputInHeightTextfield.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 8.0).isActive = true
        inputInHeightTextfield.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -45.0).isActive = true
        inputInHeightTextfield.widthAnchor.constraint(equalToConstant: self.layer.frame.height/4 - 60).isActive = true
        
        //add in label
        inLabel.isHidden = true
        addSubview(inLabel)
        inLabel.translatesAutoresizingMaskIntoConstraints = false
        inLabel.topAnchor.constraint(equalTo: inputFtHeightTextfield.bottomAnchor, constant: 3.0).isActive = true
        inLabel.leadingAnchor.constraint(equalTo: inputInHeightTextfield.trailingAnchor, constant: 0.0).isActive = true
        inLabel.widthAnchor.constraint(equalToConstant:  30.0).isActive = true
        
        
        //add targetWeightLabel
        addSubview(targetWeightLabel)
        targetWeightLabel.translatesAutoresizingMaskIntoConstraints = false
        targetWeightLabel.topAnchor.constraint(equalTo: cmLabel.bottomAnchor, constant: 12.0).isActive = true
        targetWeightLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 48.0).isActive = true
        targetWeightLabel.widthAnchor.constraint(equalToConstant:  150.0).isActive = true
        
        //add desired weight
        addSubview(desiredWeightTextfield)
        desiredWeightTextfield.translatesAutoresizingMaskIntoConstraints = false
        desiredWeightTextfield.topAnchor.constraint(equalTo: targetWeightLabel.bottomAnchor, constant: 8.0).isActive = true
        desiredWeightTextfield.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 45.0).isActive = true
        desiredWeightTextfield.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -45.0).isActive = true
        
        
        //add kg label
        addSubview(kgLabel)
        kgLabel.translatesAutoresizingMaskIntoConstraints = false
        kgLabel.topAnchor.constraint(equalTo: desiredWeightTextfield.bottomAnchor, constant: 3.0).isActive = true
        kgLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -24.0).isActive = true
        kgLabel.widthAnchor.constraint(equalToConstant:  50.0).isActive = true
        
        //add "let's go" button
        addSubview(enterButton)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        enterButton.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -72).isActive = true
        enterButton.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 56).isActive = true
        enterButton.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -56).isActive = true
        enterButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -12).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 18).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -18).isActive = true
    }
    
    //MARK: - "Let's go" Button Action
    @objc func buttonAction(sender: UIButton!) {
        var isHeightOK = false
        var isWeightOk = false
        do {
            try people = context.fetch(request)
        } catch  {
            print("Error to fetch Item data")
        }
        
        if inputHeightTextfield.text != ""
        {
            if heightUnit == "cm" {
                if var h = inputHeightTextfield.text {
                    h = h.replacingOccurrences(of: ",", with: ".")
                    if let h = Float(h) {
                        if h >= 30 && h <= 300 {
                            isHeightOK = true
                        }
                    }else {
                        print("height wrong !")
                    }
                }
            }else if heightUnit == "ft:in" {
                if let ftH = inputFtHeightTextfield.text , var inH = inputInHeightTextfield.text {
                    inH = inH.replacingOccurrences(of: ",", with: ".")
                    if let ftH = Float(ftH) ,let inH = Float(inH) {
                        if ftH > 0 && ftH < 11 && inH >= 0 && inH <= 20 {
                            isHeightOK = true
                        }
                    }else {
                        print("height wrong !")
                    }

                }
            }else {
                if var h = inputHeightTextfield.text {
                    h = h.replacingOccurrences(of: ",", with: ".")
                    if let h = Float(h) {
                        if h >= 30 && h <= 300 {
                            isHeightOK = true
                        }
                    }else {
                        print("height wrong !")
                    }
                }
            }
            
        }else {
            print("Blank")
        }
        
        if desiredWeightTextfield.text != ""
        {
            if var w = desiredWeightTextfield.text {
                w = w.replacingOccurrences(of: ",", with: ".")
                if let w = Float(w) {
                    if w >= 1 && w <= 400 {
                        isWeightOk = true
                    }
                }else {
                    print("weight wrong !")
                }
            }
        }else {
            print("Blank")
        }
        
        if isHeightOK , isWeightOk {
            if(people.count > 0) {
                dismissKeyboard()
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                               animations: {
                                
                            
                                self.scrollView.alpha = 1
                                self.changeProfileButton.alpha = 1
                                self.changeProfileImageButton.alpha = 1
                                self.profileView.alpha = 0
                                self.cmLabel.alpha = 0
                                self.ftLabel.alpha = 0
                                self.inLabel.alpha = 0
                                self.profileLabel.alpha = 0
                                self.kgLabel.alpha = 0
                                self.heightLabel.alpha = 0
                                self.targetWeightLabel.alpha = 0
                                self.inputHeightTextfield.alpha = 0
                                self.inputFtHeightTextfield.alpha = 0
                                self.inputInHeightTextfield.alpha = 0
                                self.desiredWeightTextfield.alpha = 0
                                self.roundView.alpha = 0
                                self.enterButton.alpha = 0
                                self.layoutIfNeeded()
                                
                },  completion: {(_ completed: Bool) -> Void in
                    self.scrollView.isHidden = false
                    self.changeProfileButton.isHidden = false
                    self.changeProfileImageButton.isHidden  = false
                    
                    self.profileView.isHidden = true
                    self.cmLabel.isHidden = true
                    self.ftLabel.isHidden = true
                    self.inLabel.isHidden = true
                    self.profileLabel.isHidden = true
                    self.kgLabel.isHidden = true
                    self.inputHeightTextfield.isHidden = true
                    self.inputFtHeightTextfield.isHidden = true
                    self.inputInHeightTextfield.isHidden = true
                    self.desiredWeightTextfield.isHidden = true
                    self.targetWeightLabel.isHidden = true
                    self.roundView.isHidden = true
                    self.enterButton.isHidden = true
                    self.layoutIfNeeded()
                })
                defaults.set(true, forKey: "wasShowInput")
                defaults.set(Double(inputHeightTextfield.text!), forKey: "height")
                defaults.set(Int(inputFtHeightTextfield.text!), forKey: "ftHeight")
                defaults.set(Double(inputInHeightTextfield.text!), forKey: "inHeight")
                defaults.set(Double(desiredWeightTextfield.text!), forKey: "desizedWeight")
                startChart()
                calculateAndShowBMIValue()
                delegate?.enterDesiredWeight(dWeight: Double(desiredWeightTextfield.text!)!)
                
            }else {
                delegate?.enterWeightFirst()
            }
           
        }else {
            delegate?.checkIfWrongInputToolCell()
        }
      
    }


    //MARK: - editProfile Button Action
    @objc func editProfileButtonAction() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                       animations: {
                        
                        self.scrollView.alpha = 0
                        self.changeProfileButton.alpha = 0
                        self.changeProfileImageButton.alpha = 0
                        if self.heightUnit == "cm" {
                            self.cmLabel.alpha = 1
                            self.inputHeightTextfield.alpha = 1
                        }else if self.heightUnit == "ft:in" {
                            self.ftLabel.alpha = 1
                            self.inLabel.alpha = 1
                            self.inputFtHeightTextfield.alpha = 1
                            self.inputInHeightTextfield.alpha = 1
                        }else {
                            self.cmLabel.alpha = 1
                            self.inputHeightTextfield.alpha = 1
                        }
                        self.profileView.alpha = 1
                        
                        self.profileLabel.alpha = 1
                        self.kgLabel.alpha = 1
                        self.heightLabel.alpha = 1
                        self.targetWeightLabel.alpha = 1
                        
                        self.desiredWeightTextfield.alpha = 1
                        self.roundView.alpha = 1
                        self.enterButton.alpha = 1
                        self.layoutIfNeeded()
                    
                        
            },  completion: {(_ completed: Bool) -> Void in
                self.scrollView.isHidden = true
                self.changeProfileButton.isHidden = true
                self.changeProfileImageButton.isHidden = true
                
                if self.heightUnit == "cm" {
                    self.cmLabel.isHidden = false
                    self.inputHeightTextfield.isHidden = false
                }else if self.heightUnit == "ft:in" {
                    self.ftLabel.isHidden = false
                    self.inLabel.isHidden = false
                    self.inputFtHeightTextfield.isHidden = false
                    self.inputInHeightTextfield.isHidden = false
                }else {
                    self.cmLabel.isHidden = false
                    self.inputHeightTextfield.isHidden = false
                }
                
                self.profileView.isHidden = false
                self.profileLabel.isHidden = false
                self.kgLabel.isHidden = false
                self.desiredWeightTextfield.isHidden = false
                self.roundView.isHidden = false
                self.enterButton.isHidden = false
                self.heightLabel.isHidden = false
                self.targetWeightLabel.isHidden = false
                
                self.desiredWeightTextfield.text! = String(self.defaults.double(forKey: "desizedWeight"))
                self.inputHeightTextfield.text! = String(self.defaults.double(forKey: "height"))
                
                self.layoutIfNeeded()
                
            })
    }
    
    func setProfileViewPosition() {
        self.scrollView.isHidden = false
        self.changeProfileButton.isHidden = false
        self.changeProfileImageButton.isHidden = false
        
        
        if self.heightUnit == "cm" {
            self.cmLabel.isHidden = false
            self.inputHeightTextfield.isHidden = false
        }else if self.heightUnit == "ft:in" {
            self.ftLabel.isHidden = false
            self.inLabel.isHidden = false
            self.inputFtHeightTextfield.isHidden = false
            self.inputInHeightTextfield.isHidden = false
        }else {
            self.cmLabel.isHidden = false
            self.inputHeightTextfield.isHidden = false
        }
        
        self.profileView.isHidden = true
        self.profileLabel.isHidden = true
        self.kgLabel.isHidden = true
        self.desiredWeightTextfield.isHidden = true
        self.roundView.isHidden = true
        self.enterButton.isHidden = true
        self.heightLabel.isHidden = true
        self.targetWeightLabel.isHidden = true
        
        self.layoutIfNeeded()
    }
}
