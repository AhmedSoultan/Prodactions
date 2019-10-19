//
//  ViewController.swift
//  Prodactions
//
//  Created by Ahmed Sultan on 10/18/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var carsTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Properties
    var db: Firestore! = nil
    var carPicker: UIPickerView!
    var carType = ["New", "Used"]
    var cars = [Car]()
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CarTableViewCell", bundle: nil), forCellReuseIdentifier: "CarCell")
        carPicker = UIPickerView()
        carPicker.backgroundColor = .lightGray
        carPicker.layer.cornerRadius = 10
        carPicker.layer.masksToBounds = true
        carPicker.delegate = self
        carPicker.dataSource = self
        carsTextField.inputView = carPicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.gestureTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
        //MARK: - Custom action
    @objc func gestureTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    fileprivate func database(categoryType:String) {
        // Do any additional setup after loading the view.
        db = Firestore.firestore()
        db.collection("cars").whereField("category", isEqualTo: categoryType).getDocuments { (snapShots, error) in
            if let error = error {
                print("error loading data \(error)")
            } else if let snapShots = snapShots?.documents {
                for snapShot in snapShots {
                    if let car = Car.carFrom(id: snapShot.documentID, data: snapShot.data()) {
                        self.cars.append(car)
                    } else {print("error create a car \(error)")}
                }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                }
            }
        }
    }
    
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return cars.count
        return cars.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell") as! CarTableViewCell
        let car = cars[indexPath.row]
        cell.titleLabel.text = car.title
        cell.cityLabel.text = car.city
        cell.priceLabel.text = String(car.price)
        cell.dateLabel.text = car.date
        cell.carImageView.image = UIImage(named: "placeholder")
        return cell
    }
}
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return carType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return carType[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cars.removeAll()
        database(categoryType: carType[row])
        view.endEditing(true)
    }
}
