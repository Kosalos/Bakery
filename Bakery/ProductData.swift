import Foundation

class ProductData {
    var parent:Baker!
    var name:String!
    var ingredients:String!
    var iCount:[CGFloat] = []  // # of each ingredient
    var unitCost:CGFloat = 0
    var salePrice:CGFloat = 10
    var makeAmount:CGFloat = 0
    var inventory:CGFloat = 0
    var purchased:CGFloat = 0
    var profitMargin:CGFloat = 1.0
    
    init() {
        for _ in 0 ..< NUM_PRODUCTS {
            iCount.append(CGFloat())
        }
    }
    
    func initialize(_ bparent:Baker, _ nname:String, _ e:CGFloat, _ m:CGFloat, _ f:CGFloat, _ s:CGFloat) {
        parent = bparent
        name = nname
        iCount[EGG] = e
        iCount[MLK] = m
        iCount[FLR] = f
        iCount[SUG] = s

        ingredients = String(format:"%.1f eggs, %.1f milk, %.1f flour, %.1f sugar",iCount[EGG],iCount[MLK],iCount[FLR],iCount[SUG])
    }
    
    func reset() {
        salePrice = 10
        makeAmount = 0
        inventory = 0
        purchased = 0
        unitCost = 0
    }
    
    func alterProfit(_ dir:Int) {
        profitMargin += CGFloat(dir) * 0.05
        if profitMargin < 0 { profitMargin = 0 }
        
        calcUnitCost()
    }
    
    func alterMakeAmount(_ dir:Int) {
        makeAmount += CGFloat(dir)
        if makeAmount < 0 { makeAmount = 0 }
    }
    
    func autoMake() {
        if inventory > 0 { return }     // only auto make when there is no inventory
        if makeAmount == 0 { return }   // this product is not being made
        
        func canMake() -> Bool {
            for i in 0 ..< NUM_INGREDIENTS { // enough ingredients?
                if parent.ingredient[i].inventory < iCount[i] { return false }
            }

            for i in 0 ..< NUM_INGREDIENTS { // acquire ingredients
                parent.ingredient[i].inventory -= iCount[i]
            }
            
            inventory += 1
            return true
        }
        
        for _ in 0 ..< Int(makeAmount) {
            if !canMake() { break }
        }
    }
    
    // MARK: -
    
    func calcUnitCost() {
        unitCost = 0
        for i in 0 ..< NUM_INGREDIENTS {
            unitCost += iCount[i] * parent.ingredient[i].avgCost
        }
        
        salePrice = unitCost * profitMargin
    }
    
    // sale Price   Cost    Ratio   Percent
    // 1            10      0.1     145
    // 5            10      0.5     125
    // 10           10      1.0     100
    // 15           10      1.5      75
    // 20           10      2.0      50
    // 25           10      2.5      25
    // 30           10      3.0       0
    
    func sell(_ index:Int) {
        if salePrice == 0 { return }  // nonsense
        if unitCost  == 0 { return }

        let ratio:CGFloat = salePrice / unitCost
        let salePercent:CGFloat = (CGFloat(1.5) - ratio / 2) * 10

        for _ in 0 ..< 10 {                 // multiple sales attempts
            if inventory == 0 { return }    // nothing to sell
    
            if fRandom(0,130) < salePercent {
                inventory -= 1
                purchased += 1
                parent.funds += salePrice
                
                if parent.isComputer { vc.computerView.addStatusString(String(format:"* sold %@",pName[index])) }
            }
        }
    }
}

