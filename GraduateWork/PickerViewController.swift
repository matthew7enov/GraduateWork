//
//  PickerViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 28.04.23.
//

import UIKit

class PickerViewController: UIViewController {

    var values: [String] = [] {
        didSet {
            guard isViewLoaded else { return }
            pickerView.reloadAllComponents()
        }
    }
    var didSelectAction: ((Int) -> Void)?
    var selectedRow: Int = 0

    var contentView = UIView()
    var pickerView = UIPickerView()
    var cancelButton : UIButton = {
       var button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    var doneButton : UIButton = {
        var button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        view.addSubview(contentView)
        view.addSubview(pickerView)
        view.addSubview(cancelButton)
        view.addSubview(doneButton)
        
        contentView.backgroundColor = UIColor.white.withAlphaComponent(1)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 485),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            pickerView.heightAnchor.constraint(equalToConstant: 216),
            pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            pickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0)
        ])
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            cancelButton.widthAnchor.constraint(equalToConstant: 77),
            cancelButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            doneButton.widthAnchor.constraint(equalToConstant: 67),
            doneButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true)
    }
    @objc func doneButtonPressed() {
        didSelectAction?(selectedRow)
        dismiss(animated: true)
    }

}

extension PickerViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}

extension PickerViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
}
