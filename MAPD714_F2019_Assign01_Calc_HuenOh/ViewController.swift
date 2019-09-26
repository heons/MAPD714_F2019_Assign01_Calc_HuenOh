//
//  ViewController.swift
//  MAPD714_F2019_Assign01_Calc_HuenOh
//
//  Created by HUEN_OH on 2019-09-18.
//  Copyright © 2019 Centennial College. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var calResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calResult.text = "0"
    }

    private var m_operand:String = ""
    
    @IBAction func CalButtons(_ sender: UIButton) {
        let calButton = sender.titleLabel?.text ?? ""
        var calCur = calResult.text ?? ""
        
        print("Current input value : \(calCur)")
        print("Current button pressed : \(calButton)")
        
        //check : devide by zero
        
        switch(calButton)
        {
            // Clear everything
            case "AC":
                calResult.text = "0"
                m_operand = ""
                break;
            
            case "+/-":
                if(calCur == "0")
                {
                    break;
                }
                
                if(calCur[calCur.startIndex] == "-"){
                    calResult.text = String(calCur[calCur.index(after:calCur.startIndex)...])
                    print(calResult.text!)
                }else{
                    calResult.text = "-" + calCur
                }
                break;
            
            case "%", "÷", "x", "-", "+":
                m_operand = calButton
                print(m_operand)
            
            // Do calcuation and show the result
            case "=":
                break
            
            case ".":
                if(calCur.contains(".")){
                    print(". is already here")
                } else{
                    calResult.text = calCur + calButton
                }
                break;
            
            default:
                if(m_operand.isEmpty){
                    print("operand is empty")
                } else{
                     print("operand: \(m_operand)")
                    // add to stack
                    // m_operand, calCur
                    
                    //clear
                    m_operand = ""
                    calResult.text = "0"
                    calCur = calResult.text ?? ""
                }
                
                if(calCur == "0"){
                    print("the value is 0")
                    calResult.text = calButton
                }else{
                    calResult.text = calCur + calButton
                }
        }
    }
}

