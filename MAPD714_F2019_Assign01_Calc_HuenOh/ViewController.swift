//
//  ViewController.swift
//  MAPD714_F2019_Assign01_Calc_HuenOh
//
//  Created by HUEN_OH on 2019-09-18.
//  Copyright © 2019 Centennial College. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    /* Outlets */
    @IBOutlet weak var calHistory04: UILabel!
    @IBOutlet weak var calHistory03: UILabel!
    @IBOutlet weak var calHistory02: UILabel!
    @IBOutlet weak var calHistory01: UILabel!
    @IBOutlet weak var calEquation: UILabel! // Label for current equation
    @IBOutlet weak var calResult: UILabel!   // Label for current number and result of the calcuation
    
    /* Member Variables */
    
    // Dictionary for operands' priority
    private let m_dictOperands:[String: Int] = ["%":1, "÷":1, "x":1,
                                                "-":0, "+":0]
    
    private var m_sign:Bool = true     // Sign for current typed number (true : positive, false : negative)
    private var m_number:String = "0"  // Current typed number
    private var m_operand:String = ""  // Current operand
    private var m_equation:String = "" // Current typed equation
    
    private var m_listNumbers:[String] = [String]()  // List of Numbers
    private var m_listOperands:[String] = [String]() // List of Operands
    
    
    // When the View is loaded.
    override func viewDidLoad() {
        
        // Set font properties of calEquation
        calEquation.numberOfLines = 0
        calEquation.adjustsFontSizeToFitWidth = true
        calEquation.minimumScaleFactor = 0.1
        
        // Set font properties of calResult
        calResult.font = UIFont.systemFont(ofSize: 80.0)
        calResult.adjustsFontSizeToFitWidth = true
        calResult.minimumScaleFactor = 0.1
        
       // Set font properties of calHistory
        calHistory01.adjustsFontSizeToFitWidth = true
        calHistory02.adjustsFontSizeToFitWidth = true
        calHistory03.adjustsFontSizeToFitWidth = true
        calHistory04.adjustsFontSizeToFitWidth = true
        calHistory01.minimumScaleFactor = 0.1
        calHistory02.minimumScaleFactor = 0.1
        calHistory03.minimumScaleFactor = 0.1
        calHistory04.minimumScaleFactor = 0.1
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //calResult.font = UIFont.systemFont(ofSize: 20.0)
        // Initialize member variables
        initVariables()
    }

    // Handelr for buttons
    // TODO : Seperate it to functions or make cal class
    @IBAction func CalButtons(_ sender: UIButton) {
        let calButton = sender.titleLabel?.text ?? ""
        
        // Debug output
        print("Current input value/button : \(m_number) / \(calButton)")
        
        //check : devide by zero
        switch(calButton)
        {
            // Clear everything
            case "AC":
                initVariables()
                break;
            
            // Change sign of a number
            case "+/-":
                // Doesn't apply for 0
                if(m_number == "0") {
                    break;
                }
                
                if (m_sign == false) {
                    m_number = String(m_number[m_number.index(after:m_number.startIndex)...])
                } else {
                    m_number = "-" + m_number
                }
                calResult.text = m_number
                
                m_sign = !m_sign
                calEquation.text = m_equation + updateSignOfNumber(number:m_number)
                break;
            
            // Operands
            case "%", "÷", "x", "-", "+":
                // For the multiple hit -> only the first hit counts
                if (m_operand.isEmpty) {
                    m_operand = calButton
                    
                    // add to list
                    m_listNumbers.append(m_number)
                    m_listOperands.append(m_operand)
                    
                    // m_operand, calCur
                    m_equation = m_equation + updateSignOfNumber(number:m_number) + m_operand
                    calEquation.text = m_equation
                    
                    //clear
                    m_operand = ""
                    m_number = "0"
                    m_sign = true
                    
                    // Display current result
                    calResult.text = doCalEquation()
                } else {
                    // Do nothing
                    //let calEqCur = calEquation.text ?? ""
                    //calEquation.text = String(calEqCur[calEqCur.startIndex..<calEqCur.index(before: calEqCur.endIndex)]) + calButton
                }
                break;
            
            // Do calcuation and show the result
            case "=":
                // Append number to the number list
                m_listNumbers.append(m_number)
                
                // Do the calcuation
                let calNum = doCalEquation()
 
                //set text and reset
                let strFinalEquation = m_equation + updateSignOfNumber(number:m_number) + "=" + calNum
                initVariables()
                
                // Update history
                calHistory04.text = calHistory03.text
                calHistory03.text = calHistory02.text
                calHistory02.text = calHistory01.text
                calHistory01.text = strFinalEquation
                break;
            
            // A point
            case ".": //no-activate after operand
                if (m_number.contains(".")) {
                    print(". is already here")
                } else {
                    m_number += calButton
                    calResult.text = m_number
                    calEquation.text = m_equation + updateSignOfNumber(number:m_number)
                }
                break;
            
            // Numbers
            default:
                // Check if the current typed value is 0
                if (m_number == "0") {
                    m_number = calButton
                } else {
                    m_number = m_number + calButton
                }
                calResult.text = m_number
                calEquation.text = m_equation + updateSignOfNumber(number:m_number)
        }
    }
    
    // Initialize/Reset member variables
    func initVariables() {
        calResult.text = "0"
        calEquation.text = ""
        
        m_sign = true
        m_number = "0"
        m_operand = ""
        m_equation = ""
        
        m_listNumbers = [String]()
        m_listOperands = [String]()
    }
    
    // Update sign of a number
    // Positive : num
    // Negative : (-num)
    func updateSignOfNumber(number:String)->String{
        if (m_sign == false) {
            return "(" + number + ")"
        } else {
            return number
        }
    }
    
    // Do calcuation with two numbers and one operand
    func calOperand(strNum1:String, strNum2:String, strOp:String)->String {
        let num1 = Double(strNum1)!
        let num2 = Double(strNum2)!
        var calNum : Double = 0
        
        switch (strOp) {
            case "+":
                calNum = num1 + num2
            case "-":
                calNum = num1 - num2
            case "%":
                calNum = num1.truncatingRemainder(dividingBy: num2) // div 0? -> nan
            case "÷":
                calNum = num1 / num2 // div 0? -> inf
            case "x":
                calNum = num1 * num2
            default:
                calNum = 0
        }
        
        return String(calNum)
    }
    
    // Do caculation from the equation
    func doCalEquation()->String {
        // For Step1 : Copy list of operands and numbers
        var listOprOrg = m_listOperands
        var listNumOrg = m_listNumbers
        
        // For Step2 : list of perands and numbers
        var listOprTmp = [String]()
        var listNumTmp = [String]()
        
        var calNum = listNumOrg[0] // Final calculation result
        
        // Step 1 : x, /, %
        let lenNums = listNumOrg.endIndex
        let lenOprs = listOprOrg.endIndex
        for (index, _) in listNumOrg.enumerated()
        {
            // Condition to exit : no operand
            if (0 == lenOprs) {
                break
            }
            
            if (index + 1 == lenNums) { // Check second number
                listNumTmp.append(listNumOrg[index])
                break;
            } else {
                let op = listOprOrg[index]
                let num1 = listNumOrg[index]
                let num2 = listNumOrg[index+1]
                
                if (1 == m_dictOperands[op]) {
                    // x, /, % : Calculate
                    calNum = calOperand(strNum1: num1, strNum2: num2, strOp: op)
                    listNumOrg[index+1] = calNum
                } else {
                    // +, - : add to the lists for step2
                    listOprTmp.append(op)
                    listNumTmp.append(num1)
                }
            }
            print("calNum step1: \(calNum)")
        }
        
        
        // Step 2 : +, -
        let lenNumsTmp = listNumTmp.endIndex
        let lenOprsTmp = listOprTmp.endIndex
        for (index, _) in listNumTmp.enumerated() {
            // Condition to exit : no operand
            if (0 == lenOprsTmp) {
                calNum = listNumTmp[0]
                break
            }
            
            if (index + 1 == lenNumsTmp) { // Check second number
                calNum = listNumTmp[index]
                break;
            } else {
                let op = listOprTmp[index]
                let num1 = listNumTmp[index]
                let num2 = listNumTmp[index+1]
                
                calNum = calOperand(strNum1: num1, strNum2: num2, strOp: op)
                listNumTmp[index+1] = calNum
            }
            
            print("calNum step2: \(calNum)")
        }
        
        return calNum
    }
    
}

