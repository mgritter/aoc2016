import CryptoSwift

let input = "qzyelonm"
//let input = "abc"

func triple( _ x : String ) -> String {
    return String( [Character]( repeating:x.characters[x.startIndex],
                                count:3 ) )
}

func septuple( _ x : String ) -> String {
    return String( [Character]( repeating:x.characters[x.startIndex],
                                count:5 ) )
}

let digits = [ "0", "1", "2", "3", "4", "5", "6", "7",
               "8", "9", "a", "b", "c", "d", "e", "f" ]
           
let triples = digits.map( triple )
let septuples = digits.map( septuple )

// Only take the first
func repeats3( foundIn:String ) -> String? {
    var minRange : Range<String.Index>? = nil
    var minString : String? = nil
    for t in triples {
        if let r = foundIn.range(of:t) {
            if minRange == nil ||
                 ( r.upperBound <= minRange!.lowerBound ) {
                minRange = r
                minString = t
            }
        }
    }
    return minString
}

// Same string could provide multipl five-tuples, in theory, I think
func repeats5( foundIn:String) -> [String] {
    return septuples.filter( { foundIn.contains( $0 ) } )
}

func keyGenMD5( _ count : Int ) -> String {
    let x = "\(input)\(count)"
    return x.md5()
}

func keyGenStretch( _ count : Int ) -> String {
    var h = keyGenMD5( count )
    for _ in 1...2016 {
        h = h.md5()
    }
    return h    
}

// Part 1
// var keyGen = keyGenMD5

// Part 2
var keyGen = keyGenStretch

var tripleQ = [(Int,String)]()
var septupleQ = [(Int,String)]()

var found = 0
var target = 64
var count = 0
var window = 1000

while found < target {
    // Find at least one triple
    while tripleQ.isEmpty {        
        let hash = keyGen( count )
        if let t = repeats3( foundIn:hash ) {
            tripleQ.append( (count,t) )
        }
        count += 1
    }

    // Scan forward finding triples and septuples
    let ( startIndex, candidate ) = tripleQ.removeFirst()
    while count <= startIndex + window {
        let hash = keyGen( count )
        if let t = repeats3( foundIn:hash ) {
            tripleQ.append( (count,t) )
            for q in repeats5( foundIn:hash ) {
                septupleQ.append( (count,q) )
            }
        }
        count += 1
    }

    let candidate5 = septuple( candidate )
    for ( i, q ) in septupleQ {
        if q == candidate5 &&
             i > startIndex &&
             i <= startIndex + 1000 {
            found += 1
            print( "#\(found) 3index \(startIndex) \(candidate) 5index \(i)" )
            break
        }
    }
    
    // Remove unneeded entries
    if let freshIndex = septupleQ
         .index( where: {
                          let ( i, q ) = $0
                          return i > startIndex } ) {
        septupleQ.removeFirst( freshIndex )
    } else {
        // No such index
        septupleQ.removeAll()
    }
    // print( "3Q: \(tripleQ)" )
    // print( "5Q: \(septupleQ)" )
}
