//
//  PropertyClasses.swift
//  roomX
//
//  Created by Sukkwon On on 2018-08-11.
//  Copyright © 2018 Sukkwon On. All rights reserved.
//

// DB INIT IS NOT INCLUDED.

import Foundation
import UIKit

// GLOBAL
var PRICE:String = ""
var PRICE_MIN:Int = -1
var PRICE_MAX:Int = -1
var NUMBED:String = ""
var NUMBATH:String = ""
var SIZEROOM:String = ""
var BUILDINGTYPES:[Bool] = [false, false]
//추가 및 변경 Amenities and Rule
var AMENITIES:[Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
var RULES:[Bool] = [false, false, false, false, false, false, false, false]
var FILTERING:Bool = false
var CONDITION = [false, false, false, false]
var RENTTYPE = ""
var FROMFILTERING = false


struct cellData {
    let cell : Int!
    let title : String!
    var height: CGFloat!
    let name : String!
    let identifier : String!
    //    let images : [UIImage]!
}

struct userDestination {
    var name: String!
    var address: String!
    var latitude: Double!
    var longitude: Double!
}

class Address {
    var address: String // street number
    var city: String
    var province: String
    var postalCode: String
    var fullAddress: String // **** This does not contain postalCode info. ****
    var latitude: Double
    var longitude: Double
    
    init() {
        self.address = "" // street number
        self.city = ""
        self.province = ""
        self.postalCode = ""
        self.fullAddress = ""
        self.latitude = 0.0
        self.longitude = 0.0
    }
    
    init(address: String, city: String, province: String, postalCode: String, latitude: Double, longitude: Double) {
        self.address = address // street number
        self.city = city
        self.province = province
        self.postalCode = postalCode
        self.fullAddress = address+", "+city+", "+province
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct Station {
    var displayName:String
    var latitude:Double
    var longitude:Double
}

class Around {
    var placeName:String!
    var displayedTime:String!
    var time:TimeInterval!
    
    
    init() {
        self.placeName = ""
        self.displayedTime = ""
        self.time = 0
    }
    
    init(placeName: String, displayedTime: String, time: TimeInterval) {
        self.placeName = placeName
        self.displayedTime = displayedTime
        self.time = time
    }
}


class Property {
//    var title: String
    var author : String
    var description: String
    var address: Address
    var price: Int
    var size: Int
    var numBed: Int
    var numBath: Int
    
    // Rules
    var cats: Bool
    var dogs: Bool
    var smoking: Bool
    var drug: Bool
    //추가
    var party: Bool
    var manonly: Bool
    var womanonly: Bool
    var both: Bool
    
    var furnished: Bool
    
    // Amenities
    var airCon: Bool
    var balcony: Bool
    var closet: Bool
    var dishWash: Bool
    var fridge: Bool
    var heater: Bool
//    var kitchen: Bool
    var laundry: Bool
    var parking: Bool
    var tub: Bool
    var cableTV: Bool
    var internet: Bool
    //추가 했다아ㅏㅏ
    var bed: Bool
    var tubPublic: Bool
    var toiletPublic: Bool
    var stove: Bool
    var microwave: Bool
    var dryerPublic: Bool
    var deskChair: Bool
    var hanger: Bool
    
    var requiredTerm: Int
    var moveInDate: String
    var constructionDate: Int
    var hostPhone: String
    var hostEmail: String
    var dateCreated: String // DB Related
    var timeStamp: Int // DB Related
    var documentID: String // DB Related
    var new: Bool
    var condition: String
    var type: String
    var verified: Bool
    var uid: String
    
    var transportation: Around
    
    var imageURL: [String]
    
    var images:[UIImage]
    
    init() {
        self.author = ""
        self.description = ""
        self.address = Address()
        self.price = -1
        self.size = -1
        self.numBed = -1
        self.numBath = -1
        // Rules
        self.cats = false
        self.dogs = false
        self.smoking = false
        self.drug = false
        //추가
        self.party = false
        self.manonly = false
        self.womanonly = false
        self.both = false
        
        
        
        self.furnished = false
        
        self.airCon = false
        self.balcony = false
        self.closet = false
        self.dishWash = false
        self.fridge = false
        self.heater = false
//        self.kitchen = false
        self.laundry = false
        self.parking = false
        self.tub = false
        self.cableTV = false
        self.internet = false
        //추가 했다아ㅏㅏ
        self.bed = false
        self.tubPublic = false
        self.toiletPublic = false
        self.stove = false
        self.microwave = false
        self.dryerPublic = false
        self.deskChair = false
        self.hanger = false
        
        self.requiredTerm = -1
        self.moveInDate = ""
        self.constructionDate = -1
        self.hostPhone = ""
        self.hostEmail = ""
        self.dateCreated = String() // DB Related
        self.timeStamp = -1 // DB Related
        self.documentID = "" // DB Related
        self.new = false
        self.condition = ""
        self.type = ""
        self.verified = false
        self.uid = ""
        self.transportation = Around()
        
        self.imageURL = []
        
        self.images = []
    }
    //추가 및 변경 했다아ㅏㅏ
    init(author: String, description: String, address: Address, price: Int, size: Int, numBed: Int, numBath: Int, cats: Bool, dogs: Bool, smoking: Bool, drug: Bool, party: Bool, manonly: Bool, womanonly: Bool, both: Bool , furnished: Bool, airCon: Bool, balcony: Bool, closet: Bool, dishWash: Bool, fridge: Bool, heater: Bool, kitchen: Bool, laundry: Bool, parking: Bool, tub: Bool, cableTV: Bool, internet: Bool, bed: Bool, tubPublic: Bool, toiletPublic: Bool, stove: Bool, microwave: Bool, dryerPublic: Bool, deskChair: Bool, hanger: Bool, requiredTerm: Int, moveInDate: String, constructionDate: Int, hostPhone: String, hostEmail: String, dateCreated: String, timeStamp: Int, documentID: String, new: Bool, condition: String, type: String, verified: Bool, uid: String, transportation: Around, imageURL: [String], images: [UIImage]) {
        
        self.author = author
        self.description = description
        self.address = address
        self.price = price
        self.size = size
        self.numBed = numBed
        self.numBath = numBath
        
        self.cats = cats
        self.dogs = dogs
        self.smoking = smoking
        self.drug = drug
        //추가
        self.party = party
        self.manonly = manonly
        self.womanonly = womanonly
        self.both = both
        
        self.furnished = furnished
        
        self.airCon = airCon
        self.balcony = balcony
        self.closet = closet
        self.dishWash = dishWash
        self.fridge = fridge
        self.heater = heater
//        self.kitchen = kitchen
        self.laundry = laundry
        self.parking = parking
        self.tub = tub
        self.cableTV = cableTV
        self.internet = internet
        //추가 했다아ㅏㅏ
        self.bed = bed
        self.tubPublic = tubPublic
        self.toiletPublic = toiletPublic
        self.stove = stove
        self.microwave = microwave
        self.dryerPublic = dryerPublic
        self.deskChair = deskChair
        self.hanger = hanger
        
        self.requiredTerm = requiredTerm
        self.moveInDate = moveInDate
        self.constructionDate = constructionDate
        self.hostPhone = hostPhone
        self.hostEmail = hostEmail
        self.dateCreated = dateCreated // DB Related
        self.timeStamp = timeStamp // DB Related
        self.documentID = documentID // DB Related
        self.new = new
        self.condition = condition
        self.type = type
        self.verified = verified
        self.uid = uid
        
        self.transportation = transportation
        
        self.imageURL = imageURL
        
        self.images = images
    }
    
    init?(dictionary: [String: Any]) {
        guard let author = dictionary["author"] as? String else { return nil }
        self.author = author
        guard let description = dictionary["description"] as? String else { return nil }
        self.description = description
        guard let addressDic = dictionary["address"] as? NSDictionary else {return nil}
        guard let province = addressDic["province"] as? String else {return nil }
        //        self.address.province = province
        guard let city = addressDic["city"] as? String else { return nil }
        //        self.address.city = city
        guard let address = addressDic["address"] as? String else { return nil }
        //        self.address.address = address
        guard let postalCode = addressDic["postalCode"] as? String else { return nil }
        //        self.address.postalCode = postalCode
        guard let latitude = addressDic["latitude"] as? Double else { return nil }
        //        self.address.latitude = latitude
        guard let longitude = addressDic["longitude"] as? Double else { return nil }
        //        self.address.longitude = longitude
        self.address = Address(address: address, city: city, province: province, postalCode: postalCode, latitude: latitude, longitude: longitude)

        guard let price = dictionary["price"] as? Int else { return nil }
        self.price = price
        guard let size = dictionary["size"] as? Int else { return nil }
        self.size = size
        guard let numBed = dictionary["numBed"] as? Int else { return nil }
        self.numBed = numBed
        guard let numBath = dictionary["numBath"] as? Int else { return nil }
        self.numBath = numBath
        guard let cats = dictionary["cats"] as? Bool else { return nil }
        self.cats = cats
        guard let dogs = dictionary["dogs"] as? Bool else { return nil }
        self.dogs = dogs
        guard let smoking = dictionary["smoking"] as? Bool else { return nil }
        self.smoking = smoking
        guard let drug = dictionary["drug"] as? Bool else { return nil }
        self.drug = drug
        guard let party = dictionary["party"] as? Bool else { return nil }
        //추가 할거 졸라많네 시ㅍ
        self.party = party
        guard let manonly = dictionary["manonly"] as? Bool else { return nil }
        self.manonly = manonly
        guard let womanonly = dictionary["womanonly"] as? Bool else { return nil }
        self.womanonly = womanonly
        guard let both = dictionary["both"] as? Bool else { return nil }
        self.both = both
        

        guard let furnished = dictionary["furnished"] as? Bool else { return nil }
        self.furnished = furnished

        guard let airCon = dictionary["airCon"] as? Bool else { return nil }
        self.airCon = airCon
        guard let balcony = dictionary["balcony"] as? Bool else { return nil }
        self.balcony = balcony
        guard let closet = dictionary["closet"] as? Bool else { return nil }
        self.closet = closet
        guard let dishWash = dictionary["dishWash"] as? Bool else { return nil }
        self.dishWash = dishWash
        guard let fridge = dictionary["fridge"] as? Bool else { return nil }
        self.fridge = fridge
        guard let heater = dictionary["heater"] as? Bool else { return nil }
        self.heater = heater
//        guard let kitchen = dictionary["kitchen"] as? Bool else { return nil }
//        self.kitchen = kitchen
        guard let laundry = dictionary["laundry"] as? Bool else { return nil }
        self.laundry = laundry
        guard let parking = dictionary["parking"] as? Bool else { return nil }
        self.parking = parking
        guard let tub = dictionary["tub"] as? Bool else { return nil }
        self.tub = tub
        guard let cableTV = dictionary["cableTV"] as? Bool else { return nil }
        self.cableTV = cableTV
        guard let internet = dictionary["internet"] as? Bool else { return nil }
        self.internet = internet
        //추가 했다아ㅏㅏ
        guard let bed = dictionary["bed"] as? Bool else { return nil }
        self.bed = bed
        guard let tubPublic = dictionary["tubPublic"] as? Bool else { return nil }
        self.tubPublic = tubPublic
        guard let toiletPublic = dictionary["toiletPublic"] as? Bool else { return nil }
        self.toiletPublic = toiletPublic
        guard let stove = dictionary["stove"] as? Bool else { return nil }
        self.stove = stove
        guard let microwave = dictionary["microwave"] as? Bool else { return nil }
        self.microwave = microwave
        guard let dryerPublic = dictionary["dryerPublic"] as? Bool else { return nil }
        self.dryerPublic = dryerPublic
        guard let deskChair = dictionary["deskChair"] as? Bool else { return nil }
        self.deskChair = deskChair
        guard let hanger = dictionary["hanger"] as? Bool else { return nil }
        self.hanger = hanger
    
        

        guard let requiredTerm = dictionary["requiredTerm"] as? Int else { return nil }
        self.requiredTerm = requiredTerm
        guard let moveInDate = dictionary["moveInDate"] as? String else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: moveInDate)
        dateFormatter.dateFormat = "MMM dd"
        self.moveInDate = dateFormatter.string(from: date!)
        guard let constructionDate = dictionary["constructionDate"] as? Int else { return nil }
        self.constructionDate = constructionDate
        guard let hostPhone = dictionary["hostPhone"] as? String else { return nil }
        self.hostPhone = hostPhone
        guard let hostEmail = dictionary["hostEmail"] as? String else { return nil }
        self.hostEmail = hostEmail

        guard let dateCreated = dictionary["dateCreated"] as? String else { return nil }
        self.dateCreated = dateCreated
        guard let timeStamp = dictionary["timeStamp"] as? Int else { return nil }
        self.timeStamp = timeStamp

        self.documentID = ""

        guard let new = dictionary["new"] as? Bool else { return nil }
        self.new = new
        guard let condition = dictionary["condition"] as? String else { return nil }
        self.condition = condition
        guard let type = dictionary["type"] as? String else { return nil }
        self.type = type
        guard let verified = dictionary["verified"] as? Bool else { return nil }
        self.verified = verified
        guard let uid = dictionary["uid"] as? String else { return nil }
        self.uid = uid
        
        guard let transportationDic = dictionary["transportation"] as? NSDictionary else {return nil}
        guard let transportationStation = transportationDic["station"] as? String else {return nil }
        guard let transportationDisplayedTime = transportationDic["displayedTime"] as? String else {return nil }
        guard let transportationTime = transportationDic["time"] as? TimeInterval else {return nil }
        self.transportation = Around(placeName: transportationStation, displayedTime: transportationDisplayedTime, time: transportationTime)
        
        guard let imageArray = dictionary["images"] as? [[String:String]] else {return nil}
        
        let sortedArray = imageArray.sorted {$0["index"]! < $1["index"]!}
        
        self.imageURL = []
        
        for i in 0...sortedArray.count-1 {
            self.imageURL.append(sortedArray[i]["url"]!)
        }
        
        self.images = []
    }
}

class userData {
    //    var title: String
    var uid: String
    var photoURL : String
    var email: String
    var displayName: String
    
    
    init() {
        self.uid = ""
        self.photoURL = ""
        self.email = "no email"
        self.displayName = "no name"
    }
    
    init?(dictionary: [String: Any]) {
        guard let uid = dictionary["uid"] as? String else { return nil }
        self.uid = uid
        guard let photoURL = dictionary["photoURL"] as? String else {return nil}
        self.photoURL = photoURL
        guard let email = dictionary["email"] as? String else {return nil }
        self.email = email
        guard let displayName = dictionary["displayName"] as? String else {return nil }
        self.displayName = displayName
    }
    
}
