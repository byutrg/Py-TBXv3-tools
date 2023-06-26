<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:error="https://doi.org/10.5281/zenodo.1495494#error"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:schxslt-api="https://doi.org/10.5281/zenodo.1495494#api"
               xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:tbx="urn:iso:std:iso:30042:ed-2"
               version="2.0">
   <rdf:Description xmlns:dct="http://purl.org/dc/terms/"
                    xmlns:dc="http://purl.org/dc/elements/1.1/"
                    xmlns:skos="http://www.w3.org/2004/02/skos/core#">
      <dct:creator>
         <dct:Agent>
            <skos:prefLabel>SchXslt/1.8.5 SAXON/HE 9.9.1.5</skos:prefLabel>
            <schxslt.compile.typed-variables xmlns="https://doi.org/10.5281/zenodo.1495494#">true</schxslt.compile.typed-variables>
         </dct:Agent>
      </dct:creator>
      <dct:created>2023-06-14T12:42:26.061-06:00</dct:created>
   </rdf:Description>
   <xsl:output indent="yes"/>
   <xsl:template match="/">
      <xsl:variable name="metadata" as="element()?">
         <svrl:metadata xmlns:dct="http://purl.org/dc/terms/"
                        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                        xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
            <dct:creator>
               <dct:Agent>
                  <skos:prefLabel>
                     <xsl:variable name="prefix"
                                   as="xs:string?"
                                   select="if (doc-available('')) then in-scope-prefixes(document('')/*[1])[namespace-uri-for-prefix(., document('')/*[1]) eq 'http://www.w3.org/1999/XSL/Transform'][1] else ()"/>
                     <xsl:choose>
                        <xsl:when test="empty($prefix)">Unknown</xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of separator="/"
                                         select="(system-property(concat($prefix, ':product-name')), system-property(concat($prefix,':product-version')))"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </skos:prefLabel>
               </dct:Agent>
            </dct:creator>
            <dct:created>
               <xsl:value-of select="current-dateTime()"/>
            </dct:created>
            <dct:source>
               <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/">
                  <dct:creator>
                     <dct:Agent>
                        <skos:prefLabel>SchXslt/1.8.5 SAXON/HE 9.9.1.5</skos:prefLabel>
                        <schxslt.compile.typed-variables xmlns="https://doi.org/10.5281/zenodo.1495494#">true</schxslt.compile.typed-variables>
                     </dct:Agent>
                  </dct:creator>
                  <dct:created>2023-06-14T12:42:26.061-06:00</dct:created>
               </rdf:Description>
            </dct:source>
         </svrl:metadata>
      </xsl:variable>
      <xsl:variable name="report" as="element(schxslt:report)">
         <schxslt:report>
            <xsl:call-template name="d39e6"/>
         </schxslt:report>
      </xsl:variable>
      <xsl:variable name="schxslt:report" as="node()*">
         <xsl:sequence select="$metadata"/>
         <xsl:for-each select="$report/schxslt:document">
            <xsl:for-each select="schxslt:pattern">
               <xsl:sequence select="node()"/>
               <xsl:sequence select="../schxslt:rule[@pattern = current()/@id]/node()"/>
            </xsl:for-each>
         </xsl:for-each>
      </xsl:variable>
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
         <svrl:ns-prefix-in-attribute-values prefix="tbx" uri="urn:iso:std:iso:30042:ed-2"/>
         <xsl:sequence select="$schxslt:report"/>
      </svrl:schematron-output>
   </xsl:template>
   <xsl:template match="text() | @*" mode="#all" priority="-10"/>
   <xsl:template match="/" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="node()"/>
   </xsl:template>
   <xsl:template match="*" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:apply-templates mode="#current" select="node()"/>
   </xsl:template>
   <xsl:template name="d39e6">
      <schxslt:document>
         <schxslt:pattern id="d39e6">
            <xsl:if test="exists(base-uri(/))">
               <xsl:attribute name="documents" select="base-uri(/)"/>
            </xsl:if>
            <xsl:for-each select="/">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="coreEnforecement">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d39e27">
            <xsl:if test="exists(base-uri(/))">
               <xsl:attribute name="documents" select="base-uri(/)"/>
            </xsl:if>
            <xsl:for-each select="/">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" id="XLIFF.inlineConstraints">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <xsl:apply-templates mode="d39e6" select="/"/>
      </schxslt:document>
   </xsl:template>
   <xsl:template match="tbx:termNote" priority="7" mode="d39e6">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd39e6']">
            <schxslt:rule pattern="d39e6">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tbx:termNote" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:termNote</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d39e6">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:termNote</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(parent::tbx:termSec or parent::tbx:termNoteGrp/parent::tbx:termSec)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">parent::tbx:termSec or parent::tbx:termNoteGrp/parent::tbx:termSec</xsl:attribute>
                     <svrl:text>Any termNote is only allowed at the termSec level.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd39e6')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tbx:*[@type]" priority="6" mode="d39e6">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd39e6']">
            <schxslt:rule pattern="d39e6">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tbx:*[@type]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:*[@type]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d39e6">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:*[@type]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(@type != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@type != ''</xsl:attribute>
                     <svrl:text>Data category must be declared.  If no permitted data categories are listed in the grammar schema, blank values are also not allowed.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd39e6')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="*[@target]" priority="5" mode="d39e6">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd39e6']">
            <schxslt:rule pattern="d39e6">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "*[@target]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">*[@target]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d39e6">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">*[@target]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(matches(@target,'https?://.+') or @target = //*/@id)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">matches(@target,'https?://.+') or @target = //*/@id</xsl:attribute>
                     <svrl:text>ID must be IDREF for internal references or URI following HTTP protocol for external references.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd39e6')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tbx:sc[following-sibling::tbx:ec]" priority="4" mode="d39e6">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd39e27']">
            <schxslt:rule pattern="d39e27">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tbx:sc[following-sibling::tbx:ec]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:sc[following-sibling::tbx:ec]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d39e27">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:sc[following-sibling::tbx:ec]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(@isolated='no' or not(@isolated))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@isolated='no' or not(@isolated)</xsl:attribute>
                     <svrl:text>@isolated must be 'no' if &lt;sc/&gt; or &lt;ec/&gt; has its corresponding &lt;sc/&gt;/&lt;ec/&gt; in the same note text and @startRef must be used for &lt;ec&gt;</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd39e27')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tbx:ec[preceding-sibling::tbx:sc]" priority="3" mode="d39e6">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd39e27']">
            <schxslt:rule pattern="d39e27">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tbx:ec[preceding-sibling::tbx:sc]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:ec[preceding-sibling::tbx:sc]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d39e27">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:ec[preceding-sibling::tbx:sc]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(@isolated='no' or not(@isolated))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@isolated='no' or not(@isolated)</xsl:attribute>
                     <svrl:text>@isolated must be 'no' if &lt;sc/&gt; or &lt;ec/&gt; has its corresponding &lt;sc/&gt;/&lt;ec/&gt; in the same note text and @startRef must be used for &lt;ec&gt;</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(@startRef)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@startRef</xsl:attribute>
                     <svrl:text>@starRef is required for &lt;ec&gt; if it is in the same note text as its corresponding &lt;sc&gt;</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd39e27')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tbx:sc[not(following-sibling::tbx:ec)]"
                 priority="2"
                 mode="d39e6">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd39e27']">
            <schxslt:rule pattern="d39e27">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tbx:sc[not(following-sibling::tbx:ec)]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:sc[not(following-sibling::tbx:ec)]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d39e27">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:sc[not(following-sibling::tbx:ec)]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(@isolated='yes' or not(@isolated))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@isolated='yes' or not(@isolated)</xsl:attribute>
                     <svrl:text>@isolated must be 'yes' if &lt;sc/&gt; or &lt;ec/&gt; does not have its corresponding &lt;sc/&gt;/&lt;sc/&gt; in the same note text</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd39e27')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tbx:ec[not(preceding-sibling::tbx:sc)]"
                 priority="1"
                 mode="d39e6">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd39e27']">
            <schxslt:rule pattern="d39e27">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tbx:ec[not(preceding-sibling::tbx:sc)]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:ec[not(preceding-sibling::tbx:sc)]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d39e27">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:ec[not(preceding-sibling::tbx:sc)]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(@isolated='yes' or not(@isolated))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@isolated='yes' or not(@isolated)</xsl:attribute>
                     <svrl:text>@isolated must be 'yes' if &lt;sc/&gt; or &lt;ec/&gt; does not have its corresponding &lt;sc/&gt;/&lt;sc/&gt; in the same note text</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(@id)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@id</xsl:attribute>
                     <svrl:text>@id is REQUIRED when @isolated is or should be 'yes'.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd39e27')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tbx:ec[@isolated='yes']" priority="0" mode="d39e6">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd39e27']">
            <schxslt:rule pattern="d39e27">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tbx:ec[@isolated='yes']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:ec[@isolated='yes']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d39e27">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tbx:ec[@isolated='yes']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(@id != '')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@id != ''</xsl:attribute>
                     <svrl:text>ID is required if @isolated is 'yes'.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd39e27')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:function name="schxslt:location" as="xs:string">
      <xsl:param name="node" as="node()"/>
      <xsl:variable name="segments" as="xs:string*">
         <xsl:for-each select="($node/ancestor-or-self::node())">
            <xsl:variable name="position">
               <xsl:number level="single"/>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test=". instance of element()">
                  <xsl:value-of select="concat('Q{', namespace-uri(.), '}', local-name(.), '[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of attribute()">
                  <xsl:value-of select="concat('@Q{', namespace-uri(.), '}', local-name(.))"/>
               </xsl:when>
               <xsl:when test=". instance of processing-instruction()">
                  <xsl:value-of select="concat('processing-instruction(&#34;', name(.), '&#34;)[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of comment()">
                  <xsl:value-of select="concat('comment()[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of text()">
                  <xsl:value-of select="concat('text()[', $position, ']')"/>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="concat('/', string-join($segments, '/'))"/>
   </xsl:function>
</xsl:transform>
