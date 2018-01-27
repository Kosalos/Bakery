import Cocoa

var vc:ViewController!
var model:Model! = nil

class ViewController: NSViewController {
    
    @IBOutlet var backgroundView: Background!
    @IBOutlet var eGraph: GraphView!
    @IBOutlet var mGraph: GraphView!
    @IBOutlet var fGraph: GraphView!
    @IBOutlet var sGraph: GraphView!
    @IBOutlet var eInventory: InventoryView!
    @IBOutlet var mInventory: InventoryView!
    @IBOutlet var fInventory: InventoryView!
    @IBOutlet var sInventory: InventoryView!
    @IBOutlet var custProduct: ProductView!
    @IBOutlet var bredProduct: ProductView!
    @IBOutlet var cakeProduct: ProductView!
    @IBOutlet var cookProduct: ProductView!
    @IBOutlet var summary: SummaryView!
    @IBOutlet var computerView: ComputerView!
    
    @IBOutlet var eGraphBuy10: NSButton!
    @IBOutlet var eGraphBuy50: NSButton!
    @IBOutlet var eGraphBuy99: NSButton!
    @IBOutlet var mGraphBuy10: NSButton!
    @IBOutlet var mGraphBuy50: NSButton!
    @IBOutlet var mGraphBuy99: NSButton!
    @IBOutlet var fGraphBuy10: NSButton!
    @IBOutlet var fGraphBuy50: NSButton!
    @IBOutlet var fGraphBuy99: NSButton!
    @IBOutlet var sGraphBuy10: NSButton!
    @IBOutlet var sGraphBuy50: NSButton!
    @IBOutlet var sGraphBuy99: NSButton!

    @IBAction func custProfitIncrease(_ sender: NSButton) { model.human.product[CUST].alterProfit(+1) }
    @IBAction func custProfitDecrease(_ sender: NSButton) { model.human.product[CUST].alterProfit(-1) }
    @IBAction func custMake__Increase(_ sender: NSButton) { model.human.product[CUST].alterMakeAmount(+1) }
    @IBAction func custMake__Decrease(_ sender: NSButton) { model.human.product[CUST].alterMakeAmount(-1) }

    @IBAction func bredProfitIncrease(_ sender: NSButton) { model.human.product[BRED].alterProfit(+1) }
    @IBAction func bredProfitDecrease(_ sender: NSButton) { model.human.product[BRED].alterProfit(-1) }
    @IBAction func bredMake__Increase(_ sender: NSButton) { model.human.product[BRED].alterMakeAmount(+1) }
    @IBAction func bredMake__Decrease(_ sender: NSButton) { model.human.product[BRED].alterMakeAmount(-1) }

    @IBAction func cakeProfitIncrease(_ sender: NSButton) { model.human.product[CAKE].alterProfit(+1) }
    @IBAction func cakeProfitDecrease(_ sender: NSButton) { model.human.product[CAKE].alterProfit(-1) }
    @IBAction func cakeMake__Increase(_ sender: NSButton) { model.human.product[CAKE].alterMakeAmount(+1) }
    @IBAction func cakeMake__Decrease(_ sender: NSButton) { model.human.product[CAKE].alterMakeAmount(-1) }

    @IBAction func cookProfitIncrease(_ sender: NSButton) { model.human.product[COOK].alterProfit(+1) }
    @IBAction func cookProfitDecrease(_ sender: NSButton) { model.human.product[COOK].alterProfit(-1) }
    @IBAction func cookMake__Increase(_ sender: NSButton) { model.human.product[COOK].alterMakeAmount(+1) }
    @IBAction func cookMake__Decrease(_ sender: NSButton) { model.human.product[COOK].alterMakeAmount(-1) }
    
    @IBAction func computerProfitPlus(_ sender: NSButton)  { model.computer.alterComputerProfit(+1) }
    @IBAction func computerProfitMinus(_ sender: NSButton) { model.computer.alterComputerProfit(-1) }
    @IBAction func computerSpeedPlus(_ sender: NSButton)   { model.computer.alterComputerSpeed(+1) }
    @IBAction func computerSpeedMinus(_ sender: NSButton)  { model.computer.alterComputerSpeed(-1) }

    @IBAction func autoBuyE(_ sender: NSButton) { model.human.setAutoBuyFlag(EGG,sender.state == .on) }
    @IBAction func autoBuyM(_ sender: NSButton) { model.human.setAutoBuyFlag(MLK,sender.state == .on) }
    @IBAction func autoBuyF(_ sender: NSButton) { model.human.setAutoBuyFlag(FLR,sender.state == .on) }
    @IBAction func autoBuyS(_ sender: NSButton) { model.human.setAutoBuyFlag(SUG,sender.state == .on) }

    var timer = Timer()
    private var b:Bool = false

    @IBAction func buyButtonPress(_ sender: NSButton) {
        switch sender {
        case eGraphBuy10: model.human.buyIngredient(EGG,10)
        case eGraphBuy50: model.human.buyIngredient(EGG,50)
        case eGraphBuy99: model.human.buyIngredient(EGG,100)
        case mGraphBuy10: model.human.buyIngredient(MLK,10)
        case mGraphBuy50: model.human.buyIngredient(MLK,50)
        case mGraphBuy99: model.human.buyIngredient(MLK,100)
        case fGraphBuy10: model.human.buyIngredient(FLR,10)
        case fGraphBuy50: model.human.buyIngredient(FLR,50)
        case fGraphBuy99: model.human.buyIngredient(FLR,100)
        case sGraphBuy10: model.human.buyIngredient(SUG,10)
        case sGraphBuy50: model.human.buyIngredient(SUG,50)
        case sGraphBuy99: model.human.buyIngredient(SUG,100)
        default: break
        }
    }
    
    @IBAction func resetPressed(_ sender: NSButton) { model.reset() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc = self
        model = Model()
        
        custProduct.ptr = model.human.product[CUST]
        bredProduct.ptr = model.human.product[BRED]
        cakeProduct.ptr = model.human.product[CAKE]
        cookProduct.ptr = model.human.product[COOK]
        
        eInventory.index = EGG
        mInventory.index = MLK
        fInventory.index = FLR
        sInventory.index = SUG

        timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(ViewController.timerHandler), userInfo: nil, repeats:true)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        backgroundView.createGradientLayer()
    }
    
    override func viewDidAppear() {  view.window!.styleMask.remove(NSWindow.StyleMask.resizable)  }
    
    @objc func timerHandler() {
        model.update()
        
        summary.refresh()
        computerView.refresh()
        custProduct.refresh()
        bredProduct.refresh()
        cakeProduct.refresh()
        cookProduct.refresh()
        eGraph.refresh()
        mGraph.refresh()
        fGraph.refresh()
        sGraph.refresh()        
        eInventory.refresh()
        mInventory.refresh()
        fInventory.refresh()
        sInventory.refresh()

        eGraphBuy10.isEnabled = model.humanHasFunds(EGG,10)
        eGraphBuy50.isEnabled = model.humanHasFunds(EGG,50)
        eGraphBuy99.isEnabled = model.humanHasFunds(EGG,100)
        mGraphBuy10.isEnabled = model.humanHasFunds(MLK,10)
        mGraphBuy50.isEnabled = model.humanHasFunds(MLK,50)
        mGraphBuy99.isEnabled = model.humanHasFunds(MLK,100)
        fGraphBuy10.isEnabled = model.humanHasFunds(FLR,10)
        fGraphBuy50.isEnabled = model.humanHasFunds(FLR,50)
        fGraphBuy99.isEnabled = model.humanHasFunds(FLR,100)
        sGraphBuy10.isEnabled = model.humanHasFunds(SUG,10)
        sGraphBuy50.isEnabled = model.humanHasFunds(SUG,50)
        sGraphBuy99.isEnabled = model.humanHasFunds(SUG,100)
    }
    
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        let keyCode = event.charactersIgnoringModifiers!.uppercased()
        
        switch keyCode {
        case "A" : buyButtonPress(eGraphBuy10)
        case "B" : buyButtonPress(eGraphBuy50)
        case "C" : buyButtonPress(eGraphBuy99)
        case "D" : buyButtonPress(mGraphBuy10)
        case "E" : buyButtonPress(mGraphBuy50)
        case "F" : buyButtonPress(mGraphBuy99)
        case "G" : buyButtonPress(fGraphBuy10)
        case "H" : buyButtonPress(fGraphBuy50)
        case "I" : buyButtonPress(fGraphBuy99)
        case "J" : buyButtonPress(sGraphBuy10)
        case "K" : buyButtonPress(sGraphBuy50)
        case "L" : buyButtonPress(sGraphBuy99)
        case "M" : custProfitIncrease(eGraphBuy10)
        case "N" : custProfitDecrease(eGraphBuy10)
        case "O" : custMake__Increase(eGraphBuy10)
        case "P" : custMake__Decrease(eGraphBuy10)
        case "Q" : bredProfitIncrease(eGraphBuy10)
        case "R" : bredProfitDecrease(eGraphBuy10)
        case "S" : bredMake__Increase(eGraphBuy10)
        case "T" : bredMake__Decrease(eGraphBuy10)
        case "U" : cakeProfitIncrease(eGraphBuy10)
        case "V" : cakeProfitDecrease(eGraphBuy10)
        case "W" : cakeMake__Increase(eGraphBuy10)
        case "X" : cakeMake__Decrease(eGraphBuy10)
        case "Y" : cookProfitIncrease(eGraphBuy10)
        case "Z" : cookProfitDecrease(eGraphBuy10)
        case "1" : cookMake__Increase(eGraphBuy10)
        case "2" : cookMake__Decrease(eGraphBuy10)
        default  : break
        }
    }
}

