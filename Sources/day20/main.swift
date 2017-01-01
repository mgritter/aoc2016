import AocMain
import SwiftPriorityQueue
import Foundation

struct AddressRange : Comparable {
    var min : Int
    var max : Int

    static func < (lhs: AddressRange, rhs: AddressRange) -> Bool {
        return lhs.min < rhs.min
    }

    static func ==(lhs: AddressRange, rhs: AddressRange) -> Bool {
        return lhs.min == rhs.min && lhs.max == rhs.max
    }

    static func parse( input : String ) -> AddressRange? {
        let bounds = input.components( separatedBy:"-" )
        guard bounds.count == 2 else {
            return nil
        }
        if let a = Int( bounds[0] ), let b = Int( bounds[1] ) {
            return AddressRange( min:a, max:b )
        } else {
            return nil
        }
    }
}

func leastUnblocked( ranges:[AddressRange] ) -> Int? {
    var pq = PriorityQueue<AddressRange>( ascending:true,
                                          startingValues:ranges )
    var minAvailable = 0
    while !pq.isEmpty {
        if let a = pq.pop() {
            if minAvailable < a.min {
                return minAvailable
            } else {
                minAvailable = max( minAvailable, a.max + 1 )
            }
        }
    }
    return nil
}

func countUnblocked( ranges:[AddressRange] ) -> Int {
    var pq = PriorityQueue<AddressRange>( ascending:true,
                                          startingValues:ranges )
    var minAvailable = 0
    var count = 0
    while !pq.isEmpty {
        if let a = pq.pop() {
            if minAvailable < a.min {
                let numAddr = a.min - minAvailable
                print( "[\(minAvailable), \(a.min)) = \(numAddr)" )
                count += numAddr
            }
            minAvailable = max( minAvailable, a.max + 1 )
        }
    }
    let maxAddress = 4294967295
    print( "[\(minAvailable), \(maxAddress)] = \(maxAddress - minAvailable + 1)" )
    count += max( maxAddress - minAvailable + 1, 0 )
    return count
}

func problem( input : String ) {
    let ranges = input.lines.flatMap( AddressRange.parse )
    if let lu = leastUnblocked( ranges:ranges ) {
        print( "Least address: \(lu)" )        
    } else {
        print( "No available address" )        
    }
    let cu = countUnblocked( ranges:ranges )
    print( "Count: \(cu)" )
}

main( problem )
