
struct Coordinate: Hashable {
    let x : Int
    let y : Int
    
    var hashValue : Int {
        get {
            return x ^ y
        }
    }

    var blockDistance : Int {
        get {
            return abs( x ) + abs( y )
        }
    }

    func walkNorth( _ distance : Int ) -> [Coordinate] {
        return (1...distance).map {  Coordinate( x: x, y : y+$0 ) }
    }

    func walkSouth( _ distance : Int ) -> [Coordinate] {
        return (1...distance).map {  Coordinate( x: x, y : y-$0 ) }
    }

    func walkEast( _ distance : Int ) -> [Coordinate] {
        return (1...distance).map {  Coordinate( x: x+$0, y : y ) }
    }
        
    func walkWest( _ distance : Int ) -> [Coordinate] {
        return (1...distance).map {  Coordinate( x: x-$0, y : y ) }
    }    
}

func ==(left: Coordinate, right: Coordinate) -> Bool {
    return left.x == right.x && left.y == right.y
}
