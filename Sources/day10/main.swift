import AocMain

class Bot : CustomStringConvertible {
    var values : [Int] = []
    var gives : BotCommand? = nil
    var fired : Bool = false
    
    init( initValue:Int ) {
        self.values = [ initValue ]
    }

    init( command:BotCommand ) {
        self.gives = command 
    }

    var description : String {
        return "[Bot \(fired) values \(values) command \(gives)]"
    }
}

var allBots : [Int:Bot] = [:]
var allOutputs : [Int:Int] = [:]

func activate( bot : Int ) -> [Int] {
    print( "Activating bot \(bot)" )
    var chainReaction : [Int] = []

    func deliver( _ type : BotType, _ bot : Int, _ val : Int ) {
        switch type {
        case .bot:
            print( "Delivering \(val) to bot \(bot)" )
            if let dest = allBots[bot] {
                dest.values.append( val )
                if dest.values.count == 2 {
                    chainReaction.append( bot )
                }
            }
        case .output:
            print( "Delivering \(val) to output \(bot)" )
            allOutputs[bot] = val            
        }        
    }
    if let b = allBots[bot] {
        precondition( b.values.count == 2 )

        b.fired = true
        if let bc = b.gives {
            switch bc {
            case let .gives( _, lowType, lowNum, highType, highNum ):
                if let low = b.values.min() {
                    deliver( lowType, lowNum, low )
                }
                if let high = b.values.max() {
                    deliver( highType, highNum, high )
                }
            case .input:
                preconditionFailure( "Bot has input rule." )
            }
        }
    }
    return chainReaction
}

func activateChain( bots : [Int] ) {
    var botQ = bots
    while botQ.count > 0 {
        let nextBot = botQ.removeFirst()
        let chain = activate( bot:nextBot )
        botQ.append( contentsOf: chain )
    }
}

func problem( input:String ) {
    let commands = input.lines.map( BotCommand.Parse )
    var ready : [Int] = []
    for co in commands {
        if let c = co {
            switch c {
            case let .input( value, bot ):
                if let b = allBots[bot] {
                    b.values.append( value )
                    if b.values.count == 2 {
                        ready.append( bot )
                    }
                } else {
                    allBots[bot] = Bot( initValue: value )                
                }
            case let .gives( bot, _, _, _, _ ):
                if let b = allBots[bot] {
                    b.gives = c
                } else {
                    allBots[bot] = Bot( command:c )
                }
            }
        }
    }
    activateChain( bots:ready )
    for ( bn, b ) in allBots {
        print( "\(bn): \(b)" )
        if b.values == [17, 61] || b.values == [61, 17] {
            print( "<== THIS ONE, bot \(bn) ==]" )
        }
    }
    print( "Output 0: \(allOutputs[0])" )
    print( "Output 1: \(allOutputs[1])" )
    print( "Output 2: \(allOutputs[2])" )
}

main( problem )
