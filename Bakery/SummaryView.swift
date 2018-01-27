import Cocoa
import simd

class SummaryView: NSView {
    var g = Graphics()
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
        
        g.setContext(NSGraphicsContext.current!)
        g.drawFilledRect(bounds,model.human.funds >= STARTING_FUNDS ? colorGreenTint : colorRedTint)
        g.drawBorder(rect)

        g.stringXJ = .left
        g.stringYJ = .top
        g.stringFontSize = 40
        g.stringColor = NSColor.white
        g.stringPrepare()
        g.drawString("Funds",10,17)

        g.stringXJ = .right
        g.stringPrepare()
        g.drawString(String(format:"$%5.2f",model.human.funds),xSize-10,20)
    }
    
    func refresh() { self.setNeedsDisplay(bounds) }
    
    let pi2:Float = 1.5708
}
