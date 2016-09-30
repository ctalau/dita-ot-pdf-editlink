<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="*" mode="processTopicTitle">
        <xsl:variable name="level" as="xs:integer">
          <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>
        <xsl:variable name="attrSet1">
            <xsl:apply-templates select="." mode="createTopicAttrsName">
                <xsl:with-param name="theCounter" select="$level"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="attrSet2" select="concat($attrSet1, '__content')"/>
        <fo:block>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="$attrSet1"/>
                <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
            </xsl:call-template>
            <fo:block>
                <xsl:call-template name="processAttrSetReflection">
                    <xsl:with-param name="attrSet" select="$attrSet2"/>
                    <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                </xsl:call-template>
                
                <!-- Compute the URL params for the edit url -->
                <xsl:variable name="file.path">
                  <xsl:value-of select="substring(@xtrf, 7 + string-length(system-property('cwd')))"/>
                </xsl:variable>
                <xsl:variable name="file.url.encoded">
                  <xsl:value-of select="encode-for-uri(concat(system-property('repo.url'), $file.path))"/>
                </xsl:variable>
                <xsl:variable name="ditamap.url.encoded">
                  <xsl:value-of select="encode-for-uri(concat(system-property('repo.url'), system-property('ditamap.path')))"/>
                </xsl:variable>

                <fo:table>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block>
                                    <!-- This content was already here before. I just wrapped it in a table. -->
                                    <xsl:if test="$level = 1">
                                        <fo:marker marker-class-name="current-header">
                                            <xsl:apply-templates select="." mode="getTitle"/>
                                        </fo:marker>
                                    </xsl:if>
                                    <xsl:if test="$level = 2">
                                        <fo:marker marker-class-name="current-h2">
                                            <xsl:apply-templates select="." mode="getTitle"/>
                                        </fo:marker>
                                    </xsl:if>
                                    <fo:inline id="{parent::node()/@id}"/>
                                    <fo:inline>
                                        <xsl:attribute name="id">
                                            <xsl:call-template name="generate-toc-id">
                                                <xsl:with-param name="element" select=".."/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </fo:inline>
                                    <xsl:call-template name="pullPrologIndexTerms"/>
                                    <xsl:apply-templates select="." mode="getTitle"/>
                                    <!-- End of existing content -->
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell width="80pt">
                                <fo:block width="80pt">
                                    <fo:basic-link
                                        text-align="right"
                                        white-space="nowrap"
                                        text-decoration="underline" 
                                        color="navy"
                                        font-size="8pt"
                                        font-weight="normal"
                                        width="80pt"
                                        font-style="normal">
                                        <xsl:attribute name="external-destination"><xsl:value-of select="system-property('webapp.url')"/>app/oxygen.html?url=<xsl:value-of select="$file.url.encoded"/><xsl:text disable-output-escaping="yes">&amp;</xsl:text>ditamap=<xsl:value-of select="$ditamap.url.encoded"/></xsl:attribute>
                                        Edit on GitHub
                                    </fo:basic-link>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </fo:block>
    </xsl:template>
</xsl:stylesheet>
