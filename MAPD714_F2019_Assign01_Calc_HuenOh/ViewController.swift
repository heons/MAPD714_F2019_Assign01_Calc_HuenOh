//
//  ViewController.swift
//  MAPD714_F2019_Assign01_Calc_HuenOh
//
//  Created by HUEN_OH on 2019-09-18.
//  Copyright © 2019 Centennial College. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var calEquation: UILabel! // Label for current equation
    @IBOutlet weak var calResult: UILabel!   // Label for current number and result of the calcuation
    
    // Member Variables
    private var m_operand:String = "" // Current operand
    private var m_number:String = "0" // Current typed number
    private var m_equation:String = "" // Current typed equation
    
    private var m_sign:Bool = true // true : positive, false : negative
    
    // When the View is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Initialize member variables
        initVariables()
    }

    // Handelr for buttons
    @IBAction func CalButtons(_ sender: UIButton) {
        let calButton = sender.titleLabel?.text ?? ""
        var calCur = calResult.text ?? ""
        
        var calUpdate = ""
        
        print("Current input value : \(calCur)")
        //print("Current input value : \(calEqCur)")
        print("Current button pressed : \(calButton)")
        
        //check : devide by zero
        //operand priority
        //let dbnum = Double(m_number)
        switch(calButton)
        {
            // Clear everything
            case "AC":
                initVariables()
                break;
            
            case "+/-": //no-activate after operand
                if(calCur == "0")
                {
                    break;
                }
                
                if (m_sign == false) {
                    calCur = String(calCur[calCur.index(after:calCur.startIndex)...])
                } else {
                    calCur = "-" + calCur
                }
                calResult.text = calCur
                
                m_sign = !m_sign
                calEquation.text = m_equation + updateSignOfNumber(number:calCur) + m_operand
                
                break;
            
            case "%", "÷", "x", "-", "+":
                if (m_operand.isEmpty) {
                    m_operand = calButton
                    
                    calEquation.text = m_equation + updateSignOfNumber(number:calCur) + m_operand
                } else {
                    //let calEqCur = calEquation.text ?? ""
                    //calEquation.text = String(calEqCur[calEqCur.startIndex..<calEqCur.index(before: calEqCur.endIndex)]) + calButton
                }
            
            
            
            // Do calcuation and show the result
            case "=":
                break
            
            case ".": //no-activate after operand
                if (calCur.contains(".")) {
                    print(". is already here")
                } else {
                    calCur += calButton
                    calResult.text = calCur
                    
                    calUpdate = calCur
                    if (m_sign == false) {
                        calUpdate = "(" + calCur + ")"
                    }
                    calEquation.text = m_equation + calUpdate + m_operand
                    
                    //calEquation.text = m_equation + calCur + m_operand
                }
                break;
            
            default:
                if (m_operand.isEmpty) {
                    print("operand is empty")
                } else {

                    print("operand: \(m_operand)")
                    // add to stack
                    // m_operand, calCur
                    print(m_equation)
                    m_equation = calEquation.text ?? ""
                    //m_equation += m_operand
                    print(m_equation)
                    
                    
                    calEquation.text = m_equation + updateSignOfNumber(number:calCur) + m_operand
                    
                    //clear
                    m_operand = ""
                    m_number = "0"
                    m_sign = true
                    calResult.text = "0"
                    calCur = calResult.text ?? ""
                }
                
                // Check if the current typed value is 0
                // update with -/+
                if (calCur == "0") {
                    calResult.text = calButton
                    calEquation.text = m_equation + calButton
                } else {
                    calCur = calCur + calButton
                    calResult.text = calCur
                    
                    calEquation.text = m_equation + updateSignOfNumber(number:calCur) + m_operand
                }
        }
    }
    
    func initVariables(){
        calResult.text = "0"
        calEquation.text = ""
        m_number = "0"
        m_operand = ""
        m_equation = ""
        m_sign = true
    }
    
    func updateSignOfNumber(number:String)->String{
        if (m_sign == false) {
            return "(" + number + ")"
        } else {
            return number
        }
    }
}

