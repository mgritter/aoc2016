let input = 3014387

// Part one is just the Josephus problem with the case k=2
// which has solution surivior(2^m + l) =  2l+1, for 0 <= l < 2^m

func powerOfTwo( _ n : Int ) -> ( m : Int, remainder : Int ) {
    var m = 0
    var twoM = 1
    
    while 2 * twoM <= n {
        m += 1
        twoM *= 2
    }

    return ( m, n - twoM )
}

let ( m, l ) = powerOfTwo( input )

print( "\(input) = 2^\(m) + \(l)" )
print( "Survivor = \(2*l+1)" )

// Part two has a different recurrence.
// n     1 2 3 4 5 6 7 8 9   
// f(n)  1 1 3 1 2 3 5 7

// Going from 2k to 2k+1,
// we renumber all the positions by +1 to go "backwards" to the next
// elf, then in the new ordering, positions [k+1...2k] by +1 to
// make room for the killed elf.
//
// n = 4:   1       2 3 4
//          2       3 4 1  previous elf's turn
//          2 [new] 4 5 1
// n = 5:   2   3   4 5 1
//
// f(n) = f(n-1) + 1 + [ f(n-1) + 1 "mod" n >= 1+(n/2) ]
 
// n = 5:  1 2   3 4 5
//         2 3   4 5 1
//         2 3 X 4 5 1
// n = 6   2 3 4 5 6 1

func survivor( n : Int ) -> Int {
    var f = 1
    for i in 2...n {
        var fPrime = f + 1
        if fPrime > i {
            fPrime -= i
        }
        let killed = 1 + (i/2)
        if fPrime >= killed {
            fPrime += 1
        }
        if fPrime > i {
            fPrime -= i
        }
        // print( "f(\(i)) = \(fPrime) killed=\(killed)" )
        f = fPrime
    }
    return f
}

// Of course, examining that output suggests a reset
// at powers of 3 instead.
// Hypothesis: f(3^m + l) = l for l < (3^m+l)/2

print( "Survivor part 2:", survivor( n:input ) )
