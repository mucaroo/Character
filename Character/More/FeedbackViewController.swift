//
//  FeedbackViewController.swift
//  Character
//
//  Created by Robby on 8/27/16.
//  Copyright © 2016 Robby. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, UITextViewDelegate {

	let textView = UITextView()
	let submitButton = UIButton()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = Style.shared.whiteSmoke
		
		self.title = "APP FEEDBACK"
		
		submitButton.backgroundColor = Style.shared.lightBlue
		submitButton.setTitle("SUBMIT", for: UIControlState())
		submitButton.setTitleColor(UIColor.white, for: UIControlState())
		submitButton.addTarget(self, action: #selector(submitButtonHandler), for: .touchUpInside)
		
		textView.delegate = self
		textView.backgroundColor = UIColor.white
		textView.returnKeyType = .done
		textView.font = UIFont(name: SYSTEM_FONT, size: Style.shared.P18)

		self.view.addSubview(textView)
		self.view.addSubview(submitButton)
        // Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let navBarHeight:CGFloat = self.navigationController!.navigationBar.frame.height
		let tabBarHeight:CGFloat = self.tabBarController!.tabBar.frame.size.height;
	
		let pad:CGFloat = 30
		textView.frame = CGRect(x: pad, y: pad, width: self.view.frame.size.width - pad*2, height: self.view.frame.size.height - pad*2 - 60 - navBarHeight - tabBarHeight - statusBarHeight())
		submitButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
		submitButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.size.height - pad - 22 - navBarHeight - tabBarHeight - statusBarHeight())

	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		textView.becomeFirstResponder()
	}
	
	func submitButtonHandler(){
		var userString:String = ""
		if let uid = Fire.shared.myUID {
			userString = uid
		}
		let feedbackObject:[String:AnyObject] = [
			"text": textView.text as AnyObject,
			"createdAt": Date.init().timeIntervalSince1970 as AnyObject,
			"user": userString as AnyObject
//					let user = FIRAuth.auth()?.currentUser
		]

		Fire.shared.newUniqueObjectAtPath("feedback", object: feedbackObject as AnyObject) {
			let alertController = UIAlertController.init(title: "Feedback Sent", message: "Thank you for taking time to help!", preferredStyle: .alert)
			let okayButton = UIAlertAction.init(title: "Okay", style: .default, handler: { (action) in
				self.navigationController?.popViewController(animated: true)
			})
			alertController.addAction(okayButton)

			self.present(alertController, animated: true, completion: nil)
		}
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if(text == "\n"){
			textView.resignFirstResponder()
			return false
		}
		return true
	}
}
