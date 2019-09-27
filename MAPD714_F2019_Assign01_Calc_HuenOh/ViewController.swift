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
    
    
    private var m_listOperands:[String] = [String]()
    private var m_listNumbers:[String] = [String]()
    
    
    // Dictionary for operands' priority
    private let m_dictOperands:[String: Int] = ["%":1, "÷":1, "x":1,
                                                "-":0, "+":0]
    
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
        
        
        print("Current input value : \(m_number)")
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
            
            case "+/-":
                if(m_number == "0")
                {
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
                    calResult.text = "0"
                } else {
                    // Do nothing
                    //let calEqCur = calEquation.text ?? ""
                    //calEquation.text = String(calEqCur[calEqCur.startIndex..<calEqCur.index(before: calEqCur.endIndex)]) + calButton
                }
            
            // Do calcuation and show the result
            case "=":
                m_listNumbers.append(m_number)
                
                var listOprTmp = [String]()
                var listNumTmp = [String]()
                
                var calNum = m_listNumbers[0]
                
                let lenNums = m_listNumbers.endIndex
                let lenOprs = m_listOperands.endIndex
                
                for (index, _) in m_listNumbers.enumerated()
                {
                    // condition to exit : no operand
                    if (0 == lenOprs) {
                        break
                    }
                    
                    if (index + 1 == lenNums){
                        listNumTmp.append(m_listNumbers[index])
                        break;
                    } else {
                        let op = m_listOperands[index]
                        let num1 = m_listNumbers[index]
                        let num2 = m_listNumbers[index+1]
                        
                        if (1 == m_dictOperands[op]) {
                            // x, /, %
                            calNum = calOperand(strNum1: num1, strNum2: num2, strOp: op)
                            m_listNumbers[index+1] = calNum
                        } else {
                            listOprTmp.append(op)
                            listNumTmp.append(num1)
                        }
                    }
                    print("calNum step1: \(calNum)")
                }
                
                
                calNum = listNumTmp[0]
                let lenNumsTmp = listNumTmp.endIndex
                let lenOprsTmp = listOprTmp.endIndex
                
                for (index, _) in listNumTmp.enumerated() {
                    // +, -
                    if (0 == lenOprsTmp) {
                        break
                    }
                    
                    if (index + 1 == lenNumsTmp){
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
 
                //set text and reset
                let strFinalEquation = m_equation + updateSignOfNumber(number:m_number) + "=" + calNum
                initVariables()
                //calResult.text = calNum
                calEquation.text = strFinalEquation
                break
            
            case ".": //no-activate after operand
                if (m_number.contains(".")) {
                    print(". is already here")
                } else {
                    m_number += calButton
                    calResult.text = m_number
                    
                    calEquation.text = m_equation + updateSignOfNumber(number:m_number)
                }
                break;
            
            
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
    
    func initVariables(){
        calResult.text = "0"
        calEquation.text = ""
        m_number = "0"
        m_operand = ""
        m_equation = ""
        m_sign = true
        
        m_listNumbers = [String]()
        m_listOperands = [String]()
    }
    
    func updateSignOfNumber(number:String)->String{
        if (m_sign == false) {
            return "(" + number + ")"
        } else {
            return number
        }
    }
    
    func calOperand(strNum1:String, strNum2:String, strOp:String)->String {
        let num1 = Double(strNum1) ?? 0
        let num2 = Double(strNum2) ?? 0
        var calNum : Double = 0
        
        switch (strOp) {
        case "+":
            calNum = num1 + num2
        case "-":
            calNum = num1 - num2
        case "%":
            calNum = num1.truncatingRemainder(dividingBy: num2)// div 0?
        case "÷":
            calNum = num1 / num2 // div 0? -> becomes inf
        case "x":
            calNum = num1 * num2
        default:
            calNum = 0
        }
        
        let strCalNum = String(calNum)
        return strCalNum
    }
}

