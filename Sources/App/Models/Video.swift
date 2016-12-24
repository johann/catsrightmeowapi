//
//  CatVideo.swift
//  catsapi
//
//  Created by Johann Kerr on 12/23/16.
//
//
import Vapor
import Foundation

typealias Dimension = (Double,Double)

final class Video: NodeRepresentable {
    var id: Node?
    var url: String
    var thumbnail: String
    var title: String
    var dimension: Dimension!
    
    init(url:String, thumbnail:String, title:String) {
        self.url = url
        self.thumbnail = thumbnail
        self.title = title
    }
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        url = try node.extract("url")
        thumbnail = try node.extract("thumbnail")
        title = try node.extract("title")
        
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "url": url,
            "thumbnail": thumbnail,
            "title": title
            ])
    }
    
}


extension String {
    
    mutating func stripEnd() {
        let c = self.characters
        if let ix = c.index(of: "(") {
            self = String(c.prefix(upTo: ix))
        }
    }
    
}
