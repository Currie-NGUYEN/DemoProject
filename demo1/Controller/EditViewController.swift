//
//  EditViewController.swift
//  demo1
//
//  Created by Currie on 3/3/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: -properties
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var image: UIButton!
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var UIMale: UIButton!
    @IBOutlet weak var UIFemale: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    var datePicker: UIDatePicker?
    var gender: Bool = true
    //MARK: -init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel.layer.cornerRadius = 10
        btnDone.layer.cornerRadius = 10
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(EditViewController.dataChanged(dataPicker:)), for: .valueChanged)
        birthday.inputView = datePicker
//        name.backgroundColor = .clear
        name.borderStyle = .none
        email.borderStyle = .none
        birthday.borderStyle = .none
//        name.isUserInteractionEnabled = false
        image.layer.cornerRadius = 0.5 * image.bounds.size.width
        image.backgroundColor = .blue
        image.frame = CGRect(x: 132, y: 88, width: 150, height: 150)
        name.delegate = self
        email.delegate = self
        birthday.delegate = self
        radioButtonSetUp()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: -Handler
    
    func radioButtonSetUp() {
        switch gender {
        case true:
            UIFemale.setImage(UIImage(named: "radioBT-uncheck"), for: UIControl.State.normal)
            UIMale.setImage(UIImage(named: "radioBT-check"), for: UIControl.State.normal)
        case false:
            UIFemale.setImage(UIImage(named: "radioBT-check"), for: UIControl.State.normal)
            UIMale.setImage(UIImage(named: "radioBT-uncheck"), for: UIControl.State.normal)
        }
    }
    @IBAction func cancel(_ sender: UIButton) {
        
    }
    
    func toggleGender(gender: Bool) {
        self.gender = gender
        radioButtonSetUp()
    }
    
    @IBAction func female(_ sender: UIButton) {
        toggleGender(gender: false)
    }
    
    @IBAction func male(_ sender: UIButton) {
        toggleGender(gender: true)
    }
    @objc func dataChanged(dataPicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthday.text = dateFormatter.string(from: dataPicker.date)
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch textField {
        case name:
            name.backgroundColor = .clear
            name.borderStyle = .none
        case email:
            email.backgroundColor = .clear
            email.borderStyle = .none
        case email:
            birthday.backgroundColor = .clear
            birthday.borderStyle = .none
        default:
            break
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        name.backgroundColor = .
        switch textField {
        case name:
            name.borderStyle = .roundedRect
        case email:
            email.borderStyle = .roundedRect
        case email:
            birthday.borderStyle = .roundedRect
        default:
            break
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func update(_ sender: UIButton) {
    }
    
    @IBAction func checkMale(_ sender: UIButton) {
    }
    
    @IBAction func Female(_ sender: UIButton) {
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        let imagepicker = UIImagePickerController()
        imagepicker.sourceType = .photoLibrary
        imagepicker.allowsEditing = true
        imagepicker.delegate = self
        present(imagepicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        image.setBackgroundImage( info[UIImagePickerController.InfoKey.originalImage] as? UIImage, for: UIControl.State.normal)
    }
}

