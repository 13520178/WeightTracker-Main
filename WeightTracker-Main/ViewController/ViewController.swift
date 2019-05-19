//
//  ViewController.swift
//  WeightTracker-Main
//
//  Created by Phan Nhat Dang on 2/17/19.
//  Copyright © 2019 Phan Nhat Dang. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import GoogleMobileAds


//collectionView is the top colection view
// TabColectionView are big bottom views
class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GADBannerViewDelegate  {
    

    //MARK: - Outlet variable
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leadingOfNarBarBottom: NSLayoutConstraint!
    @IBOutlet weak var widthOfNarBarBottom: NSLayoutConstraint!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var bottomAnchorMainView: NSLayoutConstraint!
    //MARK: - Variable
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    var isStart  = true
    var isStartAtView5 = false
    var iconColectionViewArray = ["scaleIcon","diagramIcon","historyIcon","toolIcon","setupIcon"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request : NSFetchRequest<Person> = Person.fetchRequest()
    
    var indexOfCellSelected = -1
    let defaults = UserDefaults.standard
    var indexOfUnitWeight = 0
    var indexOfUnitHeight = 0
    var exchangeTF = UITextField()
    var showInputViewInToolCellWhenChangeHeightUnit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //Ads Banner setup
        //
        bannerView.delegate = self
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        //Thu nghiem
        bannerView.adUnitID = "ca-app-pub-9626752563546060/1275680503"
    
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.view.layoutIfNeeded()
        
        //
        //End Banner setup
        //
        
        
        
        collectionViewSetup()
        tabCollectionViewSetup()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshLbl),
                                               name: NSNotification.Name(rawValue: "refresh"),
                                               object: nil)
        
        if defaults.integer(forKey: "indexOfWeightUnit") == 0 {
            indexOfUnitWeight = 0
        }else if defaults.integer(forKey: "indexOfWeightUnit") == 1 {
            indexOfUnitWeight = 1
        }else {
            indexOfUnitWeight = 0
        }
        
        if defaults.integer(forKey: "indexOfHeightUnit") == 0 {
            indexOfUnitHeight = 0
        }else if defaults.integer(forKey: "indexOfHeightUnit") == 1 {
            indexOfUnitHeight = 1
        }else {
            indexOfUnitHeight = 0
        }
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
        
    }
    
    
    @objc func refreshLbl(notification: NSNotification) {
        print("Received Notification")
        collectionView.reloadData()
        tabCollectionView.reloadData()
        isStart = false
        let indexPath = IndexPath(row: 2, section: 0)
        
        DispatchQueue.main.async {
            self.collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .top)
            
        }
        self.collectionView(self.collectionView, didSelectItemAt: indexPath)
        
        self.tabCollectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //auto selected 1st item
        if isStart {
            let indexPathForFirstRow = IndexPath(row: 0, section: 0)
            self.collectionView?.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .top)
        }else {
            if isStartAtView5 {
                let indexPathForFirstRow = IndexPath(row: 4, section: 0)
                self.collectionView?.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .top)
                isStart = true
                isStartAtView5 = false
            }else {
                let indexPathForFirstRow = IndexPath(row: 2, section: 0)
                self.collectionView?.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .top)
                isStart = true
            }
        }  
        
    }
    
    

    func tabCollectionViewSetup() {
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView?.register(InputWeightCell.self, forCellWithReuseIdentifier: "InputWeightId")
        tabCollectionView?.register(DiagramCell.self, forCellWithReuseIdentifier: "DiagramId")
        tabCollectionView?.register(HistoryCell.self, forCellWithReuseIdentifier:
            "HistoryId")
        tabCollectionView?.register(ToolCell.self, forCellWithReuseIdentifier:
            "ToolId")
        tabCollectionView?.register(SetupCell.self, forCellWithReuseIdentifier:
            "SetupId")
        if let flowLayout = tabCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
    }
    
    //MARK: - ColectionView
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        leadingOfNarBarBottom.constant = scrollView.contentOffset.x/5
       
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let indexPath = IndexPath(row: Int(targetContentOffset.pointee.x/view.frame.width), section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        view.endEditing(true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return 5
        }else if collectionView == self.tabCollectionView {
            return 5
        }else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! NarBarCollectionViewCell
            
            cell.image.image = UIImage(named: iconColectionViewArray[indexPath.row])?.withRenderingMode(.alwaysTemplate)
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            
            return cell
        }else if collectionView == self.tabCollectionView {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputWeightId", for: indexPath) as? InputWeightCell
                cell?.delegate = self
                if indexOfUnitWeight == 0 {
                    cell?.kgLabel.text = "kg"
                }else if indexOfUnitWeight == 1  {
                    cell?.kgLabel.text = "lbs"
                }else {
                    cell?.kgLabel.text = "kg"
                }
                
                return cell!
            }else if indexPath.item == 1 {
                 let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "DiagramId", for: indexPath) as? DiagramCell
                do {
                    try cell?.people = context.fetch(request)
                } catch  {
                    print("Error to fetch Item data")
                }
                
                if defaults.double(forKey: "desizedWeightForHistory") != 0 {
                    cell?.desiredWeight = defaults.double(forKey: "desizedWeightForHistory")
                }
                
                if  cell != nil , cell!.people.count >= 1 {
                    
                    var sumOfDays = 0
                    var embedDateForCountInSumOfDay = ""
                    var monthss = [String]()
                    var unitsSolds = [Double]()
                    for i in 0..<cell!.people.count {
                        let subString = cell!.people[i].date?.prefix(5)
                        monthss.append(String(subString ?? ""))
                        unitsSolds.append(Double(cell!.people[i].weight))
                        
                        if(embedDateForCountInSumOfDay != cell!.people[i].date) {
                            sumOfDays += 1
                            embedDateForCountInSumOfDay = cell!.people[i].date!
                            
                        }
                    }
                    cell!.months = monthss
                    cell!.unitsSold = unitsSolds
                    cell!.setChart(dataEntryX: cell!.months, dataEntryY: cell!.unitsSold)
                    cell!.setChartCandle(dataEntryX: cell!.months, dataEntryY: cell!.unitsSold)
                    let startKg = round(cell!.unitsSold[0] * 100)/100
                    let changeKg  = round((cell!.unitsSold.last! - cell!.unitsSold.first!) * 100)/100
                    if indexOfUnitWeight == 0 {
                        cell?.weightUnit = "kg"
                        cell!.startKgLabel.text = String(startKg) + " kg "
                        cell!.changeKgLabel.text = String(changeKg)
                    }else if indexOfUnitWeight == 1  {
                        cell?.weightUnit = "lbs"
                        cell!.startKgLabel.text = String(startKg) + " lbs "
                        cell!.changeKgLabel.text = String(changeKg)
                    }else {
                        cell?.weightUnit = "kg"
                        cell!.startKgLabel.text = String(startKg) + " kg "
                        cell!.changeKgLabel.text = String(changeKg)
                    }
                   
                    let datesForWeightTrend = cell!.get7and30DayBefore()
                    cell!.setWeight7TrendValue(dates: datesForWeightTrend)
                    cell!.setWeight30TrendValue(dates: datesForWeightTrend)
                    cell!.timeStartLabel.text = cell!.people[0].date
                    
                    // sum of days
                    cell!.totalDaysLabel.text = String(sumOfDays)
                }else {
                    cell!.startKgLabel.text = "No record"
                    cell!.changeKgLabel.text = "-"
                    cell!.change7DayLabel.text = "-"
                    cell!.change30DayLabel.text = "_"
                    cell!.timeStartLabel.text = "No record"
                    cell!.totalDaysLabel.text = "0"
                    
                    let monthss = [""]
                    let unitsSolds = [0.0]
                    cell!.months = monthss
                    cell!.unitsSold = unitsSolds
                    cell!.setChart(dataEntryX: cell!.months, dataEntryY: cell!.unitsSold)
                    cell!.setChartCandle(dataEntryX: cell!.months, dataEntryY: cell!.unitsSold)
                }
                
                return cell!
                
            }else if indexPath.item == 2 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryId", for: indexPath) as? HistoryCell
                do {
                    try cell?.people = context.fetch(request)
                } catch  {
                    print("Error to fetch Item data")
                }
                
                
                
                if indexOfUnitWeight == 0 {
                    cell?.weightUnit = "kg"
                    
                }else if indexOfUnitWeight == 1  {
                    cell?.weightUnit = "lbs"
                    
                }else {
                    cell?.weightUnit = "kg"
                    
                }
                
                cell?.filterStateLabel.text = "All records"
                cell?.filterPeople = []
                for i in (cell?.people)! {
                    cell?.filterPeople.append(i)
                }
                cell?.delegate = self
                cell?.tableView.reloadData()
                return cell!
                
            }
            else if indexPath.item == 3  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolId", for: indexPath) as? ToolCell
                cell?.delegate = self
                if indexOfUnitWeight == 0 {
                    cell?.weightUnit = "kg"
                    cell?.kgLabel.text = "kg"
                    
                }else if indexOfUnitWeight == 1  {
                    cell?.weightUnit = "lbs"
                    cell?.kgLabel.text = "lbs"
                    
                }else {
                    cell?.weightUnit = "kg"
                    cell?.kgLabel.text = "kg"
                    
                }

                if self.indexOfUnitHeight == 0 {
                    cell?.heightUnit = "cm"
                    cell?.ftLabel.isHidden = true
                    cell?.inputFtHeightTextfield.isHidden = true
                    cell?.inLabel.isHidden = true
                    cell?.inputInHeightTextfield.isHidden = true
                    cell?.cmLabel.isHidden = false
                    cell?.inputHeightTextfield.isHidden = false
                    
                }else if self.indexOfUnitHeight == 1  {
                    cell?.heightUnit = "ft:in"
                    cell?.ftLabel.isHidden = false
                    cell?.inputFtHeightTextfield.isHidden = false
                    cell?.inLabel.isHidden = false
                    cell?.inputInHeightTextfield.isHidden = false
                    cell?.cmLabel.isHidden = true
                    cell?.inputHeightTextfield.isHidden = true
                    
                }else {
                    cell?.heightUnit = "cm"
                    cell?.ftLabel.isHidden = true
                    cell?.inputFtHeightTextfield.isHidden = true
                    cell?.inLabel.isHidden = true
                    cell?.inputInHeightTextfield.isHidden = true
                    cell?.cmLabel.isHidden = false
                    cell?.inputHeightTextfield.isHidden = false
                    
                }
                if self.showInputViewInToolCellWhenChangeHeightUnit == true {
                    cell?.editProfileButtonAction()
                    self.showInputViewInToolCellWhenChangeHeightUnit = false
                }
                
                
                cell?.layoutIfNeeded()

                do {
                    try cell?.people = context.fetch(request)
                } catch  {
                    print("Error to fetch Item data")
                }
                
                if let h = Double(cell!.inputHeightTextfield.text!) , let w = Double(cell!.desiredWeightTextfield.text!) {
                        if h != 0 && w != 0 {
                            cell?.defaults.set(Double(cell!.inputHeightTextfield.text!), forKey: "height")
                            cell?.defaults.set(Double(cell!.desiredWeightTextfield.text!), forKey: "desizedWeight")
                        }
                    }
               
                
                if(cell?.people.count == 0) {
                    cell?.editProfileButtonAction()
                }else {
                    
                    cell?.calculateAndShowBMIValue()
                }
                
                cell!.setWeightPrediction()
                return cell!
                
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetupId", for: indexPath) as? SetupCell
                cell?.delegate = self
                return cell!
            }
            
        }else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height )
        }else {
            return CGSize(width: tabCollectionView.frame.width, height: tabCollectionView.frame.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            self.tabCollectionView?.scrollToItem(at: indexPath, at: [], animated: true)
            view.endEditing(true)
        }
        
    }
    
    func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        //widthOfNarBarBottom.constant = collectionView.frame.width/5
        widthOfNarBarBottom.constant = view.frame.width/5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHistoryDetail" {
            let destVC : HistoryDetailVC = segue.destination as! HistoryDetailVC
            if(indexOfCellSelected != -1) {
                destVC.indexOfPeople = indexOfCellSelected
                
                if indexOfUnitWeight == 0 {
                    destVC.weightUnit = "kg"
                }else if indexOfUnitWeight == 1  {
                    destVC.weightUnit = "lbs"
                }else {
                    destVC.weightUnit = "kg"
                }
                
            }
        }

    }

}



//MARK: Protocol

extension ViewController: ToolCellDelegate {
    func showPrediction() {
          AlertController.showAlert(inController: self, tilte: "Weight prediction feature", message: "The more daily weight records will give the correct results. We will start calculating your weight after 2 days of weight recording. Accuracy of weight will affect results. Too much weight change in a day or two can be caused by a change in body water percentage.")
    }
    
    func upgradeToPro() {
        let alertController = UIAlertController(title: "Upgrade to Pro?", message: "Pro version will remove ads, add new features and be upgraded interface.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Upgrade", style: .default) { (action) in
            if let url = URL(string: "https://itunes.apple.com/us/app/wechart-pro/id1463270859?mt=8&ign-mpt=uo%3D2"),
                UIApplication.shared.canOpenURL(url)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    func enterDesiredWeight(dWeight: Double) {
        defaults.set(dWeight, forKey: "desizedWeightForHistory")
        collectionView.reloadData()
        tabCollectionView.reloadData()
    }
    
    func enterInitialWeight() {
        let alertController = UIAlertController(title: "Initial weight settings", message: "Enter the initial weight you want to edit ", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: exchangeTF)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let w = self.exchangeTF.text {
                if let w = Float(w) {
                    if w > 1 && w <= 400 {
                        if let result = try? self.context.fetch(self.request) {
                            result.first?.weight = w
                        }
                        do {
                            try self.context.save()
                            let indexPath = IndexPath(row: 3, section: 0)
                            DispatchQueue.main.async {
                                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
                            }
                            
                            self.collectionView.reloadData()
                            self.tabCollectionView.reloadData()
                        } catch {
                            print("Co xoa duoc dau ma xoa")
                        }
                    }else {
                        self.checkIfOverInput()
                    }
                }else {
                    self.checkIfWrongInputToolCell()
                }
            }else {
                self.checkIfWrongInputToolCell()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
         self.present(alertController, animated: true)
    }
    
    
    
    func exchangeTF(textField:UITextField!) {
        exchangeTF = textField
        exchangeTF.keyboardType = .decimalPad
        exchangeTF.placeholder = "Ex. 60.0"
        
    }
    
    func checkIfWrongInputToolCell() {
        AlertController.showAlert(inController: self, tilte: "Something is wrong", message: "You entered the wrong type of weight or height.")
    }
    
    func enterWeightFirst() {
        AlertController.showAlert(inController: self, tilte: "Almost done 😜", message: "Please enter your current weight.")
        let indexPath = IndexPath(row: 0, section: 0)
        
        DispatchQueue.main.async {
            self.collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .top)
            
        }
        
        self.collectionView(self.collectionView, didSelectItemAt: indexPath)
        self.tabCollectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        collectionView.reloadData()
        tabCollectionView.reloadData()
    }
    

}

extension ViewController: InputWeightCellDelegate {
    func showUpgradeInTabOne() {
        let alertController = UIAlertController(title: "Upgrade to Pro?", message: "Pro version will remove ads, add new features and be upgraded interface.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Upgrade", style: .default) { (action) in
            if let url = URL(string: "https://itunes.apple.com/us/app/wechart-pro/id1463270859?mt=8&ign-mpt=uo%3D2"),
                UIApplication.shared.canOpenURL(url)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    func enableUserInteraction() {
        collectionView.isUserInteractionEnabled = true
        tabCollectionView.isScrollEnabled = true
    }
    
    func disableUserInteraction() {
        collectionView.isUserInteractionEnabled = false
        tabCollectionView.isScrollEnabled = false
    }
    
    func showSub1() {
        performSegue(withIdentifier: "showSub1", sender: nil)
    }
    
    func showSub2() {
        performSegue(withIdentifier: "showSub2", sender: nil)
    }
    
    func showSub3() {
        performSegue(withIdentifier: "showSub3", sender: nil)
    }
    
    func showSub4() {
        performSegue(withIdentifier: "showSub4", sender: nil)
    }
    
    func checkIfOverInput() {
        AlertController.showAlert(inController: self, tilte: "Something is not reasonable", message: "It looks like you entered an unreasonable value 🙄 ")
    }
    
    func changeAndUpdateCell(didChange: Bool, person:Person) {
        let indexPath = IndexPath(row: 3, section: 0)
        
        DispatchQueue.main.async {
            self.collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .top)

        }
        self.collectionView(self.collectionView, didSelectItemAt: indexPath)
        
        self.tabCollectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        collectionView.reloadData()
        tabCollectionView.reloadData()
    }
    
    func checkIfWrongInput() {
        AlertController.showAlert(inController: self, tilte: "Something is wrong", message: "You entered the wrong type of weight")
    }
    
    func resetData() {
        print("Show new controller")
    }
}

extension ViewController: HistoryCellDelegate {
    func showFilterAction() {
       

    }
    
    func showDetailHistory(index: Int) {
        indexOfCellSelected = index
        performSegue(withIdentifier: "showHistoryDetail", sender: nil)
    }
    
    
    func touchToDeleteCell(index: Int) {
        let alertController = UIAlertController(title: "Delete This Record", message: "Do you want to delete this record? ", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let result = try? self.context.fetch(self.request) {
                self.context.delete(result[(result.count - 1) - index])
                
            }
            do {
                try self.context.save()
                let indexPath = IndexPath(row: 2, section: 0)
                DispatchQueue.main.async {
                    self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
                }
               
                self.collectionView.reloadData()
                self.tabCollectionView.reloadData()
            } catch {
                print("Co xoa duoc dau ma xoa")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }

}

extension ViewController:SetupCellDelegate,MFMailComposeViewControllerDelegate {
    func showUpgradeView() {
        let alertController = UIAlertController(title: "Upgrade to Pro?", message: "Pro version will remove ads, add new features and be upgraded interface.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Upgrade", style: .default) { (action) in
                if let url = URL(string: "https://itunes.apple.com/us/app/wechart-pro/id1463270859?mt=8&ign-mpt=uo%3D2"),
                    UIApplication.shared.canOpenURL(url)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    func deleteAllRecords() {
        let alertController = UIAlertController(title: "Delete All Data ?", message: "Do you want to delete all data ?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let result = try? self.context.fetch(self.request) {
                for i in result {
                    self.context.delete(i)
                }
                
            }
            do {
                try self.context.save()
                let indexPath = IndexPath(row: 3, section: 0)
                self.collectionView.reloadData()
                self.tabCollectionView.reloadData()
                DispatchQueue.main.async {
                    self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
                }
                self.tabCollectionView?.scrollToItem(at: indexPath, at: [], animated: true)
                
                
            } catch {
                print("Co xoa duoc dau ma xoa")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    func setWeightUnit(indexOfWeightUnit: Int) {
        defaults.set(indexOfWeightUnit, forKey: "indexOfWeightUnit")
        self.indexOfUnitWeight = defaults.integer(forKey: "indexOfWeightUnit")
        
        let alertController = UIAlertController(title: "Convert the previous weight values", message: "Do you want to convert the previous weight values? ", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in

            self.spinner.startAnimating()
            DispatchQueue.main.async() {
                var people = [Person]()
                do {
                    try people = self.context.fetch(self.request)
                } catch  {
                    print("Error to fetch Item data")
                }
                if self.indexOfUnitWeight == 0 {
                    for i in people {
                        i.weight = i.weight * 0.45359237
                        i.weight = round(i.weight*100)/100
                    }
                }else {
                    for i in people {
                        i.weight = i.weight / 0.45359237
                        i.weight = round(i.weight*100)/100
                    }
                }
                
                do {
                    try self.context.save()
                } catch  {
                    print("Error to saving data")
                }
                self.spinner.stopAnimating()
            }
        
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)

        
        self.tabCollectionView.reloadData()
    }
    
    func setHeightUnit(indexOfHeightUnit: Int) {
        print("May set duoc roi ne")
        showInputViewInToolCellWhenChangeHeightUnit = true
        defaults.set(indexOfHeightUnit, forKey: "indexOfHeightUnit")
        self.indexOfUnitHeight = defaults.integer(forKey: "indexOfHeightUnit")        
        self.tabCollectionView.reloadData()
    }
    
    func isScrollable(scroll: Bool) {
        tabCollectionView.isScrollEnabled = scroll
        collectionView.allowsSelection = scroll
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["phannhatd@gmail.com"])
        mailComposerVC.setSubject("Question about WeChart 1.1.5")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sentMail() {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
        isStart = false
        isStartAtView5 = true
        
    }
    
    
}



