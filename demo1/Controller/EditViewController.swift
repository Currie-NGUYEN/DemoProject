//
//  EditViewController.swift
//  demo1
//
//  Created by Currie on 3/3/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

protocol EditDelegate {
    func didEdit()
}

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
    
    var gender: Bool = true
    var delegate: EditDelegate?
    var boxView: UIView!
    var newBirthday: Int!
    
    let userService = UserService()
    let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    //MARK: -init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel.layer.cornerRadius = 10
        btnDone.layer.cornerRadius = 10
        
        name.borderStyle = .none
        email.borderStyle = .none
        birthday.borderStyle = .none
        
        image.layer.cornerRadius = 0.5 * image.bounds.size.width
        image.clipsToBounds = true
        
        image.frame = CGRect(x: 132, y: 88, width: 150, height: 150)
        name.delegate = self
        email.delegate = self
        birthday.delegate = self
        radioButtonSetUp()
        birthday.addTarget(self, action: #selector(openDatePicker(_:)), for: .touchDown)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        activityView.color = .black
        activityView.frame = CGRect(x: view.frame.midX-100/2 , y: view.frame.midY - 100/2, width: 100, height: 100)
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        view.addSubview(activityView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userService.loadUser { (userInfor) in
            if userInfor != nil {
                self.image.setBackgroundImage(userInfor!.avartar.decodeImageFromBase64(), for: .normal)
                self.name.text = userInfor!.name
                guard let birthday = userInfor!.birthday else {
                    return
                }
                newBirthday = birthday
                self.birthday.text = userInfor!.birthday!.dateFormater()
                self.email.text = userInfor!.email
                gender = userInfor!.gender ? true : false
            } else {
                self.image.setBackgroundImage(#imageLiteral(resourceName: "sad-face"), for: .normal)
                self.name.placeholder = "Type your name"
                self.birthday.placeholder = "Set your birthday"
                self.email.placeholder = "Type your email"
                gender = true
            }
            activityView.stopAnimating()
        }
    }
    
    @objc func openDatePicker(_ sender: AnyObject){
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerController") as! DatePickerController
        vc.modalPresentationStyle = .overFullScreen
        vc.delegateDate = self
        vc.isUseDatePicker = true
        vc.datePickerType = .date

        if newBirthday != nil {
            vc.dateDefault = Double(newBirthday)
        }
        present(vc, animated: true, completion: nil)
    }
    
    func addSavingDataView() {
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.black
        boxView.alpha = 0.5
        boxView.layer.cornerRadius = 10
        
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityView.color = .white
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.white
        textLabel.text = "Saving Data"
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        view.addSubview(boxView)
    }
    
    //MARK: -Handler
    @IBAction func clickedDone(_ sender: Any) {
        addSavingDataView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.saveData()
        }
    }
    
    func saveData(){
        let user = UserInfor(name: self.name.text!, avartar: (self.image.currentBackgroundImage?.encodeImageFromBase64())!, birthday: newBirthday, email: self.email.text!, gender: self.gender)
        userService.saveUser(user: user) { (done) in
            delegate?.didEdit()
            boxView.removeFromSuperview()
            dismiss(animated: true, completion: nil)
        }
    }
    
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
        dismiss(animated: true, completion: nil)
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

extension EditViewController: DatePickerDelegate {
    func didSetDate(date: Double) {
        newBirthday = Int(date.rounded())
        birthday.text = newBirthday.dateFormater()
    }
}

extension Int {
    func dateFormater() -> String{
        let date = Date(timeIntervalSince1970: Double(self))
        let formater = DateFormatter()
        formater.dateFormat = "dd-MM-yyyy"
        return formater.string(from: date)
    }
}

extension Double {
    func dateFormater() -> String{
        let date = Date(timeIntervalSince1970: self)
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-dd-MM hh:mm"
        return formater.string(from: date)
    }
}
