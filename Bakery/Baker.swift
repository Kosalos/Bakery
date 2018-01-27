import Foundation

class Baker {
    var isComputer:Bool = false
    var funds:CGFloat = 0
    var ingredient:[IngredientData] = []
    var product:[ProductData] = []
    var autoBuyFlag:[Bool] = []
    
    init(isTheComputer:Bool) {
        isComputer = isTheComputer
        
        for _ in 0 ..< NUM_INGREDIENTS {
            ingredient.append(IngredientData())
            autoBuyFlag.append(Bool())
        }
        
        for _ in 0 ..< NUM_PRODUCTS { product.append(ProductData()) }
        
        product[CUST].initialize(self,pName[CUST],6,3,1,2)
        product[BRED].initialize(self,pName[BRED],2,1.5,6,1)
        product[CAKE].initialize(self,pName[CAKE],3,2,4,4)
        product[COOK].initialize(self,pName[COOK],2,1,5,6)
        
        reset()
    }
    
    func reset() {
        funds = STARTING_FUNDS
        for i in ingredient { i.reset() }
        for i in product { i.reset() }
        
        if isComputer { vc.computerView.addStatusString("Reset") }
    }
    
    func makeAndSell() {
        for i in 0 ..< NUM_PRODUCTS {
            product[i].autoMake()
            product[i].sell(i)
        }
    }
    
    func setAutoBuyFlag(_ index:Int, _ onoff:Bool) {
        autoBuyFlag[index] = onoff
    }
    
    // MARK: -
    
    @discardableResult func buyIngredient(_ index:Int, _ amount:CGFloat) -> Bool {
        let ptr = model.ingredientPrice[index]
        let totalCost = ptr.data.currentValue() * amount
        
        if totalCost > funds { return false }     // keyDown at illegal time
        
        ingredient[index].avgCost = (ptr.avgCost * ptr.inventory + totalCost) / (ptr.inventory + amount)
        ingredient[index].inventory += amount
        funds -= totalCost
        
        if !isComputer { ptr.data2.markEntry(-1) }  // yellow circles on data line mark human purchases
        return true
    }
    
    func autoBuyIngredient(_ index:Int) {
        if !autoBuyFlag[index] { return }
        
        let amount:CGFloat = 10
        if ingredient[index].inventory >= amount { return }
        
        buyIngredient(index,amount)
    }

    func autoBuy() {
        for i in 0 ..< NUM_INGREDIENTS {
            autoBuyIngredient(i)
        }
    }

    // MARK: Computer Related =========================
    var computerSlowDown:Int = 0
    var computerSlowDownPace:Int = 10
    var computerProfitMargin:CGFloat = 1.05
    var computerState:Int = 0
    
    func alterComputerProfit(_ dir:Int) {
        computerProfitMargin += CGFloat(dir) * 0.05
        if computerProfitMargin < 1 { computerProfitMargin = 1 }
        vc.computerView.addStatusString(String(format:"Set profit margin to %.2f",computerProfitMargin))
    }
    
    func alterComputerSpeed(_ dir:Int) {
        computerSlowDownPace -= dir
        if computerSlowDownPace < 1 { computerSlowDownPace = 1 }
    }
    
    // MARK: -
    
    func process() {
        computerSlowDown += 1
        if computerSlowDown < computerSlowDownPace { return }
        computerSlowDown = 0
    
        func addToComputerInventory(_ index:Int) {
            if ingredient[index].inventory < 10 {
                if buyIngredient(index,10) {
                    vc.computerView.addStatusString(String(format:"Bought 10 %@",iName[index]))
                }
            }
        }
        
        func adjustComputerSalePrice(_ index:Int) {
            product[index].calcUnitCost()
            
            let p = product[index].salePrice    // already have the correct sales price?
            let c = product[index].unitCost
            if p == c * computerProfitMargin { return }
            
            product[index].salePrice = product[index].unitCost * computerProfitMargin
            vc.computerView.addStatusString(String(format:"Set %@ sale price to $%.2f",pName[index],product[index].salePrice))
        }
        
        func bakeComputerProduct(_ index:Int) {
            if product[index].inventory == 0 {
                product[index].makeAmount = 1
                vc.computerView.addStatusString(String(format:"Baked %@",pName[index]))
            }
            else {
                product[index].makeAmount = 0
            }
        }

        switch computerState {
        case 0,1,2,3   : addToComputerInventory(computerState)
        case 4,5,6,7   : adjustComputerSalePrice(computerState-4)
        case 8,9,10,11 : bakeComputerProduct(computerState-8)
        default : computerState = -1
        }
        
        computerState += 1
        
        makeAndSell()
    }
}
