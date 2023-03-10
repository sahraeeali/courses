// Run this file with 'scala -Dfile.encoding=UTF-8 day1.scala'

//Java version 11.0.17
//scala version 2.13.0

//Exercise 1
sealed abstract class Player
case object X extends Player
case object O extends Player
case object Blank extends Player {
    override def toString = " "
}

object GameResult extends Enumeration {
    type GameResult = Value
    val X, O, Tie, NoResult = Value

    def displayGameResult(gameResult: GameResult) : String = {
        val winnerText = "Player %s won!"

        gameResult match {
            case GameResult.NoResult => "No winner yet!"
            case GameResult.Tie => "It's a tie!"
            case player => winnerText.format(player)
        }
    }
}

class TicTacToeBoard(board : Array[Array[Player]]) {

    def this(stringBoard: Array[String]) = this(stringBoard.map(row => TicTacToeBoard.getPlayersFromString(row)))
    def this(rows: Int, cols: Int) = this(Array.fill(rows, cols)(Blank) : Array[Array[Player]])
    def this(size: Int) = this(size, size)

    val rowCount = board.length
    val columnCount = if (board.isEmpty) 0 else board(0).length
    val columnNameMapping = (0 until 5*columnCount).map(n => (TicTacToeBoard.numToAlpha(n), n)).toMap

    val numInARowNeeded : Int = {
        // numbers chosen rather arbitrarily by me. I looked at this: http://en.wikipedia.org/wiki/M,n,k-game
        // and tried to pick numbers that more or less made sense
        if(rowCount <= 3|| columnCount <= 3)
        {
            // tic tac toe or bizarre tiny variants
            scala.math.min(rowCount, columnCount)
        } else if(rowCount <= 5) {
            // connect 4, sort of
            4
        } else if(rowCount <= 14) {
            // gomoku
            5
        } else {
            // connect6. Seems like a good place to leave it
            6
        }
    }

    def rows: Seq[Array[Player]] = {
        for(r <- 0 until rowCount)
            yield board(r)
    }

    def columns: Seq[Array[Player]] = {
        for(c <- 0 until columnCount) yield (
            for(r <- (0 until rowCount))
                yield board(r)(c)).toArray
    }

    def diagonalsLTR: Seq[Array[Player]] = {
        for(offset <- (1-columnCount) until columnCount) yield (
            for(row <- 0 until rowCount if offset + row < columnCount && offset + row > -1)
                yield(board(row)(row+offset))).toArray
    }

    def diagonalsRTL: Seq[Array[Player]]  = {
        for(offset <- 0 until rowCount + rowCount - 1) yield (
            for(col <- 0 until columnCount if offset - col < rowCount && offset - col > -1)
                yield(board(offset - col)(col))).toArray
    }

    def determineWinner : GameResult.Value = {
        val winnerText = "Player %s won!"
        val checkForWinner = { array : Array[Player] =>
            TicTacToeBoard.nInARow(numInARowNeeded, array) match {
                case Some(player) => return player match { // non-local return!
                    case X => GameResult.X
                    case O => GameResult.O
                    case other => throw new Exception("Error, '" + other + "' is not a player.")
                }
                case None => // do nothing
            }
        }

        rows foreach checkForWinner
        columns foreach checkForWinner
        diagonalsLTR foreach checkForWinner
        diagonalsRTL foreach checkForWinner

        if(board.map(row => row.contains(Blank)).contains(true)) {
            return GameResult.NoResult
        }

        return GameResult.Tie
    }

    override def toString : String = {
        var boardRepresentation = ""

        def p = { str : String => boardRepresentation = boardRepresentation.concat(str + "\n") }

        val topLine = (1 until columnCount).foldLeft("   ???")((acc, c) => acc.concat("????????????")).concat("????????????")
        val middleLine = (0 until columnCount).foldLeft("   ???")((acc, c) => acc.concat("????????????"))
        val bottomLine = (1 until columnCount).foldLeft("   ???")((acc, c) => acc.concat("????????????")).concat("????????????")

        p("")
        p((0 until columnCount).foldLeft("     ")((acc, n) => acc.concat("%-4s".format(TicTacToeBoard.numToAlpha(n)))))
        p(topLine)
        for(r <- 0 until rowCount) {
            var rowString = "%-3d".format(r).concat("???")
            for(c <- 0 until columnCount) {
                rowString = rowString.concat(" %s ???".format(board(r)(c)))
            }
            p(rowString)
            if(r < rowCount-1) {
                p(middleLine)
            }
        }
        p(bottomLine)
        p("")

        return boardRepresentation
    }

    def validMove(row : Int, col : Int) : Boolean = {
        return row < rowCount && row >= 0 && col < columnCount && col >= 0 && board(row)(col) == Blank
    }

    def update(row : Int, col : Int, player : Player) = {
        board(row)(col) = player
    }

    def columnNumber(columnName : String) : Int = {
        return columnNameMapping(columnName)
    }
}

object TicTacToeBoard {

    def numToAlpha(number : Int) : String = {
        var dividend = number + 1 // internally, treat 1 as A - just makes it easier
        var letters = ""
        var modulo = 0

        while(dividend > 0) {
            modulo = (dividend - 1) % 26
            letters = (65 + modulo).toChar + letters
            dividend = (dividend - modulo) / 26
        }

        return letters
    }

    def getPlayersFromString(row : String) : Array[Player] = {
        row.map(char => { if(char == 'X') X : Player else if(char == 'O') O : Player else Blank : Player } ).toArray
    }

    def threeInARow(list : List[Player]) : Option[Player] = list match {
        case Nil => None
        case x :: y :: z :: tail if x == y && y == z && z != Blank => Some(z)
        case _ :: tail => threeInARow(tail)
    }

    def nInARow(n : Int, array : Array[Player]) : Option[Player] = {
        for(i <- 0 until array.length - (n-1)) {
            var allTrue = true;
            for(j <- i+1 until i+n) {
                allTrue &= array(j-1) == array(j)
            }
            if(allTrue && array(i) != Blank) {
                return Some(array(i))
            }
        }

        return None
    }

}

// Testing win detection

assert(new TicTacToeBoard(Array(
    "XOX",
    "XOO",
    "XXO"
)).determineWinner == GameResult.X)

assert(new TicTacToeBoard(Array(
    "XOX",
    "OOO",
    "XXO"
)).determineWinner == GameResult.O)

assert(new TicTacToeBoard(Array(
    "XOX",
    "XOO",
    " XO"
)).determineWinner == GameResult.NoResult)

assert(new TicTacToeBoard(Array(
    "XOX",
    "XOO",
    "OXO"
)).determineWinner == GameResult.Tie)

assert(new TicTacToeBoard(Array(
    "XXO",
    "XOO",
    "OXX"
)).determineWinner == GameResult.O)

assert(new TicTacToeBoard(Array(
    "XXO",
    "XXO",
    "OOX"
)).determineWinner == GameResult.X)

assert(new TicTacToeBoard(Array(
    "OXOXO",
    "XXOXO",
    "OXXOX",
    "OOXXO",
    "OOXXO"
)).determineWinner == GameResult.X)

assert(new TicTacToeBoard(Array(
    "OXOXO",
    "XXOXO",
    "OXXOX",
    "OOOXO",
    "OOXXO"
)).determineWinner == GameResult.O)

// 2. Bonus Problem: Let two players play tic-tac-toe.

object Game {
    val Position = """([A-Za-z]+)\s*(\d+)""".r

    def main(args:Array[String]) {
        val size = readBoardSize
        var board = new TicTacToeBoard(size)
        println("\n" + board.numInARowNeeded + " in a row to win (" + size + "x" + size + " board)")

        var player : Player = X
        while(board.determineWinner == GameResult.NoResult) {
            println(board)
            println("Player %s's turn.".format(player))

            val (row, col) = readNextMove(board)
            board.update(row, col, player)

            player = if(player == X) O else X
        }

        println(board)
        println(GameResult.displayGameResult(board.determineWinner))
        println
    }

    def readBoardSize: Int = {
        var size = -1

        while(size < 1) {
            try {
                print("Enter board size: ")
                size = scala.io.StdIn.readInt()
            } catch {
                case e => { size = -1 }
            }
            if (size < 1) {
                println("Invalid board size. Please enter a number greater than 0.")
            }
        }

        return size
    }

    def readNextMove(board: TicTacToeBoard): (Int, Int) = {
        var validMove = false
        var col = -1
        var row = -1
        while(!validMove) {
            var input = ""
            try {
                print("Enter square: (e.g. A0): ")
                input = scala.io.StdIn.readLine()
                val Position(columnName, rowNumber) = input
                row = rowNumber.toInt
                col = board.columnNumber(columnName.toUpperCase)
            } catch {
                case e => { println("Error reading input: Could not understand \"" + input + "\"") }
            }

            validMove = board.validMove(row, col)
            if(!validMove) {
                println("Can't move there, try again!\n")
            }
        }

        return (row, col)
    }

}

Game.main(null)
