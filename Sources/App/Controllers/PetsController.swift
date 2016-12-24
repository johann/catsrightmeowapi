//
//  CatsController.swift
//  catsapi
//
//  Created by Johann Kerr on 12/23/16.
//
//

import Foundation
import Vapor
import HTTP


enum Pet {
    case dog
    case cat
}
final class PetsController {
    
    func addRoutes(drop:Droplet) {
        drop.get("") { request in
            return try drop.view.make("pet")
        }
        
        let petTypeArray : [Pet] = [.cat, .dog]
        
        petTypeArray.forEach { (pet) in
            drop.group("\(pet)s") { pets in
               
                pets.get("videos",String.self) { request, after in
                    return try self.getMoreVideos(for: pet,request: request, after: after)
                }
                pets.get("videos") { request in
                    return try self.getVideos(for: pet, request: request)
                }
                pets.get("gifs") { request in
                    return try self.getGifs(for: pet, request: request)
                }
                pets.get("gifs",String.self) { request, after in
                    return try self.getMoreGifs(for: pet, request: request, after: after)
                }
            }

        }
        
        /*
        drop.group("cats") { cats in
    
            cats.get("videos",String.self) { request, after in
                return try self.getMoreVideos(for: .cat,request: request, after: after)
            }
            cats.get("videos") { request in
                return try self.getVideos(for: .cat, request: request)
            }
            cats.get("gifs") { request in
                return try self.getGifs(for: .cat, request: request)
            }
            cats.get("gifs",String.self) { request, after in
                return try self.getMoreGifs(for: .cat, request: request, after: after)
            }
        }
 */
        
        
    }
    
    
    
    
    
    func getGifs(for pet:Pet, request: Request) throws -> ResponseRepresentable {
        let url = "https://www.reddit.com/r/\(pet)gifs/hot.json?limit=100"
        let response = try drop.client.get(url)
        var petArray = [Video]()
        let next = response.data["data","after"]?.string ?? ""
        let linkArray = response.data["data", "children", "data"]?.array?.flatMap({$0.object}) ?? []
        
        for link in linkArray {
            
            if let title = link["title"]?.string, let url = link["url"]?.string, let thumbnail = link["thumbnail"]?.string {
                var strippedTitle = title
                strippedTitle.stripEnd()
                
                let urlCopy: String
                if url.hasSuffix("gif") {
                    let video = Video(url: url, thumbnail: thumbnail, title: strippedTitle)
                    petArray.append(video)
                } else if url.hasSuffix("gifv") {
                    urlCopy = url.replacingOccurrences(of: "gifv", with: "gif")
                    let video = Video(url: urlCopy, thumbnail: thumbnail, title: strippedTitle)
                    petArray.append(video)
                }
                
            }
            
        }
        
        
        return try JSON(node:["\(pet)s":petArray.makeNode(),
                              "next":next])
        
    }
    
    func getMoreGifs(for pet:Pet, request: Request, after:String) throws -> ResponseRepresentable {
        let url = "https://www.reddit.com/r/\(pet)gifs/hot.json?limit=100"
        let response = try drop.client.get("\(url)&after=\(after)")
        var petArray = [Video]()
        let next = response.data["data","after"]?.string ?? ""
        
        
        let linkArray = response.data["data", "children", "data"]?.array?.flatMap({$0.object}) ?? []
        
        for link in linkArray {
            if let title = link["title"]?.string, let url = link["url"]?.string, let thumbnail = link["thumbnail"]?.string {
                var strippedTitle = title
                strippedTitle.stripEnd()
                
                let urlCopy: String
                if url.hasSuffix("gif") {
                    let video = Video(url: url, thumbnail: thumbnail, title: strippedTitle)
                    petArray.append(video)
                } else if url.hasSuffix("gifv") {
                    urlCopy = url.replacingOccurrences(of: "gifv", with: "gif")
                    let video = Video(url: urlCopy, thumbnail: thumbnail, title: strippedTitle)
                    petArray.append(video)
                }
                
            }
            
        }
        
        
        return try JSON(node:["\(pet)s":petArray.makeNode(),
                              "next":next])
        
    }
    func getVideos(for pet:Pet, request: Request) throws -> ResponseRepresentable {
        let url = "https://www.reddit.com/r/\(pet)gifs/hot.json?limit=100"
        let response = try drop.client.get(url)
        var petArray = [Video]()
        let next = response.data["data","after"]?.string ?? ""
        
        let linkArray = response.data["data", "children", "data"]?.array?.flatMap({$0.object}) ?? []
        log.verbose("\(linkArray.count)")
        
        for link in linkArray {
            if let title = link["title"]?.string, let url = link["url"]?.string, let thumbnail = link["thumbnail"]?.string {
                var strippedTitle = title
                
                strippedTitle.stripEnd()
                if url.range(of: "tumblr") == nil {
                    let urlCopy: String
                    if url.hasSuffix("gif") {
                    } else if url.hasSuffix("gifv") {
                        urlCopy = url.replacingOccurrences(of: "gifv", with: "mp4")
                        let video = Video(url: urlCopy, thumbnail: thumbnail, title: strippedTitle)
                        petArray.append(video)
                    }
                    
                }
                
            }
            
        }
        
        
        
        return try JSON(node:["\(pet)s":petArray.makeNode(),
                              "next":next])
        
        
        
        
        
    }
    func getMoreVideos(for pet:Pet, request: Request, after: String) throws -> ResponseRepresentable {
        let url = "https://www.reddit.com/r/\(pet)gifs/hot.json?limit=100"
        let response = try drop.client.get("\(url)&after=\(after)")
        var petArray = [Video]()
        let next = response.data["data","after"]?.string ?? ""
        let linkArray = response.data["data", "children", "data"]?.array?.flatMap({$0.object}) ?? []
        
        for link in linkArray {
            if let title = link["title"]?.string, let url = link["url"]?.string, let thumbnail = link["thumbnail"]?.string {
                var strippedTitle = title
                strippedTitle.stripEnd()
                if url.range(of: "tumblr") == nil {
                    let urlCopy: String
                    if url.hasSuffix("gif") {
//                        urlCopy = url.replacingOccurrences(of: "gif", with: "mp4")
//                        let Video = Video(url: urlCopy, thumbnail: thumbnail, title: strippedTitle)
//                        petArray.append(Video)
                    } else if url.hasSuffix("gifv") {
                        urlCopy = url.replacingOccurrences(of: "gifv", with: "mp4")
                        let video = Video(url: urlCopy, thumbnail: thumbnail, title: strippedTitle)
                        petArray.append(video)
                    }
                }
                
            }
            
        }
        
        
        return try JSON(node:["\(pet)s":petArray.makeNode(),
                              "after":next])
        
        
    }
    
    
}



