//
//  GraphView.swift
//
//
//  Created by Tibin Thomas on 01/09/17.
//

import UIKit
struct MilePoint {
    var milePointLabel : UILabel
    var milePointView : UIView
    var point : CGFloat
    var name : String
    
    init() {
        milePointLabel = UILabel()
        milePointView = UIView()
        point = CGFloat()
        name = String()
    }
}

@IBDesignable final class GraphView: UIView {
    var start : CGFloat = 0
    var end : CGFloat = 0
    var progress: CGFloat = 0
    var milePointPoints : [CGFloat] = []
    var milePoints : [MilePoint] = []
    var startName : String = "" {
        didSet{
            self.startLabel.text = startName
        }
    }
    var endName : String = "$20 Unlockable Bonus" {
        didSet{
            self.endLabel.text = endName
        }
    }
    var baseLineView : UIView = UIView()
    var progressLineView : UIView = UIView()
    
    
    
    var graphStartPoint: CGFloat = 10
    var graphEndPoint: CGFloat = 10
    
    var startLabel : UILabel = UILabel()
    var endLabel : UILabel = UILabel()
    
    var padding : CGFloat = 10
    var labelPadding :CGFloat = 2
    
    
    var totalWidth : CGFloat = 0
    var progressWidth : CGFloat = 0
    
    var lineHeight : CGFloat = 2
    var baseLineColor : UIColor = UIColor.colorFromHex("DCDCDC") {
        didSet{
            self.baseLineView.backgroundColor = baseLineColor
        }
    }
    var progressLineColor: UIColor = UIColor.colorFromHex("00BDD6") {
        didSet{
            self.progressLineView.backgroundColor = progressLineColor
        }
    }
    var labelHeight : CGFloat = 15
    var milePointLabelHeight : CGFloat = 15
    var milePointLabelWidth : CGFloat = 50
    
    var milePointLineWidth : CGFloat = 2
    var milePointHeight : CGFloat = 5
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        //  fatalError("init(coder:) has not been implemented")
    }
    func updateProgress(to : CGFloat? = nil){
        self.progress = to ?? progress
        progressWidth = ( progress - start ) / ( end - start ) * totalWidth
        let oldFrame =  progressLineView.frame
        let newFrame = CGRect(origin: oldFrame.origin, size: CGSize(width: progressWidth, height: oldFrame.height))
        progressLineView.frame = newFrame
    }
    
    func addMileStone(forPoint : CGFloat , withName: String){
        guard !(milePointPoints.contains(forPoint) )  else{
            for element in milePoints{
                if(element.point == forPoint){
                    element.milePointLabel.text = withName
                }
            }
            return
        }
        
        milePointPoints.append(forPoint)
        var milePoint = MilePoint()
        
        let mileStoneView = UIView()
        mileStoneView.backgroundColor = progressLineColor
        self.addSubview(mileStoneView)
        self.bringSubview(toFront: mileStoneView)
        
        let mileStoneLabel = UILabel()
        mileStoneLabel.text = withName
        mileStoneLabel.textAlignment = .center
        mileStoneLabel.adjustsFontSizeToFitWidth = true
        mileStoneLabel.minimumScaleFactor = 0.5
        mileStoneLabel.lineBreakMode = .byClipping
        mileStoneLabel.numberOfLines = 0
        self.addSubview(mileStoneLabel)
        self.bringSubview(toFront: mileStoneLabel)
        
        milePoint.milePointLabel = mileStoneLabel
        milePoint.milePointView = mileStoneView
        milePoint.name = withName
        milePoint.point = forPoint
        milePoints.append(milePoint)
    }
    
    func setupViews(){
        baseLineView.backgroundColor = baseLineColor
        self.addSubview(baseLineView)
        progressLineView.backgroundColor = progressLineColor
        self.addSubview(progressLineView)
        self.bringSubview(toFront: progressLineView)
        
        // startLabel.backgroundColor = UIColor.blue
        startLabel.text = startName
        startLabel.adjustsFontSizeToFitWidth = true
        startLabel.minimumScaleFactor = 0.5
        startLabel.lineBreakMode = .byClipping
        startLabel.numberOfLines = 0
        self.addSubview(startLabel)
        self.bringSubview(toFront: startLabel)
        
        //endLabel.backgroundColor = UIColor.green
        endLabel.textAlignment = .right
        endLabel.text = endName
        endLabel.adjustsFontSizeToFitWidth = true
        endLabel.minimumScaleFactor = 0.5
       // endLabel.lineBreakMode = .byClipping
        endLabel.numberOfLines = 0
        self.addSubview(endLabel)
        self.bringSubview(toFront: endLabel)
        
        

        
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        totalWidth = self.frame.width - padding * 2
        progressWidth = (progress - start ) / (end - start) * totalWidth
        progressWidth = progressWidth.isNaN ? 0 : progressWidth
        let lineY = bounds.midY - lineHeight/2
        let lineX = padding
        baseLineView.frame = CGRect(x: lineX , y: lineY , width: totalWidth, height: lineHeight)
        progressLineView.frame = CGRect(x: lineX , y: lineY , width: progressWidth , height: lineHeight)
        startLabel.frame = CGRect(x: padding + 2 , y: lineY + lineHeight + 5 , width: self.frame.width/2 - padding - 2, height: labelHeight)
        endLabel.frame = CGRect(x: self.frame.width/2 , y: lineY + lineHeight + 5  , width: self.frame.width/2 - padding - 2, height: labelHeight)
        
        for element in self.milePoints{
            var milestonePoint = (element.point - start) / (end  - start ) * totalWidth
            milestonePoint = milestonePoint.isNaN ? 0 : milestonePoint
            element.milePointLabel.frame = CGRect(x: padding + milestonePoint - milePointLabelWidth/2 , y: lineY - milePointLabelHeight - milePointHeight - 5 , width: milePointLabelWidth, height: milePointLabelHeight)
            element.milePointView.frame = CGRect(x: padding + milestonePoint , y: lineY - milePointHeight, width: milePointLineWidth, height: milePointHeight)
        }
        
        
    }
}
