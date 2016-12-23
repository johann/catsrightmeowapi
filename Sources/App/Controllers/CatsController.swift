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

final class CatsController {
    
    let url = "https://www.reddit.com/r/catgifs/hot.json?limit=100"
    func addRoutes(drop:Droplet) {
        drop.get("") { request in
            log.verbose("not so important")
            log.debug("something to debug")
            log.info("a nice information")
            log.warning("oh no, that won’t be good")
            log.error("ouch, an error did occur!")
            return try drop.view.make("cat")
        }
        drop.get("videos",String.self) { request, after in
            return try self.getMoreVideos(request: request, after: after)
        }
        drop.get("videos", handler:getVideos)
        drop.get("gifs", handler:getGifs)
        drop.get("gifs",String.self) { request, after in
            return try self.getMoreGifs(request: request, after: after)
        }
    }
    func getGifs(request: Request) throws -> ResponseRepresentable {
        let response = try drop.client.get(url)
        var catArray = [CatVideo]()
        let next = response.data["data","after"]?.string ?? ""
        
        
        let linkArray = response.data["data", "children", "data"]?.array?.flatMap({$0.object}) ?? []
        
        for link in linkArray {
            if let title = link["title"]?.string, let url = link["url"]?.string, let thumbnail = link["thumbnail"]?.string {
                var strippedTitle = title
                strippedTitle.stripEnd()
                
                let urlCopy: String
                if url.hasSuffix("gif") {
                    let catVideo = CatVideo(url: url, thumbnail: thumbnail, title: strippedTitle)
                    catArray.append(catVideo)
                } else if url.hasSuffix("gifv") {
                    urlCopy = url.replacingOccurrences(of: "gifv", with: "gif")
                    let catVideo = CatVideo(url: urlCopy, thumbnail: thumbnail, title: strippedTitle)
                    catArray.append(catVideo)
                }
                
            }
            
        }
        
        
        return try JSON(node:["cats":catArray.makeNode(),
                              "next":next])
        
    }
    
    func getMoreGifs(request: Request, after:String) throws -> ResponseRepresentable {
        let response = try drop.client.get("\(url)&after=\(after)")
        var catArray = [CatVideo]()
        let next = response.data["data","after"]?.string ?? ""
        
        
        let linkArray = response.data["data", "children", "data"]?.array?.flatMap({$0.object}) ?? []
        
        for link in linkArray {
            if let title = link["title"]?.string, let url = link["url"]?.string, let thumbnail = link["thumbnail"]?.string {
                var strippedTitle = title
                strippedTitle.stripEnd()
                
                let urlCopy: String
                if url.hasSuffix("gif") {
                    let catVideo = CatVideo(url: url, thumbnail: thumbnail, title: strippedTitle)
                    catArray.append(catVideo)
                } else if url.hasSuffix("gifv") {
                    urlCopy = url.replacingOccurrences(of: "gifv", with: "gif")
                    let catVideo = CatVideo(url: urlCopy, thumbnail: thumbnail, title: strippedTitle)
                    catArray.append(catVideo)
                }
                
            }
            
        }
        
        
        return try JSON(node:["cats":catArray.makeNode(),
                              "next":next])
        
    }
    func getVideos(request: Request) throws -> ResponseRepresentable {
        
        let response = try drop.client.get(url)
        var catArray = [CatVideo]()
        let next = response.data["data","after"]?.string ?? ""
        log.verbose("\(response)")
        log.verbose("\(next)")
        log.verbose("not so important")
        log.debug("something to debug")
        log.info("a nice information")
        log.warning("oh no, that won’t be good")
        log.error("ouch, an error did occur!")
        
        let linkArray = response.data["data", "children", "data"]?.array?.flatMap({$0.object}) ?? []
        
        for link in linkArray {
            if let title = link["title"]?.string, let url = link["url"]?.string, let thumbnail = link["thumbnail"]?.string {
                var strippedTitle = title
                strippedTitle.stripEnd()
                
                if url.range(of: "tumblr") == nil {
                    let urlCopy: String
                    if url.hasSuffix("gif") {
                        urlCopy = url.replacingOccurrences(of: "gif", with: "mp4")
                        let catVideo = CatVideo(url: urlCopy, thumbnail: thumbnail, title: strippedTitle)
                        catArray.append(catVideo)
                    } else if url.hasSuffix("gifv") {
                        urlCopy = url.replacingOccurrences(of: "gifv", with: "mp4")
                        let catVideo = CatVideo(url: urlCopy, thumbnail: thumbnail, title: strippedTitle)
                        catArray.append(catVideo)
                    }
                    
                }
                
            }
            
        }
        
        
        return try JSON(node:["cats":catArray.makeNode(),
                              "next":next])
    }
    func getMoreVideos(request: Request, after: String) throws -> ResponseRepresentable {
        
        let response = try drop.client.get("\(url)&after=\(after)")
        var catArray = [CatVideo]()
        let next = response.data["data","after"]?.string ?? ""
        let linkArray = response.data["data", "children", "data"]?.array?.flatMap({$0.object}) ?? []
        
        for link in linkArray {
            if let title = link["title"]?.string, let url = link["url"]?.string, let thumbnail = link["thumbnail"]?.string {
                var strippedTitle = title
                strippedTitle.stripEnd()
                if url.range(of: "tumblr") == nil {
                    let urlCopy: String
                    if url.hasSuffix("gif") {
                        urlCopy = url.replacingOccurrences(of: "gif", with: "mp4")
                        let catVideo = CatVideo(url: urlCopy, thumbnail: thumbnail, title: strippedTitle)
                        catArray.append(catVideo)
                    } else if url.hasSuffix("gifv") {
                        urlCopy = url.replacingOccurrences(of: "gifv", with: "mp4")
                        let catVideo = CatVideo(url: urlCopy, thumbnail: thumbnail, title: strippedTitle)
                        catArray.append(catVideo)
                    }
                }
                
            }
            
        }
        
        
        return try JSON(node:["cats":catArray.makeNode(),
                              "after":next])
        
        
    }
    
    
}

