//
//  Struct.swift
//  RackSpace
//
//  Created by chirag agarwal on 6/7/18.
//  Copyright © 2018 chirag. All rights reserved.
//

import Foundation

struct LabelStruct : Decodable {
    var label : String
}

struct DataEntryStruct : Decodable {
    var title : LabelStruct
    var artist : LabelStruct
    
    private enum CodingKeys: String, CodingKey {
        case title = "im:name"
        case artist = "im:artist"
    }
}

struct EntryStruct: Decodable{
    var entry : [DataEntryStruct]
}

struct FeedStruct: Decodable{
    var feed : EntryStruct
}

struct songLyricsStruct: Decodable{
    var lyrics : String
}
