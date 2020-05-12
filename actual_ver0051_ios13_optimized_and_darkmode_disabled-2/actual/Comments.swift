//
//  Comments.swift
//  actual
//
//  Created by Sukkwon On on 2019-03-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

struct Comment
{
    static func allComments() -> [Comment]
    {
        let comments = [
            Comment(user: .emily, text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat."),
            Comment(user: .brendon, text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat."),
            Comment(user: .chalene, text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat."),
            Comment(user: .tony, text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat."),
            Comment(user: .steve, text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat."),
            Comment(user: .mark, text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat."),
            Comment(user: .sk, text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat."),
            Comment(user: .mh, text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat."),
            Comment(user: .jm, text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat."),
            Comment(user: .dy, text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat."),
            ]
        
        return comments
    }
    
    enum User {
        case emily
        case brendon
        case chalene
        case tony
        case steve
        case mark
        case sk
        case mh
        case jm
        case dy
        
        func toString() -> String {
            switch self {
            case .emily:
                return "Emily"
            case .brendon:
                return "Brendon Burchard"
            case .chalene:
                return "Chalene Johnson"
            case .tony:
                return "Tony Robbins"
            case .steve:
                return "Steve Jobs"
            case .mark:
                return "Mark Zuckerberg"
            case .sk:
                return "Amenity"
            case .mh:
                return "Transportation"
            case .jm:
                return "Rules"
            case .dy:
                return "Map"
            }
        }
        
        func toColor() -> UIColor {
            switch self {
            case .emily:
                return UIColor(red: 0.106, green: 0.686, blue: 0.125, alpha: 1)
            case .brendon:
                return UIColor(red: 0.114, green: 0.639, blue: 0.984, alpha: 1)
            case .chalene:
                return UIColor(red: 0.322, green: 0.459, blue: 0.984, alpha: 1)
            case .tony:
                return UIColor(red: 0.502, green: 0.290, blue: 0.984, alpha: 1)
            case .steve:
                return UIColor(red: 0.988, green: 0.271, blue: 0.282, alpha: 1)
            case .mark:
                return UIColor(red: 0.620, green: 0.776, blue: 0.153, alpha: 1)
            case .sk:
                return UIColor.red
            case .mh:
                return UIColor.orange
            case .jm:
                return UIColor.green
            case .dy:
                return UIColor.blue
            }
        }
    }
    
    let user: User
    let text: String
}

