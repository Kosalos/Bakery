import Foundation

let EGG:Int = 0    // egg
let MLK:Int = 1    // milk
let FLR:Int = 2    // flour
let SUG:Int = 3    // sugar
let NUM_INGREDIENTS:Int = 4

let CUST:Int = 0    // cust
let BRED:Int = 1    // bread
let CAKE:Int = 2    // cake
let COOK:Int = 3    // cookie
let NUM_PRODUCTS:Int = 4

let iName:[String] = ["Eggs","Milk","Flour","Sugar"]
let pName:[String] = ["Custard","Bread","Cake","Cookie"]

let STARTING_FUNDS:CGFloat = 10000

class IngredientPriceData {
    let data:CircularBuffer = CircularBuffer()
    let data2:CircularBuffer = CircularBuffer()
    var inventory:CGFloat = 0
    var avgCost:CGFloat = 0
    
    func reset() {
        inventory = 0
        avgCost = 0
        data.reset()
        data2.reset()
    }
}

class IngredientData {
    var inventory:CGFloat = 0
    var avgCost:CGFloat = 0
    
    func reset() {
        inventory = 0
        avgCost = 0
    }
}

// MARK: -

class Model {
    let human:Baker = Baker(isTheComputer:false)
    let computer:Baker = Baker(isTheComputer:true)
    var ingredientPrice:[IngredientPriceData] = []
    
    init() {
        // dimension circular buffers
        for _ in 0 ..< NUM_INGREDIENTS { ingredientPrice.append(IngredientPriceData()) }
        
        // attach to graph views
        vc.eGraph.initialize(iName[EGG], ingredientPrice[EGG].data, ingredientPrice[EGG].data2)
        vc.mGraph.initialize(iName[MLK], ingredientPrice[MLK].data, ingredientPrice[MLK].data2)
        vc.fGraph.initialize(iName[FLR], ingredientPrice[FLR].data, ingredientPrice[FLR].data2)
        vc.sGraph.initialize(iName[SUG], ingredientPrice[SUG].data, ingredientPrice[SUG].data2)
    }

    func humanHasFunds(_ index:Int, _ amount:CGFloat) -> Bool { return human.funds >= ingredientPrice[index].data.currentValue() * amount }
    
    func reset() {
        human.reset()
        computer.reset()
        for i in ingredientPrice { i.reset() }
    }

    func update() {
        for i in ingredientPrice {
            i.data.addRandomTrendingValue()
            i.data2.addSmoothedValue(i.data.currentValue())
        }
        
        human.autoBuy()
        human.makeAndSell()

        computer.process()
    }
}

func fRandom(_ vmin:CGFloat, _ vmax:CGFloat) -> CGFloat {
    let ratio = CGFloat(arc4random() & 1023) / CGFloat(1024)
    return vmin + (vmax - vmin) * ratio
}

