//
//  Multireddit.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Type of Multireddit icon.
*/
public enum MultiredditIconName : String {
    case ArtAndDesign = "art and design"
    case Ask = "ask"
    case Books = "books"
    case Business = "business"
    case Cars = "cars"
    case Comics = "comics"
    case CuteAnimals = "cute animals"
    case Diy = "diy"
    case Entertainment = "entertainment"
    case FoodAndDrink = "food and drink"
    case Funny = "funny"
    case Games = "games"
    case Grooming = "grooming"
    case Health = "health"
    case LifeAdvice = "life advice"
    case Military = "military"
    case ModelsPinup = "models pinup"
    case Music = "music"
    case News = "news"
    case Philosophy = "philosophy"
    case PicturesAndGifs = "pictures and gifs"
    case Science = "science"
    case Shopping = "shopping"
    case Sports = "sports"
    case Style = "style"
    case Tech = "tech"
    case Travel = "travel"
    case UnusualStories = "unusual stories"
    case Video = "video"
    case None = "None"
    
    init(_ name:String) {
        let iconName = MultiredditIconName(rawValue:name)
        if let iconName:MultiredditIconName = iconName {
            self = iconName
        }
        else {
            self = .None
        }
    }
}

/**
Type of Multireddit visibility.
*/
public enum MultiredditVisibility : String {
    case Private = "private"
    case Public = "public"
    case Hidden = "hidden"
    
    init(_ type:String) {
        let visibilityType = MultiredditVisibility(rawValue:type)
        if let visibilityType:MultiredditVisibility = visibilityType {
            self = visibilityType
        }
        else {
            self = .Private
        }
    }
}

/**
Type of Multireddit weighting scheme.
*/
public enum MultiredditWeightingScheme : String {
    case Classic = "classic"
    case Fresh = "fresh"
    
    init(_ type:String) {
        let weightingScheme = MultiredditWeightingScheme(rawValue:type)
        if let weightingScheme:MultiredditWeightingScheme = weightingScheme {
            self = weightingScheme
        }
        else {
            self = .Classic
        }
    }
}

/**
Multireddit class.
*/
public class Multireddit : SubredditURLPath {
    public var descriptionMd = ""
    public var displayName = ""
    public var iconName:MultiredditIconName = .None
    public var keyColor = "#FFFFFF"
    public var subreddits:[String] = []
    public var visibility:MultiredditVisibility = .Private
    public var weightingScheme:MultiredditWeightingScheme = .Classic
    
    // can not update following attritubes
    public var descriptionHtml = ""
    public var path = ""
    public var name = ""
    public var iconUrl = ""
    public var canEdit = false
    public var copiedFrom = ""
    public var created:NSTimeInterval = 0
    public var createdUtc:NSTimeInterval = 0
    
    public init(json:[String:AnyObject]) {
        descriptionMd = json["description_md"] as? String ?? ""
        displayName = json["display_name"] as? String ?? ""
        
        iconName = MultiredditIconName(json["icon_name"] as? String ?? "")
        visibility = MultiredditVisibility(json["visibility"] as? String ?? "")
        
        keyColor = json["key_color"] as? String ?? ""
        
        if let temp = json["subreddits"] as? [JSON] {
            for element in temp {
                if let element = element as? [String:String] {
                    if let name:String = element["name"] {
                        subreddits.append(name)
                    }
                }
            }
        }
        
        keyColor = json["key_color"] as? String ?? ""
        weightingScheme = MultiredditWeightingScheme(json["weighting_scheme"] as? String ?? "")
        
        descriptionHtml = json["description_html"] as? String ?? ""
        path = json["path"] as? String ?? ""
        name = json["name"] as? String ?? ""
        iconUrl = json["icon_url"] as? String ?? ""
        canEdit = json["can_edit"] as? Bool ?? false
        copiedFrom = json["copied_from"] as? String ?? ""
        created = json["created"] as? NSTimeInterval ?? 0
        createdUtc = json["created_utc"] as? NSTimeInterval ?? 0
    }
}