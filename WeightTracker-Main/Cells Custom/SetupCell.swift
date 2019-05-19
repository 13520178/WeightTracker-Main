//
//  SetupCell.swift
//  WeightTracker-Main
//
//  Created by Phan Nhat Dang on 3/17/19.
//  Copyright © 2019 Phan Nhat Dang. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

protocol SetupCellDelegate {
    func sentMail()
    func isScrollable(scroll:Bool)
    func setWeightUnit(indexOfWeightUnit: Int)
    func setHeightUnit(indexOfHeightUnit: Int)
    func deleteAllRecords()
    func showUpgradeView()
    
}

class SetupCell: BaseCell,MFMailComposeViewControllerDelegate {
    
    //MARK: - Main View Variable
    var delegate: SetupCellDelegate?
    var contactStackView: UIStackView!
    let defaults = UserDefaults.standard
    var indexWeightUnit = -1
    var indexHeightUnit = -1
    
    let scrollView : UIScrollView = {
        let sc = UIScrollView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.contentSize.height = 650
        return sc
    }()
    
    let mainView: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return v
    }()
    
    
    let facebookButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        let fbImage = UIImage(named: "facebookIcon")
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.setImage(fbImage, for: UIControl.State.normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        
        return button
    }()
    
    let gmailButton: UIButton = {
        let button = UIButton()
        let fbImage = UIImage(named: "emailIcon")
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.setImage(fbImage, for: UIControl.State.normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return button
    }()
    
    let savingMoneyButton: UIButton = {
        let button = UIButton()
        let fbImage = UIImage(named: "savingMoneyIcon")
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.setImage(fbImage, for: UIControl.State.normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        button.clipsToBounds = true
        return button
    }()
    
    let weChartProButton: UIButton = {
        let button = UIButton()
        let fbImage = UIImage(named: "weChartPro")
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.setImage(fbImage, for: UIControl.State.normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    let lineAboveWeightUnitView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    let lineFirstView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    let lineSecondView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    let lineThirdView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    let lineAboveWeChartProView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    let settingView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    let upgradeView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    let contactView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    let otherAppView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    let weChartProView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "WeChart"
        label.font = UIFont.systemFont(ofSize:30, weight: UIFont.Weight.medium)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    let appVersionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version: 1.2.3"
        label.font = UIFont.systemFont(ofSize:13, weight: UIFont.Weight.light)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    let appCopyrightLabel: UILabel = {
        let label = UILabel()
        label.text = "Copyright © 2019 PhanDang"
        label.font = UIFont.systemFont(ofSize:13, weight: UIFont.Weight.light)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    let settingLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize:20, weight: UIFont.Weight.medium)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    let contactUsLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact me"
        label.font = UIFont.systemFont(ofSize:20, weight: UIFont.Weight.medium)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    let otherAppLabel: UILabel = {
        let label = UILabel()
        label.text = "My other apps"
        label.font = UIFont.systemFont(ofSize:20, weight: UIFont.Weight.medium)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    let savingMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = "Saving Money SV"
        label.font = UIFont.systemFont(ofSize:16, weight: UIFont.Weight.medium)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    let savingMoneyDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Great way to calculate savings!"
        label.font = UIFont.systemFont(ofSize:13, weight: UIFont.Weight.light)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()
    
    let upgradeToProLabel: UILabel = {
        let label = UILabel()
        label.text = "Upgrade to Pro"
        label.font = UIFont.systemFont(ofSize:20, weight: UIFont.Weight.light)
        label.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    let upgradeImageView: UIImageView = {
        let upgradeView = UIImageView()
        upgradeView.image = UIImage(named: "upgrade")
        return upgradeView
    }()
    let weChartProLabel: UILabel = {
        let label = UILabel()
        label.text = "WeChart Pro"
        label.font = UIFont.systemFont(ofSize:16, weight: UIFont.Weight.medium)
        label.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    let weightUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight unit"
        label.font = UIFont.systemFont(ofSize:20, weight: UIFont.Weight.light)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    let segmentOfCharts:UISegmentedControl = {
        let sm = UISegmentedControl (items: ["One","Two"])
        sm.selectedSegmentIndex = 0
        sm.setTitle("kg", forSegmentAt: 0)
        sm.setTitle("lbs", forSegmentAt: 1)
        sm.tintColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        return sm
    }()
    
    // heightUnitLabel
    
    
    let heightUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "Height unit"
        label.font = UIFont.systemFont(ofSize:20, weight: UIFont.Weight.light)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    let heightSegmentOfCharts:UISegmentedControl = {
        let sm = UISegmentedControl (items: ["One","Two"])
        sm.selectedSegmentIndex = 0
        sm.setTitle("cm", forSegmentAt: 0)
        sm.setTitle("ft", forSegmentAt: 1)
        sm.tintColor = #colorLiteral(red: 0.5320518613, green: 0.2923432589, blue: 1, alpha: 1)
        return sm
    }()
    
    let resetAllDataButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("Reset all records", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btn.clipsToBounds = true
        return btn
    }()
    
    //MARK: - setUpView()
    override func setUpView() {
        super.setUpView()
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        if defaults.integer(forKey: "indexWeightUnit") == 0 {
            segmentOfCharts.selectedSegmentIndex = 0
        }else if defaults.integer(forKey: "indexWeightUnit") == 1  {
            segmentOfCharts.selectedSegmentIndex = 1
        }else {
            segmentOfCharts.selectedSegmentIndex = 0
        }
        
        if defaults.integer(forKey: "indexHeightUnit") == 0 {
            heightSegmentOfCharts.selectedSegmentIndex = 0
        }else if defaults.integer(forKey: "indexHeightUnit") == 1  {
            heightSegmentOfCharts.selectedSegmentIndex = 1
        }else {
            heightSegmentOfCharts.selectedSegmentIndex = 0
        }
        setupSetupView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(openSavingMoneySVApp))
        otherAppView.addGestureRecognizer(tap)
        
        let upgradeTap = UITapGestureRecognizer(target: self, action: #selector(upgradeProAction))
        upgradeView.addGestureRecognizer(upgradeTap)
        
        let weChartProTap = UITapGestureRecognizer(target: self, action: #selector(upgradeProAction))
        weChartProView.addGestureRecognizer(weChartProTap)
        

    }
    
    //MARK: - setupSetupView()
    func setupSetupView() {
   
        // add image to Detail View
        let backgroundImage = UIImage(named: "toolCellBackground")
        let backgroundView = UIImageView(image: backgroundImage)
        backgroundView.contentMode = .scaleToFill
        
        self.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
     
        scrollView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        mainView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        mainView.widthAnchor.constraint(equalToConstant: self.layer.frame.width).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 650).isActive = true
       
        
        mainView.addSubview(appNameLabel)
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12).isActive = true
        appNameLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true

        mainView.addSubview(appVersionLabel)
        appVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        appVersionLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: -4).isActive = true
        appVersionLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        
        self.addSubview(appCopyrightLabel)
        appCopyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        appCopyrightLabel.topAnchor.constraint(equalTo: appVersionLabel.bottomAnchor, constant: 0).isActive = true
        appCopyrightLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        

        
        mainView.addSubview(lineFirstView)
        lineFirstView.translatesAutoresizingMaskIntoConstraints = false
        lineFirstView.topAnchor.constraint(equalTo: appCopyrightLabel.bottomAnchor, constant: 8.0).isActive = true
        lineFirstView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        lineFirstView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        lineFirstView.widthAnchor.constraint(equalToConstant: self.layer.frame.width - 32).isActive = true
        

        mainView.addSubview(settingLabel)
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        settingLabel.topAnchor.constraint(equalTo: lineFirstView.bottomAnchor, constant: 8).isActive = true
        settingLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8).isActive = true
        
        mainView.addSubview(settingView)
        settingView.translatesAutoresizingMaskIntoConstraints = false
        settingView.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 4.0).isActive = true
        settingView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        settingView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        settingView.widthAnchor.constraint(equalToConstant: self.layer.frame.width).isActive = true
        
        settingView.addSubview(upgradeView)
        upgradeView.translatesAutoresizingMaskIntoConstraints = false
        upgradeView.topAnchor.constraint(equalTo: settingView.topAnchor, constant: 0).isActive = true
        upgradeView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        upgradeView.heightAnchor.constraint(equalToConstant: 37).isActive = true
        upgradeView.widthAnchor.constraint(equalToConstant: self.layer.frame.width).isActive = true
        
        
        
        settingView.addSubview(lineAboveWeightUnitView)
        lineAboveWeightUnitView.translatesAutoresizingMaskIntoConstraints = false
        lineAboveWeightUnitView.topAnchor.constraint(equalTo: settingView.topAnchor, constant: 38).isActive = true
        lineAboveWeightUnitView.widthAnchor.constraint(equalToConstant: self.layer.frame.width ).isActive = true
        lineAboveWeightUnitView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        lineAboveWeightUnitView.centerXAnchor.constraint(equalTo: settingView.centerXAnchor).isActive = true
        
        
        settingView.addSubview(upgradeToProLabel)
        upgradeToProLabel.translatesAutoresizingMaskIntoConstraints = false
        upgradeToProLabel.topAnchor.constraint(equalTo: settingView.topAnchor, constant: 8).isActive = true
        upgradeToProLabel.leadingAnchor.constraint(equalTo: settingView.leadingAnchor, constant: 48).isActive = true
        
        settingView.addSubview(upgradeImageView)
        upgradeImageView.translatesAutoresizingMaskIntoConstraints = false
        upgradeImageView.topAnchor.constraint(equalTo: settingView.topAnchor, constant: 4).isActive = true
        upgradeImageView.leadingAnchor.constraint(equalTo: settingView.leadingAnchor, constant: 8).isActive = true
        upgradeImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        upgradeImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
       
        
        settingView.addSubview(weightUnitLabel)
        weightUnitLabel.translatesAutoresizingMaskIntoConstraints = false
        weightUnitLabel.topAnchor.constraint(equalTo: settingView.topAnchor, constant: 48).isActive = true
        weightUnitLabel.leadingAnchor.constraint(equalTo: settingView.leadingAnchor, constant: 16).isActive = true
        
        settingView.addSubview(lineThirdView)
        lineThirdView.translatesAutoresizingMaskIntoConstraints = false
        lineThirdView.topAnchor.constraint(equalTo: settingView.topAnchor, constant: 78).isActive = true
        lineThirdView.widthAnchor.constraint(equalToConstant: self.layer.frame.width - 24).isActive = true
        lineThirdView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        lineThirdView.centerXAnchor.constraint(equalTo: settingView.centerXAnchor).isActive = true
        
        settingView.addSubview(heightUnitLabel)
        heightUnitLabel.translatesAutoresizingMaskIntoConstraints = false
        heightUnitLabel.topAnchor.constraint(equalTo: weightUnitLabel.bottomAnchor, constant: 14).isActive = true
        heightUnitLabel.leadingAnchor.constraint(equalTo: settingView.leadingAnchor, constant: 16).isActive = true
        
        
        
        settingView.addSubview(resetAllDataButton)
        resetAllDataButton.translatesAutoresizingMaskIntoConstraints = false
        resetAllDataButton.topAnchor.constraint(equalTo: heightUnitLabel.bottomAnchor, constant: 9).isActive = true
        resetAllDataButton.leadingAnchor.constraint(equalTo: settingView.leadingAnchor, constant: -1).isActive = true
        resetAllDataButton.trailingAnchor.constraint(equalTo: settingView.trailingAnchor, constant: 1).isActive = true
        resetAllDataButton.bottomAnchor.constraint(equalTo: settingView.bottomAnchor, constant: 1).isActive = true
        resetAllDataButton.addTarget(self, action: #selector(deleteAllRecord), for: .touchUpInside)

        
        
        settingView.addSubview(segmentOfCharts)
        segmentOfCharts.translatesAutoresizingMaskIntoConstraints = false
        segmentOfCharts.topAnchor.constraint(equalTo: settingView.topAnchor, constant: 45).isActive = true
        segmentOfCharts.trailingAnchor.constraint(equalTo: settingView.trailingAnchor, constant: -12).isActive = true
        segmentOfCharts.heightAnchor.constraint(equalToConstant: 28).isActive = true
        segmentOfCharts.widthAnchor.constraint(equalToConstant: 80).isActive = true
        segmentOfCharts.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        
        settingView.addSubview(heightSegmentOfCharts)
        heightSegmentOfCharts.translatesAutoresizingMaskIntoConstraints = false
        heightSegmentOfCharts.topAnchor.constraint(equalTo: weightUnitLabel.bottomAnchor, constant: 13).isActive = true
        heightSegmentOfCharts.trailingAnchor.constraint(equalTo: settingView.trailingAnchor, constant: -12).isActive = true
        heightSegmentOfCharts.heightAnchor.constraint(equalToConstant: 28).isActive = true
        heightSegmentOfCharts.widthAnchor.constraint(equalToConstant: 80).isActive = true
        heightSegmentOfCharts.addTarget(self, action: #selector(heightSegmentedValueChanged(_:)), for: .valueChanged)
        
        mainView.addSubview(lineSecondView)
        lineSecondView.translatesAutoresizingMaskIntoConstraints = false
        lineSecondView.topAnchor.constraint(equalTo: settingView.bottomAnchor, constant: 0.0).isActive = true
        lineSecondView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        lineSecondView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        lineSecondView.widthAnchor.constraint(equalToConstant: self.layer.frame.width).isActive = true
    
        
        mainView.addSubview(contactUsLabel)
        contactUsLabel.translatesAutoresizingMaskIntoConstraints = false
        contactUsLabel.topAnchor.constraint(equalTo: lineSecondView.bottomAnchor, constant: 24).isActive = true
        contactUsLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8).isActive = true
        
        
        mainView.addSubview(contactView)
        contactView.translatesAutoresizingMaskIntoConstraints = false
        contactView.topAnchor.constraint(equalTo: contactUsLabel.bottomAnchor, constant: 4).isActive = true
        contactView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        contactView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        contactView.widthAnchor.constraint(equalToConstant: self.layer.frame.width).isActive = true
        
        mainView.addSubview(otherAppLabel)
        otherAppLabel.translatesAutoresizingMaskIntoConstraints = false
        otherAppLabel.topAnchor.constraint(equalTo: contactView.bottomAnchor, constant: 24).isActive = true
        otherAppLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8).isActive = true
        
        mainView.addSubview(otherAppView)
        otherAppView.translatesAutoresizingMaskIntoConstraints = false
        otherAppView.topAnchor.constraint(equalTo: otherAppLabel.bottomAnchor, constant: 4).isActive = true
        otherAppView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        otherAppView.heightAnchor.constraint(equalToConstant: 75.0).isActive = true
        otherAppView.widthAnchor.constraint(equalToConstant: self.layer.frame.width).isActive = true
        
        mainView.addSubview(savingMoneyButton)
        savingMoneyButton.translatesAutoresizingMaskIntoConstraints = false
        savingMoneyButton.topAnchor.constraint(equalTo: otherAppView.topAnchor , constant: 6).isActive = true
        savingMoneyButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16).isActive = true
        savingMoneyButton.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        savingMoneyButton.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        savingMoneyButton.addTarget(self, action: #selector(openSavingMoneySVApp), for: .touchUpInside)
        
        
        mainView.addSubview(savingMoneyLabel)
        savingMoneyLabel.translatesAutoresizingMaskIntoConstraints = false
        savingMoneyLabel.topAnchor.constraint(equalTo: otherAppView.topAnchor, constant: 16).isActive = true
        savingMoneyLabel.leadingAnchor.constraint(equalTo: savingMoneyButton.trailingAnchor, constant: 16).isActive = true
        
        mainView.addSubview(savingMoneyDetailLabel)
        savingMoneyDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        savingMoneyDetailLabel.topAnchor.constraint(equalTo: savingMoneyLabel.bottomAnchor, constant: 4).isActive = true
        savingMoneyDetailLabel.leadingAnchor.constraint(equalTo: savingMoneyButton.trailingAnchor, constant: 16).isActive = true
        
        mainView.addSubview(lineAboveWeChartProView)
        lineAboveWeChartProView.translatesAutoresizingMaskIntoConstraints = false
        lineAboveWeChartProView.topAnchor.constraint(equalTo: otherAppView.topAnchor , constant: 75).isActive = true
        lineAboveWeChartProView.centerXAnchor.constraint(equalTo: otherAppView.centerXAnchor).isActive = true
        lineAboveWeChartProView.widthAnchor.constraint(equalToConstant: self.layer.frame.width ).isActive = true
        lineAboveWeChartProView.heightAnchor.constraint(equalToConstant: 1 ).isActive = true
        
        mainView.addSubview(weChartProView)
        weChartProView.translatesAutoresizingMaskIntoConstraints = false
        weChartProView.topAnchor.constraint(equalTo: otherAppView.topAnchor , constant: 76).isActive = true
        weChartProView.centerXAnchor.constraint(equalTo: otherAppView.centerXAnchor).isActive = true
        weChartProView.widthAnchor.constraint(equalToConstant: self.layer.frame.width ).isActive = true
        weChartProView.heightAnchor.constraint(equalToConstant: 75 ).isActive = true
        
        weChartProView.addSubview(weChartProButton)
        weChartProButton.translatesAutoresizingMaskIntoConstraints = false
        weChartProButton.topAnchor.constraint(equalTo: weChartProView.topAnchor , constant: 6).isActive = true
        weChartProButton.leadingAnchor.constraint(equalTo: weChartProView.leadingAnchor, constant: 16).isActive = true
        weChartProButton.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        weChartProButton.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        weChartProButton.addTarget(self, action: #selector(upgradeProAction), for: .touchUpInside)
        
        weChartProView.addSubview(weChartProLabel)
        weChartProLabel.translatesAutoresizingMaskIntoConstraints = false
        weChartProLabel.centerYAnchor.constraint(equalTo: weChartProView.centerYAnchor).isActive = true
        weChartProLabel.leadingAnchor.constraint(equalTo: weChartProView.leadingAnchor, constant: 100).isActive = true
        
        //Contact us StackView
        let facebookView = UIView()
        let gmailView = UIView()
        
        contactStackView = UIStackView(arrangedSubviews: [facebookView,gmailView])
        contactStackView.axis = .horizontal
        contactStackView.distribution = .fillEqually
        
        mainView.addSubview(contactStackView)
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.topAnchor.constraint(equalTo: contactView.topAnchor, constant: 0.0).isActive = true
        contactStackView.leadingAnchor.constraint(equalTo: contactView.leadingAnchor, constant: 32).isActive = true
        contactStackView.trailingAnchor.constraint(equalTo: contactView.trailingAnchor, constant: -32).isActive = true
        contactStackView.bottomAnchor.constraint(equalTo: contactView.bottomAnchor, constant: 0.0).isActive = true
        
        mainView.addSubview(facebookButton)
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.centerXAnchor.constraint(equalTo: facebookView.centerXAnchor).isActive = true
        facebookButton.centerYAnchor.constraint(equalTo: facebookView.centerYAnchor).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        facebookButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        facebookButton.addTarget(self, action: #selector(openMyFacebook), for: .touchUpInside)

        
        mainView.addSubview(gmailButton)
        gmailButton.translatesAutoresizingMaskIntoConstraints = false
        gmailButton.centerXAnchor.constraint(equalTo: gmailView.centerXAnchor).isActive = true
        gmailButton.centerYAnchor.constraint(equalTo: gmailView.centerYAnchor).isActive = true
        gmailButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        gmailButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        gmailButton.addTarget(self, action: #selector(openMail), for: .touchUpInside)

        
    }
    
   @objc func deleteAllRecord() {
        delegate?.deleteAllRecords()
    }
    
   
    @objc func openSavingMoneySVApp() {
        if let url = URL(string: "https://itunes.apple.com/us/app/saving-money-sv/id1437390099?l=vi&mt=8&fbclid=IwAR03K9tS0qYDVX9BV5cGLzKgZJn4zg71Xi6KMmWX5_aG-WesCq_4ASJp7CU"),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func upgradeProAction() {
      print("OK version")
        delegate?.showUpgradeView()
    }
    
    
    @objc func openMyFacebook() {
        let Username =  "100004649166180"
        let appURL = URL(string: "fb://profile?app_scoped_user_id=\(Username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: "https://facebook.com/\(Username)")!
            application.open(webURL)
        }
    }
    
    @objc func openMail() {
        delegate?.sentMail()
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!){
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 0 {
            defaults.set(0, forKey: "indexWeightUnit")
            indexWeightUnit = 0
        }else {
            defaults.set(1, forKey: "indexWeightUnit")
            indexWeightUnit = 1
        }
        
        delegate?.setWeightUnit(indexOfWeightUnit: sender.selectedSegmentIndex)
        
    }
    
    @objc func heightSegmentedValueChanged(_ sender:UISegmentedControl!) {
        if sender.selectedSegmentIndex == 0 {
            defaults.set(0, forKey: "indexHeightUnit")
            indexHeightUnit = 0
        }else {
            defaults.set(1, forKey: "indexHeightUnit")
            indexHeightUnit = 1
        }
        
        delegate?.setHeightUnit(indexOfHeightUnit: sender.selectedSegmentIndex)
        print(heightSegmentOfCharts.selectedSegmentIndex)
    }
    
}


