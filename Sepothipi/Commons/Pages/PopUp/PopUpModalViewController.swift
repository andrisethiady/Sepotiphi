//
//  PopUpModalViewController.swift
//  Sepothipi
//
//  Created by Andri on 11/10/24.
//

import UIKit

protocol PopUpModalDelegate {
    func onPressBottomBtn()
}

class PopUpModalViewController: UIViewController {
    
    public var delegate: PopUpModalDelegate?

    @IBOutlet weak var canvas: UIView!
    @IBOutlet weak var btnBottom: UIButton!
    @IBOutlet weak var lblErrorMsg: UILabel!
    
    public var errorMsg: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        lblErrorMsg.text = errorMsg
        
        canvas.layer.borderWidth = 1
        canvas.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func onPressBottomBtn(_ sender: Any) {
        delegate?.onPressBottomBtn()
    }
    
}
