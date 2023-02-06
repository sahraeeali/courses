// Run this file with 'scala -Dfile.encoding=UTF-8 day2.scala'

//Java version 11.0.17
//scala version 2.13.0

//Exercise 1
println("\nFirst Exercise.")

var stringList = List("one", "two", "three", "four", "five", "six")
var totalStringSize = stringList.foldLeft(0)((total, string) => total + string.length)
println(totalStringSize)


//Exercise 2
import scala.collection.mutable.HashMap

println("\nSecond Exercise.")

trait Censor {

    var curseWords = Map(
        "(?i)Shoot" -> "Pucky",
        "(?i)Darn" -> "Beans"
    )

    def setCurseWords(newCurseWords : Map[String, String]) = {
        curseWords = newCurseWords
    }

    def censorThyselfVillain (suspectPhrase : String) : String = {
       var wholesomePhrase = suspectPhrase

       for ((key, value) <- curseWords) {
            wholesomePhrase = wholesomePhrase.replaceAll(key, value)
       }

       return wholesomePhrase
    }

    def censorThyselfVillain2 (suspectPhrase : String) : String = {
        curseWords.foldLeft(suspectPhrase)((acc, pair) => acc.replaceAll(pair._1, pair._2))
    }
}

class PolitenessEnforcer extends Censor

var modified = new PolitenessEnforcer()

val rudePhrase = "Shoot, my darn hand is stuck in the dumb freaking pocket."

println("Spoken frankly: ")
println(rudePhrase)

println("The modified text: ")
println(modified.censorThyselfVillain2(rudePhrase))

//Exercise 3
import scala.io.Source._

println("\nThird Exercise.")

var cursesFromFile = Map.empty[String, String]

fromFile("curseWords.txt").getLines.foreach { line =>
    val curseWordPair = line.split('|')
    if(curseWordPair.length == 2) {
        cursesFromFile += ("(?i)" + curseWordPair(0).trim) -> curseWordPair(1).trim
    }
}

val modified2 = new PolitenessEnforcer()
modified2.setCurseWords(cursesFromFile)

println("The modified text while picking curse words from a file: ")
println(modified2.censorThyselfVillain2(rudePhrase))
