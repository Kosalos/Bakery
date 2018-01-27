import Cocoa

enum YaxisStyle { case fixed,auto }

class GraphView: NSView {
    var g = Graphics()
    var yAxisStyle:YaxisStyle = .auto
    var yAxisMin:CGFloat = 0
    var yAxisMax:CGFloat = 100
    var yScale:CGFloat =  0
    var yHop:CGFloat = 0
    var yLegendWidth:CGFloat = 70
    var title:String = "TitleString"
    let formatString:String = "$%4.2f"
    var data1ptr:CircularBuffer! = nil
    var data2ptr:CircularBuffer! = nil
    var data1Color:CGColor = colorRed
    var data2Color:CGColor = colorYellow
    var data1LineWidth:CGFloat = 2
    var data2LineWidth:CGFloat = 1
    var xSize:CGFloat = 0
    var ySize:CGFloat = 0
    var rect:CGRect!

    override var isFlipped: Bool { return true }
    
    func initialize(_ name:String, _ d1:CircularBuffer, _ d2:CircularBuffer) {
        title = name
        data1ptr = d1
        data2ptr = d2
    }
    
    // MARK: -
    
    func yCoord(_ data:CGFloat) -> CGFloat { return ySize - (data - yAxisMin) * yScale }
    
    func drawBorder() {
        g.drawBorder(rect)
        
        let p1:CGPoint = CGPoint(x:xSize - yLegendWidth, y:1)
        let p2:CGPoint = CGPoint(x:xSize - yLegendWidth, y:ySize)
        g.drawLine(p1,p2,colorWhite)
    }
    
    func drawYaxis() {
        var p1:CGPoint = CGPoint(x:2, y:1)
        var p2:CGPoint = CGPoint(x:xSize - yLegendWidth, y:1)
        var p3:CGPoint = CGPoint(x:xSize - yLegendWidth + 10, y:1)

        g.stringXJ = .right
        g.stringYJ = .center
        g.stringFontSize = 16
        g.stringColor = NSColor.white
        g.stringPrepare()

        let iMin = (Int(yAxisMin) / 5) * 5
        var value = CGFloat(iMin)
        
        while true {
            if value > yAxisMin+1 && value < yAxisMax-1 {
                p1.y = yCoord(value)
                p2.y = p1.y
                p3.y = p1.y
                g.drawLine(p1,p2,colorGray2)
                g.drawLine(p2,p3,colorWhite)
                
                g.drawString(String(format:formatString,Float(value)), xSize - 5, p3.y)
            }
            
            value += yHop
            if value >= yAxisMax { break }
        }
    }

    let xMargin:CGFloat = 20
    
    func drawTitle() {
        g.stringXJ = .left
        g.stringYJ = .top
        g.stringFontSize = 20
        g.stringColor = NSColor.white
        g.stringPrepare()
        
        g.drawString(title,xMargin,10)
    }

    func drawData1ValueString() {
        let value = data1ptr == nil ? 0 : data1ptr.currentValue()
        g.stringFontSize = 40
        g.stringPrepare()
        g.drawString(String(format:formatString,Float(value)),xMargin, 40)
    }

    func drawData(_ data:CircularBuffer, _ width:CGFloat, _ color:CGColor) {
        let numVisiblePoints = Int(xSize - yLegendWidth - 2)
        let path:CGMutablePath = CGMutablePath()
        var pt:CGPoint = CGPoint()
        var markedPositions:[CGPoint] = []  // positions where yellow circles will be drawn
        var marked = false

        pt.x = xSize - yLegendWidth - 1
        pt.y = yCoord(data.currentValue())
        path.move( to: pt)

        for i in 1 ..< numVisiblePoints {
            pt.x -= 1
            
            var v = data.previousValue(-i)      // negative values are 'marked' entries
            marked = false
            if v < 0 { v = -v; marked = true }
            
            pt.y = yCoord(v)
            path.addLine(to: pt)
            
            if marked { markedPositions.append(pt) }
        }

        g.drawLineSet(path,width,color)

        if markedPositions.count > 0 {
            let sz:CGFloat = 4
            let path:CGMutablePath = CGMutablePath()
            
            for i in 0 ..< markedPositions.count {
                let pt = markedPositions[i]
                path.addEllipse(in: CGRect(x: pt.x - sz, y: pt.y - sz, width:sz * 2, height:sz * 2))
            }

            g.drawFilledPath(path,color)
        }
    }
    
    // MARK: - draw
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if xSize == 0 {
            xSize = bounds.width - 2
            ySize = bounds.height - 2
            rect = CGRect(x: 1, y: 1, width: xSize, height: ySize)
        }

        // strive to keep current data point in center of Y axis
        if yAxisStyle == .auto {
            let value = data1ptr == nil ? 0 : data1ptr.currentValue()
            var nMin = value - 25
            if nMin < -5 { nMin = -5 }
            
            let diff = CGFloat(nMin) - yAxisMin
            if diff > +20 { yAxisMin += 0.5 } else if diff < -20 { yAxisMin -= 0.5 }
            if diff > +5 { yAxisMin += 0.2 } else if diff < -5 { yAxisMin -= 0.2 }
            
            yAxisMax = yAxisMin + 50
            yScale = ySize / (yAxisMax - yAxisMin)
            yHop = (yAxisMax - yAxisMin) / 10
        }

        g.setContext(NSGraphicsContext.current!)
        g.drawFilledRect(bounds,colorBlack)
        
        drawYaxis()
        
        if let data1ptr = data1ptr { drawData(data1ptr,data1LineWidth,data1Color) }
        if let data2ptr = data2ptr { drawData(data2ptr,data2LineWidth,data2Color) }

        drawTitle()
        drawData1ValueString()
        drawBorder()
    }
    
    func refresh() { self.setNeedsDisplay(bounds) }
}
