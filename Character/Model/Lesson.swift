//
// SWIFT object for a LESSON entry in the database
//

// SAMPLE ENTRY:

//	"-KPxUy1poxoIvAI4amyl" : {
//		"body" : "large amount of text...",
//		"grade" : 0,
//		"image" : "98BEFED0-0972-40EF-A8A9-D56055A0A0C8.jpg",
//		"lesson_author" : "text",
//		"pillar" : 0,
//		"quote" : "text",
//		"quote_author" : "text",
//		"title" : "text",
//      "order" : 22
//	}

import Foundation

class Lesson {

	// ID
	var key:String?
	
	// tags
	var grade:Int?
	var pillar:Int?
	
	// time
	var date:Date?
	var order:Int?

	// lesson
	var title:String?
	var body:String?
	var author:String?

	// quote
	var quote:String?
	var quoteAuthor:String?

	var image:String?
	
	init(key:String, dictionary:Dictionary<String,AnyObject>) {
		self.key = key
		self.body = dictionary["body"] as? String
		self.grade = dictionary["grade"] as? Int
		self.image = dictionary["image"] as? String
		self.author = dictionary["lesson_author"] as? String
		self.pillar = dictionary["pillar"] as? Int
		self.quote = dictionary["quote"] as? String
		self.quoteAuthor = dictionary["quote_author"] as? String
		self.title = dictionary["title"] as? String
		self.order = dictionary["order"] as? Int
	}
}

