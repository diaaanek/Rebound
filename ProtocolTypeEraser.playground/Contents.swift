import UIKit

protocol Request {
    associatedtype Response
    associatedtype Error: Swift.Error

    typealias Handler = (Result<Response, Error>) -> Void

    func perform(then handler: @escaping Handler)
}


enum Error1 : Error {
    case error1
}

enum Error2 : Error {
    case error2
}

struct R1 : Request {
    func perform(then handler: @escaping Handler) {
        
    }
    
    typealias Response = String
    
    typealias Error = Error1
}

struct R2 : Request {
    func perform(then handler: @escaping Handler) {
        
    }
    
    typealias Response = String
    
    typealias Error = Error1
}

//class RequestQueue {
//    // Error: protocol 'Request' can only be used as a generic
//    // constraint because it has Self or associated type requirements
//    func add(_ request: Request,
//             handler: @escaping Request.Handler) {
//
//    }
//}

//RequestQueue().add(R1(), handler: ) // problem

class RequestQueue<r : Request> {
    // Error: protocol 'Request' can only be used as a generic
    // constraint because it has Self or associated type requirements
    func add(_ request: r,
             handler: @escaping r.Handler) {

    }
}
let r1 = R1()
let c = ((String, Error1) -> ()).self
RequestQueue().add(r1, handler: { r in
    
}) // solved

class E1 : Equatable {
    static func == (lhs: E1, rhs: E1) -> Bool {
        return true
    }
    
    
}

class E2 : Equatable {
    static func == (lhs: E2, rhs: E2) -> Bool {
     return true
    }
    
    
}
//var l : Equatable = E1()

//var list : [Equatable]  = [E1, E2] compiler error





