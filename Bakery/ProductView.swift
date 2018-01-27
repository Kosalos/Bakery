import Cocoa

class ProductView: NSView {
    var g = Graphics()
    var ptr:ProductData!
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
        
        ptr.calcUnitCost()

        g.setContext(NSGraphicsContext.current!)
        g.drawFilledRect(bounds,colorGray1)
        g.drawBorder(rect)

        g.stringXJ = .left
        g.stringYJ = .top
        g.stringFontSize = 30
        g.stringColor = NSColor.yellow
        g.stringPrepare()
        
        g.drawString(ptr.name,10,5)

        let x:CGFloat = 230
        let yingredients:CGFloat = 40
        let ycost:CGFloat = 60
        let ysale:CGFloat = 90
        let ymake:CGFloat = 115
        let yinventory:CGFloat = 140
        let ypurchased:CGFloat = 165
        
        g.stringFontSize = 13
        g.stringPrepare()
        
        g.drawString(ptr.ingredients,10,yingredients)
        
        g.stringFontSize = 20
        g.stringColor = NSColor.white
        g.stringPrepare()
        
        if ptr.unitCost > 0 {
            g.drawString(String(format:"Profit %5.2f",ptr.profitMargin),250,85)
        }

        g.drawString("Unit Cost",   10,ycost)
        g.drawString("Sale Price",  10,ysale)
        g.drawString("Make Amount", 10,ymake)
        g.drawString("Inventory",   10,yinventory)
        g.drawString("Purchased",   10,ypurchased)

        g.stringXJ = .right
        g.stringPrepare()
        
        g.drawString(String(format:"$%5.2f",ptr.unitCost),x,ycost)
        g.drawString(String(format:"$%5.2f",ptr.salePrice),x,ysale)
        g.drawString(String(format:"%d",Int(ptr.makeAmount)),x,ymake)
        g.drawString(String(format:"%d",Int(ptr.inventory)),x,yinventory)
        g.drawString(String(format:"%d",Int(ptr.purchased)),x,ypurchased)
        
    }
    
    func refresh() { self.setNeedsDisplay(bounds) }
}
