import Foundation

class CircularBuffer {
    let CBSIZE = 1024
    var data:[CGFloat] = []
    var head:Int = 0
    var vMin:CGFloat = 2
    var vMax:CGFloat = 99
    var trendAngle:Float = Float(fRandom(0,3))
    var trendSpeed:Float = 0.002
    
    init() {
        head = 0
        for _ in 0 ..<  CBSIZE { data.append(CGFloat()) }
    }
    
    func reset() {
        head = 0
        for i in 0 ..<  CBSIZE { data[i] = 0 }
    }
    
    func addValue(_ v:CGFloat) {
        head += 1; if head >= CBSIZE { head = 0 }

        data[head] = v
    }

    func addClampedValue(_ newValue:CGFloat) {
        var newValue = newValue
        if newValue < vMin { newValue = vMin } else if newValue > vMax { newValue = vMax }
        
        addValue(newValue)
    }
    
    func addRandomValue(_ min:CGFloat, _ max:CGFloat) {
        addClampedValue(data[head] + fRandom(min,max))
    }

    func addRandomTrendingValue() {
        trendAngle += trendSpeed
        let trend:CGFloat = CGFloat(sinf(trendAngle) / 10)
        
        addClampedValue(data[head] + fRandom(trend - 2, trend + 2))
    }

    func addSmoothedValue(_ value:CGFloat) {
        let smooth:CGFloat = 16
        
        addClampedValue((currentValue() * smooth + value) / (smooth+1))
    }

    func previousValue(_ offset:Int) -> CGFloat {
        if offset > 0 { return 0 }  // expecting negatve offsets only.  0 == most recent entry
        var index = head  + offset
        while index < 0 { index += CBSIZE }
        
        return data[index]
    }
    
    func currentValue() -> CGFloat { return data[head] }
    
    func markEntry(_ offset:Int) {  // setting entry negative 'marks' it. a yellow circle will be drawn over the negated entry
        var index = head + offset
        if index < 0 { index += CBSIZE }
        
        if data[index] > 0 { data[index] = -data[index] }
    }
}
