# JSON to XML (XSLT 2.0)
XSLT 2.0 stylesheet to transform JSON as text to XML representation of JSON.

Loosely offering functionality available in XSLT 3.0 fn:json-to-xml() where this is not natively available in XSLT 2.0. Note this approach is XSLT stylesheet based rather than XSLT function. A stylesheet input file is not required. Configure and call initial template name "main". 
http://www.w3.org/TR/xpath-functions-31/#func-json-to-xml
    
In a round-robin way, the main stylesheet has no input, we pass a param to the path location for JSON file as input, we read that as unparsed-text, and then serialise that from JSON as text to a JSON AST as XML. It is then easy to complete regular XSLT activity to transform JSON AST XML to XML representation of JSON. 
    
The stylesheet output can be validated against the same schema as used for the XML representation of JSON used as the target for the function fn:json-to-xml(). 
    
There is a xsl:import dependency to a REx Parser generator library targeted for XSLT. Input to the generated library was an EBNF for JSON as on json.org. When using the generated library the output generated code is a parse-tree (AST).
http://www.bottlecaps.de/rex/
License - Fragments of REx source code, that are contained in generated parsers, are supplied under the Apache 2.0 license. See LICENSE.txt.
    
"In computer science, an abstract syntax tree (AST), or just syntax tree, is a tree representation of the abstract syntactic structure of source code written in a programming language. Each node of the tree denotes a construct occurring in the source code."
https://en.wikipedia.org/wiki/Abstract_syntax_tree
  
Use $debug-ast stylesheet parameter to observe intermediate AST XML format.
