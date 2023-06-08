//
//  StoragePickerViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 7.06.23.
//

import UIKit
import SVProgressHUD

class StoragePickerViewController: UIViewController {

    var storages = [Storage]() {
        didSet {
            pickerView.reloadAllComponents()
            selectedStorage = storages.first
        }
    }
    var currentStorage: Storage
    var selectedStorage: Storage?
    var didSelectStorage: ((Storage?) -> Void)?
    let dataProvider = DataProvider.shared

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

    init(currentStorage: Storage) {
        self.currentStorage = currentStorage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

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

    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.show()
        dataProvider.getStorages { [weak self] storages in
            SVProgressHUD.dismiss()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                let storages = storages.filter({ $0.id != self.currentStorage.id })
                guard !storages.isEmpty else {
                    self.dismiss(animated: true)
                    return
                }
                self.storages = storages
            }
        }
    }

    @objc func cancelButtonPressed() {
        didSelectStorage?(nil)
        dismiss(animated: true)
    }
    @objc func doneButtonPressed() {
        didSelectStorage?(selectedStorage)
        dismiss(animated: true)
    }
}

extension StoragePickerViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return storages[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStorage = storages[row]
    }
}

extension StoragePickerViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        storages.count
    }


}

