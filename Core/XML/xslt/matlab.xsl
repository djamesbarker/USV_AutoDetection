<xsl:stylesheet version = '1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

	<xsl:output method="html"/> 

    <!--
        root template
    -->
    
	<xsl:template match="/">
	
		<HTML>
		<BODY>
        
		<xsl:for-each select="*">
			<xsl:apply-templates select="."/> 
		</xsl:for-each>
        		
		</BODY>
		</HTML>
		
	</xsl:template>

    <!--
        display matrix nodes
    -->
    
    <xsl:template match="MAT">
                
        <!--
            display depending on dimensions of matrix
        -->
        
        <xsl:choose>
        
            <!-- 
                display scalars
            -->
            
            <xsl:when test="@dims = '0'">
            
                <xsl:value-of select="."/>
                
            </xsl:when> 
            
            <!-- 
                display vectors 
            -->
            
            <xsl:when test="@dims = '1'">
            
                <DIV STYLE="margin: 1em; padding: 1em; background-color: rgb(255,255,200);">
                
                <TABLE BORDER="2">
                
                <xsl:for-each select="E">
                    <TR><xsl:value-of select="."/></TR>
                </xsl:for-each>
                
                </TABLE>
                
                </DIV>
            
            </xsl:when>
            
            <!-- 
                display matrices 
            -->
            
            <xsl:when test="@dims = '2'">
            
                <DIV STYLE="margin: 1em; padding: 1em; background-color: rgb(255,200,200);">
                 
                <TABLE BORDER="2">
                
                <xsl:for-each select="R">
                    <TR>
                    <xsl:for-each select="E">
                        <TD><xsl:value-of select="."/></TD>
                    </xsl:for-each>
                    </TR>
                </xsl:for-each>
                
                </TABLE>
                
                </DIV>
            
            </xsl:when>
            
        </xsl:choose>
            
    </xsl:template>
    
</xsl:stylesheet> 
