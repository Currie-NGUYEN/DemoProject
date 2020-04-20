//
//  DatePickerController.swift
//  demo1
//
//  Created by Currie on 4/16/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

protocol DatePickerDelegate {
    func didSetDate(date: Double)
}

protocol YearPickerDelegate {
    func didSetYear(year: Int)
}

class DatePickerController: UIViewController {
    
    @IBOutlet weak var viewDataPicker: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var datePicker: UIDatePicker!
    var onlyYearPicker: UIPickerView!
    var delegateDate: DatePickerDelegate?
    var delegateYear: YearPickerDelegate?
    var datePickerType = UIDatePicker.Mode.dateAndTime
    var dateDefault = Double(Date().timeIntervalSince1970)
    var yearDefault = 1970
    var isUseDatePicker = true
    var years:[Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDataPicker.layer.cornerRadius = 5
        viewDataPicker.clipsToBounds = true
        
        cancelButton.roundCorners(corners: [.bottomLeft,.topLeft], radius: 5)
        doneButton.roundCorners(corners: [.bottomRight,.topRight], radius: 5)
        
        if isUseDatePicker {
            setDatePicker()
        } else {
            setOnlyYear()
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        if isUseDatePicker {
            let date = datePicker.date.timeIntervalSince1970
            delegateDate?.didSetDate(date: date)
        } else {
            let year = years[onlyYearPicker.selectedRow(inComponent: 0)]
            delegateYear?.didSetYear(year: year)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
    }
    
    func setDatePicker(){
        self.datePicker = UIDatePicker(frame: viewDataPicker.frame)
        datePicker.datePickerMode = datePickerType
        datePicker.date = Date(timeIntervalSince1970: dateDefault)
        view.addSubview(datePicker)
    }
    
    func setOnlyYear(){
        self.onlyYearPicker = UIPickerView(frame: viewDataPicker.frame)
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        for index in 1970...currentYear {
            years.append(index)
        }
        
        onlyYearPicker.delegate = self
        onlyYearPicker.dataSource = self
        onlyYearPicker.selectRow(years.firstIndex(of: yearDefault)!, inComponent: 0, animated: true)
        view.addSubview(onlyYearPicker)
    }
}

extension UIButton {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension DatePickerController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(years[row])"
    }
}
