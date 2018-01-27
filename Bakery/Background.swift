import Cocoa

class Background: NSView {
    override var acceptsFirstResponder: Bool { return true }
    
    func createGradientLayer() {
        let c1 = NSColor(red:0.45, green:0.4, blue:0.4, alpha:1).cgColor
        let c2 = NSColor(red:0.6, green:0.6, blue:0.65, alpha:1).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [c2,c1]
        layer?.insertSublayer(gradientLayer, at: 0)
    }
    
    override func keyDown(with event: NSEvent) { vc.keyDown(with: event) }
}
