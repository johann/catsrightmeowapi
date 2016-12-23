import Vapor
import HTTP
import Foundation
import SwiftyBeaverVapor
import SwiftyBeaver

let drop = Droplet()
let catController = CatsController()
catController.addRoutes(drop: drop)

let console = ConsoleDestination()  // log to Xcode Console in color
let file = FileDestination()  // log to file in color

file.logFileURL = URL(fileURLWithPath: "\(drop.resourcesDir)/VaporLogs.log") // set log file
let sbProvider = SwiftyBeaverProvider(destinations: [console, file])
drop.addProvider(sbProvider)

// shortcut to avoid writing app.log all the time
let log = drop.log.self
drop.run()
