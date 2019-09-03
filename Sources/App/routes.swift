import Vapor
import FluentMySQL
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller

    let userController = UserController()
    router.post("newUser", use: userController.saveUser)
    router.post("login", use: userController.login)
    
    let locationController = LocationController()
    router.post("saveLocation", use: locationController.uploadLocation)
    router.post("clean", use: locationController.uploadCleanLocation)
    router.get("locations", use: locationController.returnLocations)
    
    let clientController = ClientTest()
    router.get("clientTest", use: clientController.client)
//    router.get("todos", use: todoController.index)
//    router.post("todos", use: todoController.create)
//    router.delete("todos", Todo.parameter, use: todoController.delete)
}
