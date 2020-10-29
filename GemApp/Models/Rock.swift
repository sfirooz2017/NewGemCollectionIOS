//
//  Rock.swift
//  gem app
//
//  Created by MacBook Pro on 9/8/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import Foundation

class Rock{
    
    private var _imageURL: UIImage?
    private var _month: String?
    private var _color: String!
    private var _description: String!
    private var _name: String!
    private var _index: Int!
    private var _collected: Bool?
    private var _favorites: Bool?
    private var _wishlist: Bool?
    private var _key: String!
    
    var name: String{
        return _name
    }
    var color: String{
        return _color
    }
    var description: String{
        return _description
    }
    var month: String?{
        return _month
    }
    var key: String{
        return _key
    }
    var collected: Bool?{
        get
        {return _collected}
        set
        {_collected = newValue}
    }
    var favorites: Bool?{
        get
        {return _favorites}
        set
        {_favorites = newValue}
    }
    var wishlist: Bool?{
        get
        {return _wishlist}
        set
        {_wishlist = newValue}
    }
    var imageURL: UIImage?{
        get
        {return _imageURL}
        set
        {_imageURL = newValue}
    }
    init(name: String, description: String, color: String, key: String ) {
        _name = name
        _color = color
        _description = description
        _key = key
        
    }
    init(name: String, description: String, color: String, key: String, month: String ) {
        _name = name
        _color = color
        _description = description
        _key = key
        _month = month
    }
}
