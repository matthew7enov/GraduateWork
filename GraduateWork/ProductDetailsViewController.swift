//
//  ProductDetailsViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 27.04.23.
//

import Foundation
import UIKit
import SVProgressHUD

class ProductDetailsViewController: UIViewController{
    enum Mode {
        case add, edit
    }

    let dataProvider = DataProvider.shared

    var mode: Mode = .add {
        didSet {
            guard isViewLoaded else { return }
            setupBarButtons()
        }
    }
    var selectedCategory: ProductCategory?
    var storageId: String
    var product: Product?
    var didAddProduct: ((Bool) -> Void)?

    var productCount: Int = 1 {
        didSet {
            countLabel.text = "\(productCount) шт"
        }
    }

    var productImage : UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.black.cgColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    var productNameTextField : UITextField = {
        var textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.gray.cgColor

        textField.borderStyle = .roundedRect
        textField.placeholder = "Название продукта"
        textField.textColor = .black
        textField.keyboardType = .default
        textField.keyboardAppearance = .dark
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.autocorrectionType = .no
        textField.smartInsertDeleteType = .no

        return textField
    }()
    var productDescriptionTextView : UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor

        textView.font = UIFont.systemFont(ofSize: 14)

        textView.autocorrectionType = .no
        textView.smartInsertDeleteType = .no
        textView.keyboardAppearance = .dark
        textView.keyboardType = .default

        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 10)
        return textView
    }()
    var countLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "1 шт"
        return label
    }()
    var categoryLabel : UILabel = {
       var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Категория"
        return label
    }()
    var countStepper : UIStepper = {
       var stepper = UIStepper()
        stepper.maximumValue = 100
        stepper.minimumValue = 1
        stepper.value = 1
        stepper.stepValue = 1

        return stepper
    }()
    var pickerButton : UIButton = {
       var button = UIButton()
        button.setTitle("Выбрать", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    init(storageId: String) {
        self.storageId = storageId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white

        view.addSubview(productImage)
        view.addSubview(productNameTextField)
        view.addSubview(productDescriptionTextView)
        view.addSubview(countLabel)
        view.addSubview(categoryLabel)
        view.addSubview(countStepper)
        view.addSubview(pickerButton)

        productImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            productImage.widthAnchor.constraint(equalToConstant: 250),
            productImage.heightAnchor.constraint(equalToConstant: 250),
            productImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -180),
            productImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])

        productNameTextField.translatesAutoresizingMaskIntoConstraints = false
        productNameTextField.delegate = self

        NSLayoutConstraint.activate([
            productNameTextField.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 15),
            productNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            productNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            productNameTextField.heightAnchor.constraint(equalToConstant: 34)
        ])

        productDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        productDescriptionTextView.delegate = self
        NSLayoutConstraint.activate([
            productDescriptionTextView.topAnchor.constraint(equalTo: productNameTextField.bottomAnchor, constant: 15),
            productDescriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            productDescriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            productDescriptionTextView.heightAnchor.constraint(equalToConstant: 130)
        ])

        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: productDescriptionTextView.bottomAnchor, constant: 25),
            countLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            countLabel.widthAnchor.constraint(equalToConstant: 90),
            countLabel.heightAnchor.constraint(equalToConstant: 15)
        ])

        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 35),
            categoryLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            categoryLabel.widthAnchor.constraint(equalToConstant: 100),
            categoryLabel.heightAnchor.constraint(equalToConstant: 25)
        ])

        countStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countStepper.topAnchor.constraint(equalTo: productDescriptionTextView.bottomAnchor, constant: 20),
            countStepper.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            countStepper.widthAnchor.constraint(equalToConstant: 94),
            countStepper.heightAnchor.constraint(equalToConstant: 32)
        ])

        pickerButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pickerButton.topAnchor.constraint(equalTo: countStepper.bottomAnchor, constant: 20),
            pickerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            pickerButton.widthAnchor.constraint(equalToConstant: 94),
            pickerButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        countStepper.addTarget(self, action: #selector(stepperAction(sender:)), for: .valueChanged)

        pickerButton.addTarget(self, action: #selector(pushButtonAction), for: .touchUpInside)

        productImage.sd_setImage(with: product?.imageUrl)
        productNameTextField.text = product?.name
        productDescriptionTextView.text = product?.description
        productCount = product?.count ?? 1
        countStepper.value = Double(productCount)
        if let category = product?.category {
            pickerButton.setTitle(category.stringValue, for: .normal)
        }
        setupBarButtons()
    }

   @objc func stepperAction(sender: UIStepper){
       productCount = Int(sender.value)
    }

    @objc func pushButtonAction() {
        let controller = PickerViewController()
        let values = ProductCategory.allCases
        controller.values = values.compactMap({ $0.stringValue })
        controller.didSelectAction = { [weak self] index in
            let selectedValue = values[index]
            self?.selectedCategory = selectedValue
            self?.pickerButton.setTitle(selectedValue.stringValue, for: .normal)
        }
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .coverVertical
        present(controller, animated: true)
    }

    @objc func didPressDone(_ sender: Any) {
        guard let product = product else { return }
        let newProduct = Product(barCode: product.barCode, name: productNameTextField.text ?? "", imageUrl: product.imageUrl, count: productCount, description: productDescriptionTextView.text, category: selectedCategory ?? .other)

        SVProgressHUD.show()
        dataProvider.saveProduct(newProduct, storageId: storageId) { [weak self] error in
            SVProgressHUD.dismiss()
            self?.dismiss(animated: true)
            if error == nil {
                self?.didAddProduct?(true)
            }
        }
    }

    @objc func didPressCancel() {
        dismiss(animated: true)
        didAddProduct?(false)
    }

    private func setupBarButtons() {
        let topItem = navigationItem
        let barItemStyle: UIBarButtonItem.SystemItem
        switch mode {
        case .add:
            barItemStyle = .add
            topItem.setLeftBarButton(.init(barButtonSystemItem: .cancel, target: self, action: #selector(didPressCancel)), animated: true)
        case .edit:
            barItemStyle = .save
        }
        let barItem = UIBarButtonItem(barButtonSystemItem: barItemStyle, target: self, action: #selector(didPressDone(_:)))
        topItem.setRightBarButton(barItem, animated: true)
    }
}

extension ProductDetailsViewController: UITextFieldDelegate {

}

extension ProductDetailsViewController: UITextViewDelegate {

}
