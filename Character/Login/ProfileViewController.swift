//
//  ProfileViewController.swift
//  Login
//
//  Created by Robby on 8/5/16.
//  Copyright © 2016 Robby. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
	
	let profileImageView:UIImageView = UIImageView()
	let profileImageButton:UIButton = UIButton()
	let nameField: UITextField = UITextField()
	let emailField: UITextField = UITextField()
	let detail1Button: UIButton = UIButton()
//	let detail2Field: UITextField = UITextField()
	let signoutButton: UIButton = UIButton()
	
	var updateTimer:NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = Style.shared.whiteSmoke

		// buttons
		signoutButton.setTitle("Sign Out", forState: UIControlState.Normal)
		profileImageButton.addTarget(self, action: #selector(profilePictureButtonHandler), forControlEvents: .TouchUpInside)
		detail1Button.addTarget(self, action: #selector(detail1ButtonHandler), forControlEvents: UIControlEvents.TouchUpInside)
		signoutButton.addTarget(self, action: #selector(logOut), forControlEvents: UIControlEvents.TouchUpInside)

		// ui custom
		nameField.delegate = self
		emailField.delegate = self
//		detail2Field.delegate = self
		profileImageView.contentMode = .ScaleAspectFill
		profileImageView.backgroundColor = UIColor.whiteColor()
		profileImageView.clipsToBounds = true
		nameField.backgroundColor = UIColor.whiteColor()
		emailField.backgroundColor = UIColor.whiteColor()
		detail1Button.backgroundColor = UIColor.whiteColor()
		detail1Button.setTitleColor(UIColor.blackColor(), forState: .Normal)
		detail1Button.titleLabel?.textAlignment = .Center
//		detail2Field.backgroundColor = UIColor.whiteColor()
		signoutButton.backgroundColor = Style.shared.lightBlue
		nameField.placeholder = "Name"
		emailField.placeholder = "Email Address"
//		detail2Field.placeholder = "Detail Text"
		
		emailField.enabled = false
		
		// text field padding
		let paddingName = UIView.init(frame: CGRectMake(0, 0, 5, 40))
		let paddingEmail = UIView.init(frame: CGRectMake(0, 0, 5, 40))
		nameField.leftView = paddingName
		emailField.leftView = paddingEmail
		nameField.leftViewMode = .Always
		emailField.leftViewMode = .Always

		self.view.addSubview(profileImageView)
		self.view.addSubview(profileImageButton)
		self.view.addSubview(nameField)
		self.view.addSubview(emailField)
		self.view.addSubview(detail1Button)
		self.view.addSubview(signoutButton)
		
		// populate screen
		Fire.shared.getUser { (uid, userData) in
//			print("Here's the user data:")
//			print(userData)
			if(uid != nil && userData != nil){
				self.populateUserData(uid!, userData: userData!)
			}
		}
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textFieldDidChange), name: "UITextFieldTextDidChangeNotification", object: nil)
    }
	
	override func viewWillAppear(animated: Bool) {
		
		// frames
		let imgSize:CGFloat = self.view.bounds.size.width * 0.4
		let imgArea:CGFloat = self.view.bounds.size.width * 0.5
		profileImageView.frame = CGRectMake(0, 0, imgSize, imgSize)
		profileImageView.center = CGPointMake(self.view.center.x, imgArea*0.5)
		profileImageView.layer.cornerRadius = imgSize*0.5
		profileImageButton.frame = profileImageView.frame
		nameField.frame = CGRectMake(0, imgArea + 10, self.view.bounds.size.width, 44)
		emailField.frame = CGRectMake(0, imgArea + 10*2 + 44*1, self.view.bounds.size.width, 44)
		detail1Button.frame = CGRectMake(0, imgArea + 10*3 + 44*2, self.view.bounds.size.width, 44)
		signoutButton.frame = CGRectMake(0, imgArea + 10*5 + 44*3, self.view.bounds.size.width, 44)
		
	}

	
	func populateUserData(uid:String, userData:NSDictionary){
		if(userData["image"] != nil){
			profileImageView.profileImageFromUID(uid)
//			profileImageView.imageFromUrl(userData["image"] as! String)
		}
		emailField.text = userData["email"] as? String
		nameField.text = userData["displayName"] as? String
//		detail2Field.text = userData["detail2"] as? String

		var gradeLevels:[Int]? = userData["grade"] as? [Int]
		if(gradeLevels == nil){
			gradeLevels = [0,1,2,3]
		}
		if(gradeLevels!.contains(0) && gradeLevels!.contains(1) && gradeLevels!.contains(2) && gradeLevels!.contains(3)){
			detail1Button.setTitle("All Grades", forState: .Normal)
		}
		else if(gradeLevels!.contains(0)){
			detail1Button.setTitle(Character.shared.gradeNames[0], forState: .Normal)
		}
		else if(gradeLevels!.contains(1)){
			detail1Button.setTitle(Character.shared.gradeNames[1], forState: .Normal)
		}
		else if(gradeLevels!.contains(2)){
			detail1Button.setTitle(Character.shared.gradeNames[2], forState: .Normal)
		}
		else if(gradeLevels!.contains(3)){
			detail1Button.setTitle(Character.shared.gradeNames[3], forState: .Normal)
		}
	}
	
	func logOut(){
		do{
			try FIRAuth.auth()?.signOut()
			self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
		}catch{
			
		}
	}
	
	func detail1ButtonHandler(sender:UIButton){
		let alert = UIAlertController.init(title: "", message: nil, preferredStyle: .ActionSheet)
		let action1 = UIAlertAction.init(title: Character.shared.gradeNames[0], style: .Default) { (action) in
			self.detail1Button.setTitle(Character.shared.gradeNames[0], forState: .Normal)
			Fire.shared.updateUserWithKeyAndValue("grade", value: [0], completionHandler: nil)
			let master:MasterController = self.tabBarController as! MasterController
			master.reloadLessons([0])
		}
		let action2 = UIAlertAction.init(title: Character.shared.gradeNames[1], style: .Default) { (action) in
			self.detail1Button.setTitle(Character.shared.gradeNames[1], forState: .Normal)
			Fire.shared.updateUserWithKeyAndValue("grade", value: [1], completionHandler: nil)
			let master:MasterController = self.tabBarController as! MasterController
			master.reloadLessons([1])
		}
		let action3 = UIAlertAction.init(title: Character.shared.gradeNames[2], style: .Default) { (action) in
			self.detail1Button.setTitle(Character.shared.gradeNames[2], forState: .Normal)
			Fire.shared.updateUserWithKeyAndValue("grade", value: [2], completionHandler: nil)
			let master:MasterController = self.tabBarController as! MasterController
			master.reloadLessons([2])
		}
		let action4 = UIAlertAction.init(title: Character.shared.gradeNames[3], style: .Default) { (action) in
			self.detail1Button.setTitle(Character.shared.gradeNames[3], forState: .Normal)
			Fire.shared.updateUserWithKeyAndValue("grade", value: [3], completionHandler: nil)
			let master:MasterController = self.tabBarController as! MasterController
			master.reloadLessons([3])
		}
		let action5 = UIAlertAction.init(title: "All Grades", style: .Default) { (action) in
			self.detail1Button.setTitle("All Grades", forState: .Normal)
			Fire.shared.updateUserWithKeyAndValue("grade", value: [0,1,2,3], completionHandler: nil)
			let master:MasterController = self.tabBarController as! MasterController
			master.reloadLessons([0,1,2,3])
		}
		let cancel = UIAlertAction.init(title: "Cancel", style: .Cancel) { (action) in }
		alert.addAction(action1)
		alert.addAction(action2)
		alert.addAction(action3)
		alert.addAction(action4)
		alert.addAction(action5)
		alert.addAction(cancel)
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	func profilePictureButtonHandler(sender:UIButton){
		let alert = UIAlertController.init(title: "Change Profile Image", message: nil, preferredStyle: .ActionSheet)
		let action1 = UIAlertAction.init(title: "Camera", style: .Default) { (action) in
		}
		let action2 = UIAlertAction.init(title: "Photos", style: .Default) { (action) in
			self.openImagePicker()
		}
		let action3 = UIAlertAction.init(title: "Cancel", style: .Cancel) { (action) in }
		alert.addAction(action1)
		alert.addAction(action2)
		alert.addAction(action3)
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	func textFieldDidChange(notif: NSNotification) {
		let textField = notif.object! as! UITextField
		let string = textField.text
		print(string)
		if(updateTimer != nil){
			updateTimer?.invalidate()
			updateTimer = nil
		}
		updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateWithDelay), userInfo: nil, repeats: false)
	}
	
	func updateWithDelay() {
		// hanging text fields
		print("update delay")
		Fire.shared.updateUserWithKeyAndValue("displayName", value: nameField.text!, completionHandler: nil)

		if(updateTimer != nil){
			updateTimer?.invalidate()
			updateTimer = nil
		}
	}
	
	deinit{
		if(updateTimer != nil){
			updateWithDelay()
		}
	}
	
	
	func textFieldDidEndEditing(textField: UITextField) {
		if(textField.isEqual(nameField)){
			Fire.shared.updateUserWithKeyAndValue("displayName", value: textField.text!, completionHandler: nil)
		}
//		if(textField.isEqual(detail2Field)){
//			Fire.shared.updateUserWithKeyAndValue("detail2", value: textField.text!, completionHandler: nil)
//		}
	}
//	override func textFieldDidBeginEditing(textField: UITextField) {
//		
//	}
	
	
	
	func openImagePicker(){
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		self.navigationController?.presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		let image = info[UIImagePickerControllerOriginalImage] as! UIImage
		let data = UIImageJPEGRepresentation(image, 0.5)
		if(data != nil){
			Fire.shared.uploadFileAndMakeRecord(data!, fileType: .IMAGE_JPG, description: nil, completionHandler: { (downloadURL) in
				if(downloadURL != nil){
					Fire.shared.updateUserWithKeyAndValue("image", value: downloadURL!.absoluteString, completionHandler: { (success) in
						if(success){
							Cache.shared.profileImage[Fire.shared.myUID!] = image
							self.profileImageView.image = image
						}
						else{
							
						}
					})
				}
			})
		}
		if(data == nil){
			print("data is nil")
		}
		self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
}
