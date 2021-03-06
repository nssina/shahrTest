//
//  RegisterViewController.swift
//  ShahrYar
//
//  Created by Sina Rabiei on 5/5/20.
//  Copyright © 2020 Sina Rabiei. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import SwiftyJSON
import iOSDropDown
import MobileCoreServices

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pickImageOut: UIButton!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var registerTableView: UITableView!
    @IBOutlet var photoHeader: UIView!
        
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    let imageHandler = ImageHandler.shared
    
    var indexPath: IndexPath?
    var api_token = ""
    var name = ""
    var province: [String] = []
    var cities: [String] = []
    var sex = ["male", "female"]
    var birthday_day: String = "1"
    var birthday_month: String = "1"
    var birthday_year: String = "1370"


    var chosenProvince: String = "1"
    var chosenSex: String = "female"
    var chosenCity: String = "گرگان"
    
    
    let setProfileURL = "http://moshkelateshahri.xyz/api/setProfile"
    let provinceURL = "http://moshkelateshahri.xyz/api/provinces"
    let sectionTitles = ["نام و نام خانوادگی", "تاریخ تولد", "جنسیت", "استان", "شهر"]
    var tokenGlobal: String = ""
    
//    let testToken = "18zwg307wJJxS3h1NUu8BQ1fEG5eL4dZYHDakhhrbvz7ZQDI2qd5ZNQNll3wMMNPtZVLxo1uPkMmB97WD3syvzeRoBeO6kBsnmhx"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = defaults.string(forKey: "api_token")
        
        tokenGlobal = token!
        
        
        registerTableView.tableFooterView = UIView()
        registerTableView.tableHeaderView = photoHeader
        navigationItem.title = "پروفایل"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "IRANSansMobile-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        NotificationCenter.default.addObserver(self, selector: #selector(setImageFromImagePicker), name: Notification.Name("imagePicked"), object: nil)
        
        getProvince()
        getCity(provinceID: chosenProvince)
        
//        getProfileData(api_token: defaults.string(forKey: "api_token")!)
        
        getProfileData(api_token: token!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            let info = notification.userInfo!
            let _: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                if self.registerTableView.frame.origin.y == 0 {
                    self.registerTableView.frame.origin.y -= 150
                }
            }
        }
        
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            let info = notification.userInfo!
            let _: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                if self.registerTableView.frame.origin.y != 0 {
                    self.registerTableView.frame.origin.y += 150
                }
            }
        }
    
    @objc func setImageFromImagePicker() {
        imagePickerView.image = appDelegate.imageUrl
    }
    
    @IBAction func openImagePicker(_ sender: UIButton) {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                myPickerController.mediaTypes = [kUTTypeJPEG as String, kUTTypeImage as String]
                self.present(myPickerController, animated: true)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = pickedImage
            imagePickerView.layer.cornerRadius = imagePickerView.layer.frame.width / 2
            pickImageOut.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func getProvince() {
        AF.request(provinceURL,
           method: .get).responseJSON { (responseData) -> Void in
            if((responseData.value) != nil) {
                let result = JSON(responseData.value!)
                self.province = result[0].arrayValue.map {$0[0].stringValue}
                for (_, res) in result {
                    self.province.append(res["name"].string ?? "استان")
                }
            }
        }
    }
    
    
    func getProfileData(api_token: String) {
        var parameters = ["api_token": ""]
        parameters["api_token"] = api_token
        let cityURL = "http://moshkelateshahri.xyz/api/getProfile/"
        AF.request(cityURL,
           method: .get, parameters: parameters).responseJSON { (responseData) -> Void in
            if((responseData.value) != nil) {
                let result = JSON(responseData.value!)
                print(result)
            }
        }
    }
    
    
    func getCity(provinceID: String) {
        
        let cityURL = "http://moshkelateshahri.xyz/api/provinces/" + provinceID + "/cities"
        AF.request(cityURL,
           method: .get).responseJSON { (responseData) -> Void in
            if((responseData.value) != nil) {
                let result = JSON(responseData.value!)
                print(result)
                for (_, res) in result {
                    print(res["name"])
                    self.cities.append(res["name"].string ?? "شهر")
                    print(self.cities)
                }
            }
        }
    }
    
    func sendDate(api_token: String, name: String, province: String, city: String, sex: String, BDDay: String, BDMonth: String, BDYear: String) {

        let parameters = ["api_token": api_token, "name": name, "province": province, "city": city, "sex": sex, "birthday_day": BDDay, "birthday_month": BDMonth, "birthday_year": BDYear]

        let url = NSURL(string: setProfileURL)

        if imagePickerView.image == nil {
            postComplexPictures(url: url! as URL, params: parameters, pictures: #imageLiteral(resourceName: "ShahrdariLogo"))
        } else {
            postComplexPictures(url: url! as URL, params: parameters, pictures: imagePickerView.image!)
        }
        
    }

          func postComplexPictures(url:URL, params:[String:Any], pictures : UIImage) {
              
              let headers: HTTPHeaders
              headers = ["Content-type": "multipart/form-data"]
              
              AF.upload(multipartFormData: { (multipartFormData) in
                  
                  for (key, value) in params {
                      print("key : \(key), value \(value)")
                      multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                  }
                  
                  //let resizeImage: UIImage = self.videoCapture.resizeImage(image: pictures, targetSize: CGSize(width: 720, height: 1280))
                  if let imageData = pictures.pngData()
                  {
                      multipartFormData.append(imageData, withName: "problem-6.png", fileName: "problem-6.png", mimeType: "image/jpg")
                  }
              }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers)
                  .responseJSON
                  {
                      response in
                      //debugPrint(response)
                      switch response.result
                      {
                          
                      case .success(let value):
                          print("value : \(value)")
                          do
                          {
                            print("eaweaweaweaeawewaeaweaw")
//                              let parsedData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//                              let getvalue = try JSONDecoder().decode(fitme.self, from: parsedData)
//                              print(getvalue.result)
                              
                          }
                          
                      case .failure(let error):
                          print("error : \(error)")
                          break
                      }
                      
              }
    }
  
    @IBAction func submitButton(_ sender: Any) {
        print("Submit button Pressed")
        
        sendDate(api_token: tokenGlobal, name: name, province: chosenProvince, city: chosenCity, sex: chosenSex, BDDay: birthday_day, BDMonth: birthday_month, BDYear: birthday_year)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "homeVc")
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
        
//        let registerCell = registerTableView.dequeueReusableCell(withIdentifier: "resgisterCell", for: indexPath!) as! RegisterCell
//        registerCell.dropDownCity.showList()
//        print(name)
    }
}




extension RegisterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let registerCell = tableView.dequeueReusableCell(withIdentifier: "resgisterCell", for: indexPath) as! RegisterCell
        self.indexPath = indexPath
        
        
        
        registerCell.selectionStyle = .none
        
        registerCell.nameTextField.delegate = self
        registerCell.dayTextField.delegate = self
        registerCell.monthTextField.delegate = self
        registerCell.yearTextField.delegate = self
        registerCell.dropDownSex.delegate = self
        registerCell.dropDownProvince.delegate = self
        registerCell.dropDownCity.delegate = self

        switch indexPath.section {
        case 0: //Name
            print("1")
            registerCell.nameTextField.isHidden = false
            registerCell.nameTextField.tag = 1
            
            registerCell.dropDownSex.isHidden = true
            registerCell.dayTextField.isHidden = true
            registerCell.monthTextField.isHidden = true
            registerCell.yearTextField.isHidden = true
            registerCell.dropDownProvince.isHidden = true
            registerCell.dropDownCity.isHidden = true
        case 1: //Birthday
            print("2")
            registerCell.dayTextField.isHidden = false
            registerCell.monthTextField.isHidden = false
            registerCell.yearTextField.isHidden = false
            
            registerCell.dayTextField.tag = 2
            registerCell.monthTextField.tag = 3
            registerCell.yearTextField.tag = 4

            
            registerCell.dropDownSex.isHidden = true
            registerCell.nameTextField.isHidden = true
            registerCell.dropDownProvince.isHidden = true
            registerCell.dropDownCity.isHidden = true
        case 2: //Sex
            print("3")
            registerCell.dropDownSex.isHidden = false
            registerCell.dropDownSex.isSearchEnable = false
            
            registerCell.dayTextField.isHidden = true
            registerCell.monthTextField.isHidden = true
            registerCell.yearTextField.isHidden = true
            registerCell.nameTextField.isHidden = true
            registerCell.dropDownProvince.isHidden = true
            registerCell.dropDownCity.isHidden = true
        case 3: //Province
            print("4")
            registerCell.dropDownProvince.isHidden = false
            registerCell.dropDownProvince.isSearchEnable = false
            
            registerCell.dropDownSex.isHidden = true
            registerCell.dayTextField.isHidden = true
            registerCell.monthTextField.isHidden = true
            registerCell.yearTextField.isHidden = true
            registerCell.nameTextField.isHidden = true
            registerCell.dropDownCity.isHidden = true
        case 4: //City
            registerCell.dropDownCity.isHidden = false
            registerCell.dropDownCity.isSearchEnable = false
            
            registerCell.dropDownSex.isHidden = true
            registerCell.dayTextField.isHidden = true
            registerCell.monthTextField.isHidden = true
            registerCell.yearTextField.isHidden = true
            registerCell.nameTextField.isHidden = true
            registerCell.dropDownProvince.isHidden = true
        default:
            break
        }
        
        registerCell.dropDownProvince.listWillAppear {
            registerCell.dropDownProvince.optionArray = self.province
        }
        
        registerCell.dropDownCity.listWillAppear {
            registerCell.dropDownCity.optionArray = self.cities
        }
        
        registerCell.dropDownSex.listWillAppear {
            registerCell.dropDownSex.optionArray = self.sex
        }
        
        
        
        registerCell.dropDownProvince.didSelect{(selectedText , index ,id) in
            self.chosenProvince = selectedText
        }
        registerCell.dropDownCity.didSelect{(selectedText , index ,id) in
            self.chosenCity = selectedText
        }
        registerCell.dropDownSex.didSelect{(selectedText , index ,id) in
            self.chosenSex = selectedText
        }
        
        
        
        return registerCell
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.tag == 1 {
            name = textField.text ?? "UserName"
        }
        else if textField.tag == 2 {
            birthday_day = textField.text ?? "1"
        }
        else if textField.tag == 3 {
            birthday_month = textField.text ?? "1"
        }
        else if textField.tag == 4 {
            birthday_year = textField.text ?? "1370"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
        return false
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textAlignment = NSTextAlignment.right
        header.textLabel?.font = UIFont(name: "IRANSansMobile", size: 16)
        header.textLabel?.textColor = .darkGray
        header.tintColor = .clear
    }
}
