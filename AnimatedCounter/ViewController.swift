//
//  ViewController.swift
//  AnimatedCounter
//
//  Created by Alexey on 3/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TimerDelegate {
    
    @IBOutlet private var digitsView: [UIImageView]!
    
    private var counterState = CounterState.Stopped
    private var timer = Timer()
    private var counterTimeout = 0.5
    private lazy var formatString: String = {
        [unowned self] in
        // Format string containing necessary number of leading zeroes
        return "%0" + String(self.digitsView.count) + "d"
    }()
    
    private var counterValue = 0 {
        didSet {
            // Convert current value and previous value into array of characters
            let oldCounterStringValue = Array(String(format: formatString, oldValue).characters)
            let newCounterStringValue = Array(String(format: formatString, counterValue).characters)
            
            for (index, digitView) in digitsView.enumerate() {
                if .Resetting == counterState {
                    // Set initial image
                    digitView.image = UIImage(named: "0100")
                }
                else {
                    // Compare previous digit with current one
                    let oldDigit = String(oldCounterStringValue[index])
                    let newDigit = String(newCounterStringValue[index])
                    
                    // If digits are different, animate changes
                    if oldDigit != newDigit {
                        // Set animation parameters
                        digitView.animationImages = RollingDigits.sharedInstance.imagesFrom(oldDigit, To: newDigit)
                        
                        // Set last image of the rolling digit
                        digitView.image = RollingDigits.sharedInstance.lastImageFrom(oldDigit, To: newDigit)
                        
                        // Animation parameters
                        digitView.animationRepeatCount = 1
                        digitView.animationDuration = counterTimeout / 2
                        digitView.startAnimating()
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set delegate
        timer.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    @IBAction func startStopButtonTapped(sender: UIButton) {
        // Toggle counter state
        counterState.toggle()
        
        // Check the state
        switch counterState {
        case .Stopped:
            timer.stop()
            sender.setTitle("Start", forState: .Normal)
            
        case .Running:
            timer.start(counterTimeout)
            sender.setTitle("Stop", forState: .Normal)
            
        case .Resetting:
            break
        }
    }
    
    @IBAction func resetButtonTapped(sender: UIButton) {
        // Store counter state
        let previousCounterState = counterState
        
        if .Running == counterState {
            // Stop timer if it was running
            timer.stop()
        }
        
        // Reset counter value and restore previous state
        counterState = .Resetting
        counterValue = 0
        counterState = previousCounterState
        
        if .Running == counterState {
            // Start timer if it was running
            timer.start(counterTimeout)
        }
    }
    
    @IBAction func timeoutSliderChangedValue(sender: UISlider) {
        // Update timer with changed timeout value
        counterTimeout = Double(sender.value)
        if .Running == counterState {
            timer.updateInterval(counterTimeout)
        }
    }
    
    // MARK: - Timer delegate
    
    func didTimerTimeOut() {
        // Check maximum limit (10 ^ (number of digits))
        if Int(pow(10, Double(digitsView.count))) - 1 == counterValue {
            // Overflow, start from 0
            counterValue = 0
        }
        else {
            // Increment value
            counterValue += 1
        }
    }
}
