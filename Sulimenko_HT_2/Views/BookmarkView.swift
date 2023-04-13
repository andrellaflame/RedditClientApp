//
//  BookmarkView.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 15.03.2023.
//

import Foundation
import UIKit

class BookmarkView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        let bookmarkShape = drawBookmark()
        self.layer.addSublayer(bookmarkShape)
    }
    
    func drawBookmark() -> CAShapeLayer {
        let bookmarkBezierPath = UIBezierPath()
        let containerFrame = self.bounds
        let containerSize = containerFrame.width
        
        bookmarkBezierPath.move(to: CGPoint(
            x: containerFrame.midX - containerSize / 3,
            y: containerFrame.origin.y))
        
        bookmarkBezierPath.addLine(to: CGPoint(
            x: containerFrame.midX + containerSize / 3,
            y: containerFrame.origin.y))
        
        bookmarkBezierPath.addLine(to: CGPoint(
            x: containerFrame.midX + containerSize / 3,
            y: containerFrame.origin.y + containerSize))

        bookmarkBezierPath.addLine(to: CGPoint(
            x: containerFrame.midX,
            y: containerFrame.midY + containerSize / 6))

        bookmarkBezierPath.addLine(to: CGPoint(
            x: containerFrame.midX - containerSize / 3,
            y: containerFrame.origin.y + containerSize))

        bookmarkBezierPath.addLine(to: CGPoint(
            x: containerFrame.midX - containerSize / 3,
            y: containerFrame.origin.y))
        
        bookmarkBezierPath.close()
        
        let bookmarkShape = CAShapeLayer()
        bookmarkShape.path = bookmarkBezierPath.cgPath
        bookmarkShape.lineCap = CAShapeLayerLineCap.round
        bookmarkShape.lineWidth = 3
        bookmarkShape.strokeColor = UIColor.systemBackground.cgColor
        bookmarkShape.fillColor =  UIColor.systemOrange.cgColor
        
        return bookmarkShape
    }
}
