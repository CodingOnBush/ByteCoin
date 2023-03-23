import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  @IBOutlet weak var bitcoinLabel: UILabel!
  @IBOutlet weak var currencyLabel: UILabel!
  @IBOutlet weak var currencyPicker: UIPickerView!
  
  var coinManager = CoinManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    coinManager.delegate = self
    currencyPicker.dataSource = self
    currencyPicker.delegate = self
    
    currencyLabel.text = coinManager.currencyArray[0]
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return coinManager.currencyArray[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let selectedCurrency = coinManager.currencyArray[row]
    coinManager.getCoinPrice(for: selectedCurrency)
    currencyLabel.text = selectedCurrency
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return coinManager.currencyArray.count
  }
}

extension ViewController: CoinManagerDelegate {
  func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
    DispatchQueue.main.async {
      self.bitcoinLabel.text = String(format: "%.2f", coin.rate)
    }
  }
  
  func didFailWithError(error: Error) {
    print(error)
  }
}
