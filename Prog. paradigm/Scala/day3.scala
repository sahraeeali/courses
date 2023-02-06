// Run with: scala -cp tagsoup-1.2.1.jar day3.scala

// Exercise 1

import scala.io._
import scala.actors._
import Actor._
import scala.xml.{Elem, XML, Node}
import scala.xml.factory.XMLLoader
import org.ccil.cowan.tagsoup.jaxp.SAXFactoryImpl
import java.net.URL

println("Initial.")

object PageLoader {
    def loadPageAsXml(url: String): Option[Elem] = {
        val tagSoupXmlLoader = XML.withSAXParser(new SAXFactoryImpl().newSAXParser())
        try {
            return Some(tagSoupXmlLoader.load(new URL(url)))
        } catch {
            case e: Exception => {
                println("Tried to load: " + url)
                println(e.getMessage())
                return None
            }
        }
    }

    def getPageSize(url : String) = Source.fromURL(url).mkString.length

    def getNumberOfLinks(url : String) = {
        loadPageAsXml(url) match {
            case None => 0
            case Some(page) => (page \\ "a").length
        }
    }
}

val urls = List("http://amazon.com/",
    "http://www.twitter.com",
    "http://www.google.com",
    "http://www.cnn.com")

def timeMethod(method: () => Unit) = {
    val start = System.nanoTime
    method()
    val end = System.nanoTime
    println("Method took " + (end - start)/1000000000.0 + " seconds.")
}

def getSequentially(method: (String => Long)) = {
    for(url <- urls) {
        println("Value for " + url + ": " + method(url))
    }
}

def getConcurrently(method: (String => Long)) = {
    val caller = self

    for(url <- urls) {
        actor { caller ! (url, method(url)) }
    }

    for(i <- 1 to urls.size) {
        receive {
            case (url, size) => println("Value for " + url + ": " + size)
        }
    }
}

println("Concurrent run of size:")
timeMethod { () => getConcurrently(PageLoader.getPageSize) }

println("Sequential run of size:")
timeMethod { () => getSequentially(PageLoader.getPageSize) }

println("Sequential run of # of links:")
timeMethod { () => getSequentially(PageLoader.getNumberOfLinks) }

println("Concurrent run of # of links:")
timeMethod { () => getConcurrently(PageLoader.getNumberOfLinks) }
