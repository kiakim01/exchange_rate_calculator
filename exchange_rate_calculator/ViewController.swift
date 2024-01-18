//
//  ViewController.swift
//  exchange_rate_calculator
//
//  Created by kiakim on 1/17/24.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    enum CurrencyType : String, CaseIterable {
        case KRW = "한국(KRW)"
        case JPY = "일본(JPY)"
        case PHP = "필리핀(PHP)"
    }

    
    let viewContainer = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let screenTitle = {
        let label = UILabel()
        label.text = "환율 계산"
        label.font = UIFont.systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let contentsBox = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emptyView = UIView()
    
    let sendCountryLine = {
        let label = UILabel()
        label.text = "송금 국가 : 미국(USD)"
        return label
    }()
    
    let recipientCoutryLine = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    let recipentLable = {
        let label = UILabel()
        label.text = "수취 국가 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let recipentCountryButton = {
        let button = UIButton()
                button.setTitle("한국(KRW) ▼ ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(selecCurrency), for: .touchUpInside)
        return button
    }()
    
    let emptyView2 = UIView()
    
    
    let exchangeRateLine = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    let exchangeRateLabel = {
        let label = UILabel()
        label.text = "환율 : "
        return label
    }()
    
        
    let exchangeRatePrice = {
        let label = UILabel()
        label.text = "11,223,323 "
        return label
    }()

    
    let exchangeRateCurrency = {
        let label = UILabel()
        label.text = "KRW"
        return label
    }()
    
    let exchangeRateUSD = {
        let label = UILabel()
        label.text = "/ USD"
        return label
    }()
    
    let timeLine = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    let timeLabel = {
        let label = UILabel()
        label.text = "조회시간: "
        return label
    }()
    
    let timeValue = UILabel()
    
    let remittanceLine = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    let remittanceLabel = {
        let label = UILabel()
        label.text = "송금액 : "
        return label
    }()
    
    let remittanceTextField = {
        let textField = UITextField()
        textField.placeholder = "입력"
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    let remittancefiexdUSD = {
        let label = UILabel()
        label.text = "USD"
        return label
        
    }()
    
    let emptyView3 = UIView()
    
    
    let checkLine = {
        let view = UIView()
           return view
    }()
    
    let checkCenterBox = {
        let view = UIStackView()
        view.axis = .horizontal
         view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let checkfiexdWords = {
        let label = UILabel()
        label.text = "수취금액은"
        label.textAlignment = .right
        return label
    }()
    
    
    //    let checkCalculatedValues = UILabel()
    
    let checkCalculatedValues = {
        let label = UILabel()
        label.text = "333,333,333"
        label.textAlignment = .center
//        label.layer.borderWidth = 1
        return label
    }()
    
    let checkCurrency = {
        let label = UILabel()
        label.text = "KRW"
        label.textAlignment = .center
//        label.layer.borderWidth = 1
        return label
    }()
    
    let checkfiexdWords2 = {
        let label = UILabel()
        label.text = "입니다."
        label.textAlignment = .left
//        label.layer.borderWidth = 1
        return label
    }()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        
        getExchangeRate{ result in
            if result {
                self.setupUI()
                self.updateTime()
            }
            
        }
        
    }
    
    func updateTime(){
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        //조회시간 조정
        let currentTime = Date()
        let formattedTime = dateFormatter.string(from: currentTime)
        
        timeValue.text = formattedTime
    }
    
    @objc func selecCurrency(){
        print(#function)
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        view.addSubview(pickerView)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
        
        pickerView.isHidden = false
        
        
    }
    
    
}
//pickerView
extension ViewController {
    //열(가로)의 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //행(세로)의 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CurrencyType.allCases.count
    }
    //컬럼의 내용
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CurrencyType.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selectedCurrency = pickerView.delegate?.pickerView?(pickerView, titleForRow: row, forComponent: component) else {
            return
        }
        
        if let currencyType = CurrencyType(rawValue: selectedCurrency) {
            recipentCountryButton.setTitle(selectedCurrency, for: .normal)
            
            exchangeRateCurrency.text = String(describing: currencyType)
            checkCurrency.text = String(describing: currencyType)
        }
        
        pickerView.isHidden = true
        
        
    }
    
    
}
//UI
extension ViewController{
    func setupUI(){
        view.addSubview(viewContainer)
        viewContainer.addSubview(screenTitle)
        viewContainer.addSubview(contentsBox)
        contentsBox.addArrangedSubview(sendCountryLine)
        contentsBox.addArrangedSubview(recipientCoutryLine)
        contentsBox.addArrangedSubview(exchangeRateLine)
        contentsBox.addArrangedSubview(timeLine)
        contentsBox.addArrangedSubview(remittanceLine)
        contentsBox.addArrangedSubview(emptyView)
        contentsBox.addArrangedSubview(checkLine)
        recipientCoutryLine.addArrangedSubview(recipentLable)
        recipientCoutryLine.addArrangedSubview(recipentCountryButton)
        recipientCoutryLine.addArrangedSubview(emptyView2)
        exchangeRateLine.addArrangedSubview(exchangeRateLabel)
        exchangeRateLine.addArrangedSubview(exchangeRatePrice)
        exchangeRateLine.addArrangedSubview(exchangeRateCurrency)
        exchangeRateLine.addArrangedSubview(exchangeRateUSD)
        
        timeLine.addArrangedSubview(timeLabel)
        timeLine.addArrangedSubview(timeValue)
        
        remittanceLine.addArrangedSubview(remittanceLabel)
        remittanceLine.addArrangedSubview(remittanceTextField)
        remittanceLine.addArrangedSubview(remittancefiexdUSD)
        remittanceLine.addArrangedSubview(emptyView3)
        
        checkLine.addSubview(checkCenterBox)
        checkCenterBox.addArrangedSubview(checkfiexdWords)
        checkCenterBox.addArrangedSubview(checkCalculatedValues)
        checkCenterBox.addArrangedSubview(checkCurrency)
        checkCenterBox.addArrangedSubview(checkfiexdWords2)
        
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: 15),
            viewContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            screenTitle.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
            screenTitle.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            screenTitle.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            contentsBox.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 20),
            contentsBox.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 20),
            contentsBox.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -20),
            contentsBox.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -20)
            
        ])
        
        NSLayoutConstraint.activate([
            checkLine.heightAnchor.constraint(equalTo: contentsBox.heightAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            checkCenterBox.centerXAnchor.constraint(equalTo: checkLine.centerXAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            remittanceTextField.widthAnchor.constraint(equalToConstant: 100)])
    }
}
