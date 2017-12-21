//
//  ReferViewController.swift
//  Refer
//
//  Created by Vera on 12/21/17.
//  Copyright © 2017 Vera. All rights reserved.
//

import UIKit
import Contacts
class ReferViewController: UIViewController {
    let store = CNContactStore()
    var contactName = [String]()
    var contactNumber = [String]()
    var selectedItem = [String]()
    var filterArray = [String]()
    var isFilter:Bool = false
    @IBOutlet weak var dataView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataView.isHidden = true
        //let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> MyApp to enable contact permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var cnContacts = [CNContact]()
            
            do {
                try self.store.enumerateContacts(with: request){
                    (contact, cursor) -> Void in
                    cnContacts.append(contact)
                }
            } catch let error {
                NSLog("Fetch contact error: \(error)")
            }
            
            print(">>>> Contact list:")
            for contact in cnContacts {
                let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
               // print("full name:\(fullName),contact: \(contact.phoneNumbers)")
                let phonenumberStr = ((contact.phoneNumbers[0])as AnyObject).value(forKey: "value")as AnyObject
                //print(phonenumberStr.value(forKey: "stringValue") as AnyObject)
                let phoneNo = phonenumberStr.value(forKey: "stringValue") as AnyObject
                print("\(fullName)\t\(phoneNo)")
                self.contactName.append(fullName)
                self.contactNumber.append(phoneNo as! String)
                 self.filterArray = self.contactName
                print(self.filterArray.count)
                
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        })
       
        
        
    }
    func getSearchArrayContains(_ text : String) {
     
        if text.count >= 1{
            let predicate : NSPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", text)
            self.filterArray = (self.contactName as NSArray).filtered(using: predicate) as! [String]
            isFilter = true
            self.tblView.reloadData()
         }
        
    }
    
    

   
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dataView.isHidden = true
        print(self.filterArray)
    }
    @IBAction func selectContactButtonTapped(_ sender: UIButton) {
        self.tblView.reloadData()
        self.dataView.isHidden = false
        
    }
    
    @IBAction func socialMediaButtonTapped(_ sender: UIButton) {
        let activityVC = UIActivityViewController(activityItems: ["Share the app to your loved ones"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
}
extension ReferViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter{
            return self.filterArray.count
        }
        return self.contactNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as!ContactCell
        if isFilter{
            cell.contactName.text = self.filterArray[indexPath.row]
            cell.contactNumber.text = self.contactNumber[indexPath.row]
            return cell
        }
        cell.contactName.text = self.contactName[indexPath.row]
        cell.contactNumber.text = self.contactNumber[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(self.contactNumber[indexPath.row])\t \(self.contactName[indexPath.row])")
       
        print(self.selectedItem)
        let cell = tblView.cellForRow(at: indexPath) as? ContactCell
        //print(cell)
        if cell?.checkButton.isSelected == false{
            cell?.checkButton.isSelected = true
             self.selectedItem.append(self.contactNumber[indexPath.row])
        }else if cell?.checkButton.isSelected == true{
            cell?.checkButton.isSelected = false
            self.selectedItem.remove(at: indexPath.row)
            //print(self.selectedItem.remove(at: indexPath.row))
        }
//        let indexPath = tblView.indexPathForSelectedRow // index path of selected cell
//        print(indexPath)
//
//        let headerCellIndex = indexPath!.section // index of selected section
//       // let headerCellName = ????? // instance of selected section
//        print(headerCellIndex)
//
//        let cellIndex = indexPath!.row // index of selected cell
//        print(cellIndex)
//        let cellName = tblView.cellForRow(at: indexPath!)
//        print(cellName)
        
    }
    
    
}
extension ReferViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchText:String = textField.text! + string
        print(searchText)
        if searchText == "" {
            isFilter = false
            tblView.reloadData()
        }
        else{
            getSearchArrayContains(searchText)
            textField.clearButtonMode = .always
            
        }
        
         return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("text cleared")
        isFilter = false
        self.tblView.reloadData()
        return true
    }
}
