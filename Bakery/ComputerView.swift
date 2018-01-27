import Cocoa

class ComputerView: NSView {
    var g = Graphics()
    var xSize:CGFloat = 0
    var ySize:CGFloat = 0
    var rect:CGRect!
    let NUMSTATUS:Int = 7
    let sx:CGFloat = 10
    let sy:CGFloat = 5
    let yhop:CGFloat = 15
    var status:[String] = []

    override var isFlipped: Bool { return true }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        for _ in 0 ..< NUMSTATUS { status.append(String()) }
    }

    func addStatusString(_ s:String) {
        for i in 0 ..< NUMSTATUS-1 { status[i] = status[i+1] }
        status[NUMSTATUS-1] = s
    }

    func drawStatusStrings() {
        g.stringXJ = .left
        g.stringYJ = .top
        g.stringFontSize = 15
        g.stringColor = NSColor.white
        g.stringPrepare()

        var y = sy
        for i in 0 ..< NUMSTATUS {
            g.drawString(status[i],sx,y)
            y += yhop
        }
    }
    
    // MARK: -

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if xSize == 0 {
            xSize = bounds.width - 2
            ySize = bounds.height - 2
            rect = CGRect(x: 1, y: 1, width: xSize, height: ySize)
        }
        
        g.setContext(NSGraphicsContext.current!)
        g.drawFilledRect(bounds,model.computer.funds >= STARTING_FUNDS ? colorGreenTint : colorRedTint)
        g.drawBorder(rect)
        
        drawStatusStrings()

        g.stringFontSize = 20
        g.stringPrepare()
        g.drawString(String(format:"Funds   $%7.2f",model.computer.funds),380,10)
        g.drawString(String(format:"Profit    %0.2f",model.computer.computerProfitMargin),380,30)
    }
    
    func refresh() { self.setNeedsDisplay(bounds) }
}

