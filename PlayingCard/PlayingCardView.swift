//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Andrea Visini on 29/07/18.
//  Copyright © 2018 Andrea Visini. All rights reserved.
//

import UIKit

@IBDesignable class PlayingCardView: UIView {
    
    @IBInspectable
    var seme: String = "♥️" {didSet{setNeedsDisplay(); setNeedsLayout()}} //call draw
    @IBInspectable
    var valore: Int = 5 {didSet{setNeedsDisplay(); setNeedsLayout()}} //call draw
    @IBInspectable
    var isFacedUp: Bool = true {didSet{setNeedsDisplay(); setNeedsLayout()}} //call draw
    @IBInspectable
    var scaleFactor: CGFloat = SizeRatio.faceCardImageToBoundSize {didSet{setNeedsDisplay(); setNeedsLayout()}} //call draw
    
    
    @objc func zoomCard(byHandlerGestureRecognizer recognizer:UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed,.ended:
            scaleFactor *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if let context = UIGraphicsGetCurrentContext() {
            context.addArc(
                center: CGPoint(x: bounds.midX, y: bounds.midY),
                radius: 100.0,
                startAngle: 0.0,
                endAngle: 2*CGFloat.pi,
                clockwise: true
            )
            context.setLineWidth(5.0)
            UIColor.red.setStroke()
            context.strokePath()
            
            UIColor.red.setFill()
            context.fillPath()  // non viene fatto perchè quando disegnamo in un context consuma il path!
        }
        
        let path = UIBezierPath()
        path.addArc(
            withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: 70.0,
            startAngle: 0.0,
            endAngle: 2*CGFloat.pi,
            clockwise: true
        )
        path.lineWidth = 5.0
        UIColor.blue.setStroke()
        path.stroke()
        UIColor.green.setFill()
        path.fill()
        
        
        // MARK: Rect
        let roundRect = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 16.0)
        roundRect.addClip() //non scrive fuori da quà
        UIColor.white.setFill()
        roundRect.fill()
        UIColor.red.setStroke()
        roundRect.lineWidth = 5.0
        roundRect.stroke()
        
        if isFacedUp {
            if let faceCardImage = UIImage(named: valoreString+seme, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: scaleFactor))
            } else {
                drawPips()
            }
        } else {
            if let backCardImage = UIImage(named: "backgroud", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                backCardImage.draw(in: bounds)
            }
        }
        
    }
    
    private func drawPips() {
        let pipsPerRowForValore = [[0], [1], [1,1], [1,1,1], [2,2], [2,1,2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]
        
        func cratePipString(thatFits pipRect: CGRect) -> NSAttributedString {
            
            //
            let maxVerticalPipCount = CGFloat(pipsPerRowForValore.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForValore.reduce(0) { max($1.max() ?? 0, $0)})
            print(maxVerticalPipCount)
            print(maxHorizontalPipCount)
            
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount

            let attemptedPipString = centeredAttributedString(seme, fontSize: verticalPipRowSpacing)
            
            let probablyOkPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkPipString = centeredAttributedString(seme, fontSize: probablyOkPipStringFontSize)
            
            if probablyOkPipString.size().width > pipRect.size.width / maxVerticalPipCount {
                return centeredAttributedString(seme, fontSize: probablyOkPipStringFontSize / (probablyOkPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkPipString
            }
        }
        
        
        if pipsPerRowForValore.indices.contains(valore){
            
            let pipPerRow = pipsPerRowForValore[valore]
            
            var pipRect = bounds
                .insetBy(dx: cornerOffset, dy: cornerOffset)
                .insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
           
            let pipString = cratePipString(thatFits: pipRect)
            
            let pipRowSparcin = pipRect.size.height / CGFloat(pipPerRow.count)
            
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSparcin - pipRect.size.height) / 2
            
            
            for pipCount in pipPerRow {
                switch pipCount{
                case 1: pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default: break
                }
                pipRect.origin.y += pipRowSparcin
            }
        }
    }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font) //compatibile con accessibilità
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        return NSAttributedString(
            string: string,
            attributes: [NSAttributedStringKey.paragraphStyle: paragraph, .font: font])
    }
    
    // Accessibilità
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    private var cornerString:NSAttributedString {
        return centeredAttributedString(valoreString+"\n"+seme, fontSize: cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 //per avere più righe
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFacedUp
    }
    
    // chiamato tutte le volte che cambia il bounds ( setNeedLayout() )
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerLabel(upperLeftCornerLabel)
        // il frame è per il positioning
        // il bound è per disegnare
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.width, dy: -lowerRightCornerLabel.frame.height)
        
        //bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
    }
    
}

extension PlayingCardView {
    
    private struct SizeRatio {
        static let cornerFontSizeToBoundSizeHeigh: CGFloat = 0.075 // per riutilizzarlo
        static let cornerRadiusToBoundSizeHeigh: CGFloat = 0.3
        static let cornerOffsetToCornerRadius: CGFloat = 0.06
        static let faceCardImageToBoundSize: CGFloat = 0.75
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundSizeHeigh
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundSizeHeigh
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var valoreString: String {
        switch valore {
        case 1: return "A"
        case 2...10: return String(valore)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect {
    
    var leftHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: origin, size: CGSize(width: width, height: size.height))
        
    }
    
    var rightHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: CGPoint(x: origin.x + width, y:origin.y), size: CGSize(width: width, height: size.height))
        
    }
    
    // estendo insetBy per lavorare con CGSize invece di CGFloat
    func insetBy(size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let newW = width * zoomFactor
        let newH = height * zoomFactor
        return insetBy(dx: (width - newW)/2, dy: (height - newH)/2)
    }
    
    
}

extension CGPoint {
    
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
    
}



