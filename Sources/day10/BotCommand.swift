import Foundation

enum BotType : String {
    case bot
    case output
}

enum BotCommand {
    case input( value:Int, bot:Int )
    case gives( bot:Int,
                lowType:BotType, lowNum:Int,
                highType:BotType, highNum:Int )    

    static func Parse( input : String ) -> BotCommand? {
        let tokens = input.components( separatedBy: " " )
        if tokens.count < 1 {
            return nil
        } else if tokens[0] == "value" {
            return .input( value:Int( tokens[1] )!,
                           bot:Int( tokens[5] )! )            
        } else if tokens[0] == "bot" {
            return .gives( bot:Int( tokens[1] )!,
                           lowType:BotType( rawValue:tokens[5] )!,
                           lowNum:Int( tokens[6] )!,
                           highType:BotType( rawValue:tokens[10] )!,
                           highNum:Int( tokens[11] )! )
        } else {
            return nil
        }
    }
}
