
import UIKit
import RealmSwift

protocol ShoppingListCollectionViewCellDelegate: class {
    func deleteButtonDidTapped(_ tag: Int)
    func discountButtonDidTapped(_ tag: Int)
}

class ShoppingListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var discountButton: UIButton!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var numberDecreaseButton: UIButton!
    @IBOutlet weak private var numberIncreaseButton: UIButton!
    @IBOutlet weak private var numberLabel: UILabel!
    
    private var objects: Results<Calculation>! { CalculationRealmRepository.shared.objects }
    
    var delegate: ShoppingListCollectionViewCellDelegate?
    
    @IBAction func deleteButtonDidTapped(_ sender: UIButton) {
        delegate?.deleteButtonDidTapped(sender.tag)
    }
    
    @IBAction func discountButtonDidTapped(_ sender: UIButton) {
        delegate?.discountButtonDidTapped(sender.tag)
    }
    
    @IBAction func numberDecreaseButtonDidTapped(_ sender: UIButton) {
        if objects[sender.tag].shoppingListCount > 1 {
            CalculationRealmRepository.shared.update {
                objects[sender.tag].shoppingListCount -= 1
            }
        }
        numberLabel.text = "×\(objects[sender.tag].shoppingListCount)"
    }
    
    @IBAction func numberIncreaseButtonDidTapped(_ sender: UIButton) {
        CalculationRealmRepository.shared.update {
            objects[sender.tag].shoppingListCount += 1
        }
        numberLabel.text = "×\(objects[sender.tag].shoppingListCount)"
    }
    
    func setupCell(object: Calculation) {
        let discountButtonTitle = (object.shoppingListDiscount != 0) ? "-\(object.shoppingListDiscount)%" : "割引"
        discountButton.setTitle(discountButtonTitle, for: .normal)
        priceLabel.text = "\(String(object.price).addComma())円"
        numberLabel.text = "×\(object.shoppingListCount)"
        deleteButton.tintColor = UIColor.black.themeColor
        layer.cornerRadius = 30
        layer.borderColor = UIColor.black.themeColor.cgColor
        layer.borderWidth = 2
    }
    
    func setTag(index: Int) {
        deleteButton.tag = index
        discountButton.tag = index
        numberDecreaseButton.tag = index
        numberIncreaseButton.tag = index
    }
    
}
