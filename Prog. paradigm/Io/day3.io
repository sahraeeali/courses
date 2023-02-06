#1. Enhance the XML program to add spaces to show the indentation structure
"First Exercise" println
Builder := Object clone

Builder ilevel := 0

Builder forward = method(
    writeln(indentmethod() .. "<", call message name, ">")
    ilevel = ilevel + 1
    call message arguments foreach(
        arg,
        content := self doMessage(arg);
        if(content type == "Sequence", writeln(indentmethod() .. content))
    )
    ilevel = ilevel - 1
    writeln(indentmethod() .. "</", call message name, ">")
)

Builder indentmethod := method(
  spaces := ""
  ilevel repeat(spaces = spaces .. "\t")
  return spaces
)

Builder ul(li("Io"),li("Lua"),li("Javascript"),li("Lisp"));

#2. Create a list syntax that uses brackets.
"Second Exercise" println
curlyBrackets := method(
    call message arguments
)

{ "first", "second", "third" } println

#3. Enhance the XML program to handle attributes: if the first argument is a map (use the curly brackets syntax), add attributes to the XML program. For example: book({"author": "Tate"}...) would print <book author="Tate">
"Third Exercise" println
Builder2 := Object clone

Builder2 ilevel := 0

OperatorTable addAssignOperator(":", "atPutNumber")

Map atPutNumber := method(
    self atPut(
        call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
        call evalArgAt(1)
    )
)

curlyBrackets := method(
    r := Map clone
    call message arguments foreach(arg,
        r doMessage(arg)
    )
    r
)

Map printAsAttributes := method(
    self foreach(k, v,
        write(" " .. k .. "=\"" .. v .. "\"")
    )
)

Builder2 forward = method(
    write(indentmethod() .. "<", call message name)
    ilevel = ilevel + 1
    isFirst := true
    call message arguments foreach(
        arg,
        if(isFirst,
            if(arg name == "curlyBrackets",
                (self doMessage(arg)) printAsAttributes
            )

            write(">\n")
            isFirst = false
        )

        content := self doMessage(arg)
        if(content type == "Sequence", writeln(indentmethod() .. content))
    )
    ilevel = ilevel - 1
    writeln(indentmethod() .. "</", call message name, ">")
)

Builder2 indentmethod := method(
  spaces := ""
  ilevel repeat(spaces = spaces .. "\t")
  return spaces
)

s := File with("text.txt") openForReading contents
doString(s)
