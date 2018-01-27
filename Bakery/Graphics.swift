import Cocoa

let colorWhite = NSColor(red:1, green:1, blue:1, alpha:1).cgColor
let colorYellow = NSColor(red:1, green:1, blue:0, alpha:1).cgColor
let colorBlue = NSColor(red:0, green:0.3, blue:1, alpha:1).cgColor
let colorRed = NSColor(red:0.75, green:0.1, blue:0, alpha:1).cgColor
let colorGreen = NSColor(red:0, green:0.75, blue:0, alpha:1).cgColor
let colorBlack = NSColor(red:0, green:0, blue:0, alpha:1).cgColor
let colorRedTint = NSColor(red:0.2, green:0.1, blue:0.1, alpha:1).cgColor
let colorGreenTint = NSColor(red:0, green:0.2, blue:0, alpha:1).cgColor

let colorGray1 = NSColor(red:0.1, green:0.1, blue:0.1, alpha:1).cgColor
let colorGray2 = NSColor(red:0.4, green:0.4, blue:0.4, alpha:1).cgColor
let colorGray3 = NSColor(red:0.7, green:0.7, blue:0.7, alpha:1).cgColor

let font = NSFont.init(name: "Helvetica", size: 10)!

enum StringXJustify { case left,center,right }
enum StringYJustify { case top,center,bottom }

class Graphics {
    var context:CGContext!
    var stringXJ:StringXJustify = .left
    var stringYJ:StringYJustify = .center
    var stringFontSize:CGFloat = 16
    var stringColor:NSColor = .white
    var stringFont:NSFont!
    var stringAtts:[NSAttributedStringKey : Any]!

    func setContext(_ c:NSGraphicsContext) { context = c.cgContext }
    
    func stringPrepare() {
        stringFont = NSFont.init(name: "Helvetica", size:CGFloat(stringFontSize))!
        
        stringAtts = [
            NSAttributedStringKey.font:stringFont,
            NSAttributedStringKey.foregroundColor: stringColor]
    }
    
    func drawString(_ str:String, _ x:CGFloat, _ y:CGFloat) {
        let sz = str.drawSize(stringFont)
        var x = x
        var y = y - 2
        
        switch stringXJ {
        case .left : break
        case .center : x -= sz.width/2
        case .right : x -= sz.width
        }
        
        switch stringYJ {
        case .top : break
        case .center : y -= sz.height/2
        case .bottom : y -= sz.height
        }
        
        str.draw(at:NSMakePoint(x,y), withAttributes: stringAtts)
    }
    
    func stringDisplayWidth(_ str:String) -> CGFloat {
        return str.drawSize(font).width
    }
    
    func drawFilledRect(_ rect:CGRect, _ fillColor: CGColor) {
        let path = CGMutablePath()
        path.addRect(rect)
        
        context.beginPath()
        context.setFillColor(fillColor)
        context.addPath(path)
        context.drawPath(using:.fill)
    }
    
    func drawRect(_ rect:CGRect, _ strokeColor: CGColor) {
        let path = CGMutablePath()
        path.addRect(rect)
        
        context.beginPath()
        context.setStrokeColor(strokeColor)
        context.addPath(path)
        context.drawPath(using:.stroke)
    }
    
    func drawBorder(_ rect:CGRect) {
        let p1  = CGPoint(x:rect.minX, y:rect.minY)
        let p2  = CGPoint(x:rect.minX + rect.width, y:rect.minY)
        let p3  = CGPoint(x:rect.minX + rect.width, y:rect.minY + rect.height)
        let p4  = CGPoint(x:rect.minX, y:rect.minY + rect.height)

        func line(_ p1:CGPoint, _ p2:CGPoint, _ strokeColor:CGColor) {
            let path = CGMutablePath()
            path.move( to: p1)
            path.addLine(to: p2)
            
            context.beginPath()
            context.setStrokeColor(strokeColor)
            context.addPath(path)
            context.drawPath(using:.stroke)
        }

        context.setLineWidth(3)
        line(p1,p2,colorGray1)
        line(p1,p4,colorGray1)
        line(p2,p3,colorGray3)
        line(p3,p4,colorGray3)
    }
    
    func drawLine(_ p1:CGPoint, _ p2:CGPoint, _ strokeColor:CGColor) {
        let path = CGMutablePath()
        path.move( to: p1)
        path.addLine(to: p2)

        context.beginPath()
        context.setLineWidth(1.0)
        context.setStrokeColor(strokeColor)
        context.addPath(path)
        context.drawPath(using:.stroke)
    }

    func drawLineSet(_ path:CGMutablePath, _ width:CGFloat, _ strokeColor:CGColor) {
        context.beginPath()
        context.setLineWidth(width)
        context.setStrokeColor(strokeColor)
        context.addPath(path)
        context.drawPath(using:.stroke)
    }
    
    func drawFilledPath(_ path:CGMutablePath, _ fillColor: CGColor) {
        context.beginPath()
        context.setFillColor(fillColor)
        context.addPath(path)
        context.drawPath(using:.fill)
    }
}

// -----------------------------------------------

extension String {
    func drawSize(_ font: NSFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: font])
    }
}


