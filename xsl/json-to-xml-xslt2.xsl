<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.w3.org/2005/xpath-functions" xmlns:local="local"
  xmlns:p="JSON" exclude-result-prefixes="#all">

  <xsl:import href="json-ebnf-parser-to-ast.xsl"/>

  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="path">../source/example.json</xsl:param>

  <xsl:param name="debug-ast">false</xsl:param>

  <xsl:variable name="json-as-text" as="xs:string" select="unparsed-text($path)"/>

  <xsl:variable name="json-as-ast" as="element(json)"
    select="p:parse-json($json-as-text)"/>

  <xsl:template name="main">
    <xsl:choose>
      <xsl:when test="$debug-ast = 'true'">
        <xsl:copy-of select="$json-as-ast"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$json-as-ast"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="json">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="json/value/object">
    <map
      xsi:schemaLocation="http://www.w3.org/2005/xpath-functions ../xsd/schema-for-json.xsd">
      <xsl:apply-templates/>
    </map>
  </xsl:template>

  <xsl:template match="pair[value/object]">
    <map>
      <xsl:attribute name="key">
        <xsl:apply-templates select="element()[1]"/>
      </xsl:attribute>
      <xsl:apply-templates select="value">
        <xsl:with-param name="is-pair" select="true()" tunnel="yes"/>
      </xsl:apply-templates>
    </map>
  </xsl:template>

  <xsl:template match="object">
    <xsl:param name="is-pair" select="false()" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="$is-pair">
        <xsl:apply-templates>
          <xsl:with-param name="is-pair" select="false()" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <map>
          <xsl:apply-templates/>
        </map>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="pair[value/array]">
    <array>
      <xsl:attribute name="key">
        <xsl:apply-templates select="element()[1]"/>
      </xsl:attribute>
      <xsl:apply-templates select="value">
        <xsl:with-param name="is-pair" select="true()" tunnel="yes"/>
      </xsl:apply-templates>
    </array>
  </xsl:template>

  <xsl:template match="array">
    <xsl:param name="is-pair" select="false()" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="$is-pair">
        <xsl:apply-templates>
          <xsl:with-param name="is-pair" select="false()" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <array>
          <xsl:apply-templates/>
        </array>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="pair[value/string]">
    <string>
      <xsl:attribute name="key">
        <xsl:apply-templates select="element()[1]"/>
      </xsl:attribute>
      <xsl:apply-templates select="value"/>
    </string>
  </xsl:template>

  <xsl:template match="pair[value/number]">
    <number>
      <xsl:attribute name="key">
        <xsl:apply-templates select="element()[1]"/>
      </xsl:attribute>
      <xsl:apply-templates select="value"/>
    </number>
  </xsl:template>

  <xsl:template match="pair[value/TOKEN = ('true','false')]">
    <boolean>
      <xsl:attribute name="key">
        <xsl:apply-templates select="element()[1]"/>
      </xsl:attribute>
      <xsl:apply-templates select="value"/>
    </boolean>
  </xsl:template>

  <xsl:template match="pair[value/TOKEN = 'null']">
    <null>
      <xsl:attribute name="key">
        <xsl:apply-templates select="element()[1]"/>
      </xsl:attribute>
    </null>
  </xsl:template>

  <xsl:template match="value">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="string">
    <xsl:value-of select="local:extract-text-from-quoted-string(.)"/>
  </xsl:template>

  <xsl:template match="number">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="TOKEN[. =('true','false')]">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="TOKEN | eof | text()">
    <!-- do nothing -->
  </xsl:template>

  <xsl:function name="local:extract-text-from-quoted-string" as="xs:string">
    <xsl:param name="arg" as="xs:string"/>
    <xsl:variable name="matches">"([^"]*)"</xsl:variable>
    <xsl:value-of select="replace($arg, $matches, '$1')"/>
  </xsl:function>

</xsl:stylesheet>
