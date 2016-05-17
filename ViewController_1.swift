//
//  ViewController.swift
//  Bullseye
//
//  Created by Jordan Kiley on 5/13/16.
//  Copyright © 2016 Jordan Kiley. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    var currentValue = 50
    var targetValue = 0
    var score = 0
    var round = 0
    var currentBottomValue = 50
    var mathOperator = ""
    var difference = 0
    var points = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
        updateLabels()
        
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, forState: .Normal)
        bottom.setThumbImage(thumbImageNormal, forState: .Normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, forState: .Highlighted)
        bottom.setThumbImage(thumbImageHighlighted, forState: .Highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        if let trackLeftImage = UIImage(named: "SliderTrackLeft") {
            let trackLeftResizable = trackLeftImage.resizableImageWithCapInsets(insets)
            slider.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
            bottom.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
            
        }
        
        if let trackRightImage = UIImage(named:  "SliderTrackRight") {
            let trackRightResizable = trackRightImage.resizableImageWithCapInsets(insets)
            slider.setMaximumTrackImage(trackRightResizable, forState: .Normal)
            bottom.setMaximumTrackImage(trackRightResizable, forState: .Normal)
        }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//    class operation: UIControl {
//        var minimumValue = arc4random_uniform(50)
//        var maximumValue = arc4random_uniform(50) + 50
//        
//    }
//    
//    class slider: UIControl {
//        var minimumValue = arc4random_uniform(50)
//        var maximumValue = arc4random_uniform(50) + 50
//    }
    
    func startNewGame() {
        score = 0
        round = 0
        startNewRound()
        

    }
    
    func startNewRound() {
        targetValue = 1 + Int(arc4random_uniform(100))
        currentValue = 50
        slider.value = Float(currentValue)
        bottom.value = Float(currentBottomValue)
        randomOperator()
        sliderValue()
    }
    
    func updateLabels() {
        round += 1
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
        operatorLabel.text = String(mathOperator)
    }
    
    func checkValue(){
        if mathOperator == "+" && (Int(targetValue) > (Int(bottom.maximumValue + slider.maximumValue))) {
            startNewRound()
            }
            
        else if mathOperator == "+" && (Int(targetValue) < Int( bottom.minimumValue + slider.minimumValue)) {
            startNewRound()
            }
        else if mathOperator == "-" && (Int(targetValue) > Int(slider.maximumValue - bottom.minimumValue )) {
            startNewRound()
        }
        else if mathOperator == "-" && (Int(targetValue) < Int( slider.minimumValue - bottom.minimumValue)) {
            startNewRound()
        } else if mathOperator == "/" && (Int(targetValue) > Int(slider.maximumValue / bottom.minimumValue )) {
            startNewRound()
            }

            
        else if mathOperator == "/" && (Int(targetValue) < Int(bottom.minimumValue)) {
            startNewRound()
            }
        
        else if mathOperator == "*" && (Int(targetValue) > Int(slider.maximumValue * bottom.maximumValue )) {
            startNewRound()
            }
            
        else if mathOperator == "*" && (Int(targetValue) < Int( slider.minimumValue * bottom.minimumValue)) {
            startNewRound()
        }
        
    }
    
    func randomOperator() {
        let operatorArray = [ "+", "/", "-", "*" ]
        let index = Int(arc4random_uniform(UInt32(operatorArray.count)))
        mathOperator = operatorArray[index]
        operatorLabel.text = String(mathOperator)
    }
    
    func sliderValue() {
        slider.minimumValue = Float(arc4random_uniform(50)) + 1
        slider.maximumValue = Float(arc4random_uniform(50)) + 51
        bottom.minimumValue = Float(arc4random_uniform(50)) + 1
        bottom.maximumValue = Float(arc4random_uniform(50)) + 51
        sliderMinValue.text = String(Int(slider.minimumValue))
        sliderMaxValue.text = String(Int(slider.maximumValue))
        bottomMinValue.text = String(Int(bottom.minimumValue))
        bottomMaxValue.text = String(Int(bottom.maximumValue))
        checkValue()
    }
    
    @IBAction func showAlert() {
        if mathOperator == "+" {
            difference = abs(targetValue - (currentValue + currentBottomValue))
            points = 100 - difference
        }
        else if mathOperator == "/" {
            difference = abs(targetValue - (currentValue / currentBottomValue))
            points = 100 - difference
        }
        else if mathOperator == "-" {
            difference = abs(targetValue - (currentValue - currentBottomValue))
            points = 100 - difference
        }
        else if mathOperator == "*" {
            difference = abs(targetValue - (currentValue * currentBottomValue))
            points = 100 - difference
        }
        
        

//                var difference: Int
//        if currentValue > targetValue {
//            difference = currentValue - targetValue
//        } else if targetValue > currentValue {
//            difference = targetValue - currentValue
//        } else {
//            difference = 0
//        }
        let title: String
        if difference == 0 {
            title = "Perfect!"
            score += 100
        }
        else if difference < 5 {
            title = "You almost had it!"
            if difference == 1 {
            score += 50
            }
        }
        else if difference < 10 {
            title = "Pretty good!"
        }
        else {
            title = "Not even close..."
        }
        
    
        score += points
        
        let message = "You scored \(points) points" + "\nThe value of the slider is: \(currentValue)" + "\nThe value of the operation slider is: \(currentBottomValue)" + "\nThe target value is: \(targetValue)" + "\nThe difference is: \(difference)"
        let alert = UIAlertController( title:title,
            message:message,
            preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: {
            action in
            self.startNewRound()
            self.updateLabels()
        })
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
        
        scoreLabel.text = String(score)
    }
    
    @IBAction func startOver () {
        startNewGame()
        updateLabels()
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        view.layer.addAnimation(transition, forKey: nil)
    }
    
    @IBAction func sliderValue(slider: UISlider) {
        
    }
    
    @IBAction func sliderMoved(slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    @IBAction func bottomMoved(bottom: UISlider) {
        currentBottomValue = lroundf(bottom.value)
    }
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var roundLabel: UILabel!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var bottom: UISlider!
    
    @IBOutlet weak var operatorLabel: UILabel!
    
    @IBOutlet weak var sliderMinValue: UILabel!
    
    @IBOutlet weak var sliderMaxValue: UILabel!
    
    @IBOutlet weak var bottomMinValue: UILabel!
    
    @IBOutlet weak var bottomMaxValue: UILabel!
}

