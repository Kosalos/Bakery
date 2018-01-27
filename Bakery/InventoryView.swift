import Cocoa

class InventoryView: NSView {
    var g = Graphics()
    var index:Int = 0
    var xSize:CGFloat = 0
    var ySize:CGFloat = 0
    var rect:CGRect!

    override var isFlipped: Bool { return true }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if xSize == 0 {
            xSize = bounds.width - 2
            ySize = bounds.height - 2
            rect = CGRect(x: 1, y: 1, width: xSize, height: ySize)
        }

        let ptr = model.human.ingredient[index]
        
        g.setContext(NSGraphicsContext.current!)
        g.drawFilledRect(bounds,ptr.inventory >= 5 ? colorGreenTint : colorRedTint)
        g.drawBorder(rect)

        g.stringXJ = .right
        g.stringYJ = .top
        g.stringFontSize = 24
        g.stringColor = NSColor.white
        g.stringPrepare()
        
        g.drawString(String(format:"%5.2f",ptr.inventory),xSize-5,5)

        g.stringXJ = .left
        g.stringFontSize = 16
        g.stringPrepare()
        g.drawString("Avg.",10,36)
        
        g.stringXJ = .right
        g.stringPrepare()
        g.drawString(String(format:"$%5.2f",ptr.avgCost),xSize-5,36)
    }
    
    func refresh() { self.setNeedsDisplay(bounds) }
    
    // click on inventory box to sell half the inventory for half price. (to avoid bankrupcy)
    override func mouseDown(with event: NSEvent) {
        let sellAmount = model.human.ingredient[index].inventory / 2
        
        model.human.ingredient[index].inventory -= sellAmount
        if model.human.ingredient[index].inventory < 1 { model.human.ingredient[index].inventory = 0 }
        
        model.human.funds += sellAmount * model.human.ingredient[index].avgCost / 2
    }

}
