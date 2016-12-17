import AocMain
import Foundation

class MaxCollection {
    var collection : [Character:Int] = [:]
    var max : Character? = nil
    var maxCount : Int? = nil

    var min : Character? {
        get {
            return collection.keys.min { collection[$0]! < collection[$1]! }
        }
    }
    
    func add( character : Character ) {
        let newCount : Int
        if let oldCount = collection[character] {
            newCount = oldCount + 1
        } else {
            newCount = 1
        }
        self.collection[character] = newCount
        if ( maxCount ?? 0 ) < newCount {
            self.maxCount = newCount
            self.max = character
        }
    }
}

func problem( input : String ) {
    // So... String.Index isn't Hashable.
    // which means we need to work with Ints instead.
    // which means we can't really use String.Index anyway.
    var columns : [MaxCollection] = []
    for line in input.lines {
        if line == "" {
            continue;
        }
        let chars = Array( line.characters )
        for _ in columns.count..<chars.count {
            columns.append( MaxCollection() )
        }                          
        for i in 0..<chars.count {
            columns[i].add( character:chars[i] )
        }
    }

    let output = columns.map { $0.max ?? "-" }
    print( "Max: ", String( output ) )

    let output2 = columns.map { $0.min ?? "-" }
    print( "Min: ", String( output2 ) )
}
    
                              

main( problem )
        
