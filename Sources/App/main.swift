import Vapor
import HTTP
import Foundation
import SwiftyBeaverVapor
import SwiftyBeaver

let drop = Droplet()
let petController = PetsController()
petController.addRoutes(drop: drop)


let console = ConsoleDestination()
let file = FileDestination()

file.logFileURL = URL(fileURLWithPath: "\(drop.resourcesDir)/VaporLogs.log")
let sbProvider = SwiftyBeaverProvider(destinations: [console, file])
drop.addProvider(sbProvider)

let log = drop.log.self
drop.run()
