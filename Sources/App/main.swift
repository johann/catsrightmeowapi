import Vapor
import HTTP
import Foundation

let drop = Droplet()
let catController = CatsController()
catController.addRoutes(drop: drop)

drop.run()
