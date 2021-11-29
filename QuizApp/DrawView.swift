//
//  DrawView.swift
//  QuizApp
//
//  Created by Efe Ozcivelek on 11/20/21.
//

import UIKit
class DrawView: UIView, UIGestureRecognizerDelegate {
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    var moveRecognizer: UIPanGestureRecognizer!
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        finishedLineColor.setStroke()
        for line in finishedLines {
            stroke(line)
        }
        
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            stroke(line)
        }
        
        if let index = selectedLineIndex {
               UIColor.green.setStroke()
               let selectedLine = finishedLines[index]
               stroke(selectedLine)
       }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
                let location = touch.location(in: self)
                let newLine = Line(begin: location, end: location)
                let key = NSValue(nonretainedObject: touch)
                currentLines[key] = newLine
            }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let key = NSValue(nonretainedObject: touch)
                currentLines[key]?.end = touch.location(in: self)
            }

        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let key = NSValue(nonretainedObject: touch)
                if var line = currentLines[key] {
                    line.end = touch.location(in: self)
                    finishedLines.append(line)
                    currentLines.removeValue(forKey: key)
                }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawView.moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
    }
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let alert = UIAlertController(title: "Alert", message: "Do you want to delete everything?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Yes", style: .default) { [self]
            UIAlertAction in
            selectedLineIndex = nil
            currentLines.removeAll()
            finishedLines.removeAll()
            setNeedsDisplay()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        
        if let viewController = self.window?.rootViewController   {                         viewController.present(alert, animated: true) {
            }
        }


    }
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        let menu = UIMenuController.shared
        if selectedLineIndex != nil {
            becomeFirstResponder()
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            let colorRed = UIMenuItem(title: "Red", action: #selector(DrawView.changeColorRed(_:)))
            let colorBlue = UIMenuItem(title: "Blue", action: #selector(DrawView.changeColorBlue(_:)))
            let colorGreen = UIMenuItem(title: "Green", action: #selector(DrawView.changeColorGreen(_:)))
            let colorBlack = UIMenuItem(title: "Black", action: #selector(DrawView.changeColorBlack(_:)))
            menu.menuItems = [deleteItem, colorRed, colorBlue, colorGreen, colorBlack]
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            menu.setMenuVisible(false, animated: true)
        }
        setNeedsDisplay()
    }
    
    @objc func deleteLine(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            setNeedsDisplay()
        }
    }
                                      
    @objc func changeColorRed(_ sender: UIMenuController) {
        finishedLineColor = UIColor.red
        setNeedsDisplay()

    }
    
    @objc func changeColorBlue(_ sender: UIMenuController) {
        finishedLineColor = UIColor.blue
        setNeedsDisplay()
        
    }
    
    @objc func changeColorGreen(_ sender: UIMenuController) {
        finishedLineColor = UIColor.green
        setNeedsDisplay()
    }
    
    @objc func changeColorBlack(_ sender: UIMenuController) {
        finishedLineColor = UIColor.black
        setNeedsDisplay()
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        return nil
    }
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            if selectedLineIndex != nil {
                currentLines.removeAll()
            } else {
                let menu = UIMenuController.shared
                if selectedLineIndex == nil {
                    becomeFirstResponder()
                    let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
                    let colorRed = UIMenuItem(title: "Red", action: #selector(DrawView.changeColorRed(_:)))
                    let colorBlue = UIMenuItem(title: "Blue", action: #selector(DrawView.changeColorBlue(_:)))
                    let colorGreen = UIMenuItem(title: "Green", action: #selector(DrawView.changeColorGreen(_:)))
                    let colorBlack = UIMenuItem(title: "Black", action: #selector(DrawView.changeColorBlack(_:)))
                    menu.menuItems = [deleteItem, colorRed, colorBlue, colorGreen, colorBlack]
                    let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
                    menu.setTargetRect(targetRect, in: self)
                    menu.setMenuVisible(true, animated: true)
                    } else {
                    menu.setMenuVisible(false, animated: true)
                    }
            }
        } else if gestureRecognizer.state == .ended {
            selectedLineIndex = nil
        }
        setNeedsDisplay()
    }
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        if let index = selectedLineIndex {
            if gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                setNeedsDisplay()
            }
        } else {
            return
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
