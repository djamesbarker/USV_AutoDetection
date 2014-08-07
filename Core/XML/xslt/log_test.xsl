<xsl:stylesheet version = '1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>


	<xsl:output method="html"/> 


    <!--
        root template
    -->
    
	<xsl:template match="/">
	
		<HTML>
        
        <STYLE TYPE="text/css">
        
            <!-- generic layout rules -->
            
            BODY {
                font-family: 'Comic Sans MS';
                line-height: 175%
            }
            
            DIV {
                margin: 0.5em 1em;
            }
            
            H1 {
                font-variant: small-caps;
                letter-spacing: 0.25em;
                text-decoration: underline;
            }
            
            H2 {
                display: inline;
                font-variant: small-caps;
                letter-spacing: 0.1em;
            }
            
            H3 {
                display: inline;
                letter-spacing: 0.1em;
            }
 
            <!-- this helps produce figures with captions -->
            
            DIV.figure {
                float: right;
                width: 256px;
                height: 192px;
                border: 1px dotted rgb(128,128,128);
                margin: 1em;
                padding: 1em;
            }
            
            DIV.figure P {
                font-size: 75%;
                font-style: italic;
                text-align: center;
                text-indent: 0;
            }
            
            IMG.scaled {
                width: 100%;
            }
            
            <!-- these rules are content related -->
            
            DIV.de-emph {
                color: rgb(128,128,128);
                font-size: 75%;
                margin: 0em;
                padding: 0em;
            }
            
            DIV.de-emph H3 {
                font-size: 100%;
            }
            
            DIV.container {
                border: 1px solid rgb(128,128,128);
                border-left: 1px solid rgb(128,128,128);
                background-color: rgb(240,240,220);
                width: 99%;
                max-width: 800px;
                margin: 0.5em 1em 2em;
                padding: 2em 1em;
            }
            
            DIV.event {
                border: 1px dotted rgb(128,128,128);
                background-color: rgb(255,255,200);
                width: 99%;
                max-width: 800px;
                margin: 0.5em 1em 2em;
                padding: 2em 1em;
            }
            
            DIV.event-head {
                border: 1px dotted rgb(128,128,128);
                padding: 8px;
                margin: 1em;
                background-color: rgb(240,200,200); 
            }
            
            DIV.annotation {
                clear: both;
                border: 1px dotted rgb(100,200,100);
                background-color: rgb(200,255,200);
                margin: 1em 1em 1em 1em; 
                padding: 1em 1em 1em 1em;
            }
            
            DIV.annotation-data {
                background-color: rgb(220,255,220); 
                padding: 8px;
            }
            
            DIV.measurement {
                border: 1px dotted rgb(100,100,200);
                background-color: rgb(200,200,255); 
                margin: 1em 1em 1em 1em; 
                padding: 1em 1em 1em 1em;
            }
            
            DIV.measurement-data {
                background-color: rgb(220,220,255);
                padding: 0.5em;
            }
            
        </STYLE>
        
		<BODY>
        
        <xsl:apply-templates select="LOG"/>
        
        <xsl:apply-templates select="LOG/SOUND"/>
        
        <DIV CLASS="container">
        
            <DIV>
                <H1>Events:</H1>
            </DIV>
        
            <xsl:for-each select="LOG/EVENT">
        
                <xsl:sort select="CREATED"/>
                <xsl:sort select="CHANNEL"/>
            
                <xsl:apply-templates select="."/> 
            
            </xsl:for-each>
    
        </DIV>
        
		</BODY>
		</HTML>
		
	</xsl:template>


    <!--
        log template
    -->
    
	<xsl:template match="LOG">
    
        <DIV CLASS="container">
        
		<DIV>
			<H1>Log: <xsl:value-of select="FILE/CHAR"/></H1>
		</DIV>
        
        <DIV>
            <H3>Path: </H3><xsl:value-of select="PATH/CHAR"/>
        </DIV>
        
        </DIV>
        
	</xsl:template>


    <!--
        sound template
    -->
    
	<xsl:template match="SOUND">
            
        <DIV CLASS="container">
        
        <DIV>
			<H1>Sound:</H1>
		</DIV>
        
		<DIV>
			<H3>Path: </H3>
            <xsl:value-of select="PATH/CHAR"/>
		</DIV>
        
        <!-- we can check the type of the sound and conditionally process the file information -->
        
        <DIV>
			<H3>File: </H3>
            <xsl:value-of select="FILE/CELL"/>
		</DIV>
        
        <DIV>
			<H3>Channels: </H3>
            <xsl:apply-templates select="CHANNELS/MAT"/>
		</DIV>
        
        <DIV>
			<H3>Samplerate: </H3>
            <xsl:apply-templates select="SAMPLERATE/MAT"/>
		</DIV>
        
        </DIV>
                
	</xsl:template>


    <!--
        event template
    -->
    
	<xsl:template match="EVENT">

    <!-- note the workaround in the width of the DIV -->
    
    <DIV CLASS="event">
        
		<DIV CLASS="event-head">
			<H2>Event: #<xsl:apply-templates select="ID/MAT"/></H2>
		</DIV>
        
        <DIV CLASS="figure">
        
            <P>
                <IMG>
<xsl:attribute name="SRC">Images/<xsl:value-of select="substring-before(/LOG/FILE,'.')"/>_<xsl:value-of select="ID/MAT"/>.jpg</xsl:attribute>
<xsl:attribute name="ALT">This is a test</xsl:attribute>
<xsl:attribute name="WIDTH">50</xsl:attribute>
<xsl:attribute name="HEIGHT">192</xsl:attribute>
                </IMG>
            </P>
            
            <!-- this solution to cross-browser quicktime is from the apple site -->
             
            <!--
            
            WIDTH="192" HEIGHT="192" ALT="clip"/>
             
            Images/<xsl:value-of select="LOG/FILE"/><xsl:value-of select="concat(./ID/MAT,'.jpg')"/>
            
            <OBJECT 
                CLASSID="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B"
                WIDTH="256"
                HEIGHT="16"
                CODEBASE="http://www.apple.com/qtactivex/qtplugin.cab">
                <PARAM name="SRC" VALUE="clip.aif"/>
                <PARAM name="AUTOPLAY" VALUE="false"/>
                <PARAM name="CONTROLLER" VALUE="true"/>
                <EMBED
                    SRC="clip.aif" 
                    WIDTH="256"
                    HEIGHT="16" 
                    CONTROLLER="true" 
                    PLUGINSPAGE="http://www.apple.com/quicktime/download/">
                </EMBED>
            </OBJECT>
            -->
            
            <P>No clip file is available !</P>
            
        </DIV>
        
        <DIV>
			<H3>Channel: </H3><xsl:apply-templates select="CHANNEL/MAT"/>
		</DIV>
        
        <DIV>
			<H3>Time: </H3><xsl:apply-templates select="TIME/MAT"/>
		</DIV>
	  
		<DIV>
			<H3>Frequency: </H3><xsl:apply-templates select="FREQ/MAT"/>
		</DIV>
        
        <!-- a template for the creation information probably makes sense -->
        
        <DIV CLASS="de-emph">
        
        <DIV>
			<H3>Author: </H3><xsl:value-of select="AUTHOR"/>
		</DIV>
		
        <DIV>
			<H3>Created: </H3><xsl:value-of select="CREATED"/>
		</DIV>
		
        <DIV>
			<H3>Modified: </H3><xsl:value-of select="MODIFIED"/>
		</DIV>
        
        </DIV>
        
        <xsl:apply-templates select="ANNOTATION"/>
        
		<xsl:apply-templates select="MEASUREMENT"/> 
        
    </DIV>
		
	</xsl:template>
  
  
    <!--
        annotation template
    -->
    
	<xsl:template match="ANNOTATION">
  
    <DIV CLASS="annotation">
    
        <DIV STYLE="
            border: 1px dotted rgb(128,128,128);
            padding: 8px;
            margin:0.5em;
        ">
			<H2>Annotation: <xsl:value-of select="NAME"/></H2>
		</DIV>

		<DIV>
            <H3 STYLE="text-decoration: underline;">Values:</H3>
            <DIV CLASS="annotation-data">
                <xsl:apply-templates select="VALUE/*/CHAR"/>
            </DIV>
		</DIV>
		
        <DIV CLASS="de-emph">
        
		<DIV>
			<H3>Author: </H3><xsl:value-of select="AUTHOR"/>
		</DIV>
		
		<DIV>
			<H3>Created: </H3><xsl:value-of select="CREATED"/>
		</DIV>
		
        <DIV>
			<H3>Modified: </H3><xsl:value-of select="MODIFIED"/>
		</DIV>
        
        </DIV>
	 
    </DIV>
    
    </xsl:template>
	
    
    <!--
        measurement template
    -->
    
    <xsl:template match="MEASUREMENT">
  
    <DIV CLASS="measurement">
    
        <DIV STYLE="
            border: 1px dotted rgb(128,128,128);
            padding: 8px;
            margin:0.5em;
        ">
			<H2>Measurement: <xsl:value-of select="NAME/CHAR"/></H2>
		</DIV>

		<DIV>
			<H3 STYLE="text-decoration: underline;">Values:</H3>
            <DIV CLASS="measurement-data">
                <xsl:apply-templates select="VALUE/*/MAT"/>
            </DIV>
		</DIV>
        
        <DIV>
			<H3 STYLE="text-decoration: underline;">Parameters:</H3>
            <DIV CLASS="measurement-data">
                <xsl:apply-templates select="PARAMETER/*/MAT"/>
            </DIV>
		</DIV>
		
        <DIV CLASS="de-emph">
        
		<DIV>
			<H3>Author: </H3><xsl:value-of select="AUTHOR"/>
		</DIV>
		
		<DIV>
			<H3>Created: </H3><xsl:value-of select="CREATED"/>
		</DIV>
		
        <DIV>
			<H3>Modified: </H3><xsl:value-of select="MODIFIED"/>
		</DIV>
        
        </DIV>
        
    </DIV>
        	 
    </xsl:template>
    
    
    <!--
        matrix template
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

                <SPAN>
                   <xsl:value-of select="."/>
                </SPAN>
 
            </xsl:when> 
            
            <!-- 
                display vectors 
            -->
            
            <xsl:when test="@dims = '1'">
                            
                <TABLE STYLE="
                    border: 1px dotted black;
                    margin: 8px;
                    vertical-align: middle; 
                    display: inline;
                ">
                
                <xsl:for-each select="E">
                    <TR STYLE="border: 1px dotted black;"><TD><xsl:value-of select="."/></TD></TR>
                </xsl:for-each>
                
                </TABLE>
                            
            </xsl:when>
            
            <!-- 
                display matrices 
            -->
            
            <xsl:when test="@dims = '2'">
                             
                <TABLE BORDER="2">
                
                <xsl:for-each select="R">
                    <TR>
                    <xsl:for-each select="E">
                        <TD><xsl:value-of select="."/></TD>
                    </xsl:for-each>
                    </TR>
                </xsl:for-each>
                
                </TABLE>
                            
            </xsl:when>
            
        </xsl:choose>
            
    </xsl:template>
    
    
    <!--
        character values and parameters template
    -->
    
    <xsl:template match="VALUE/*/CHAR|PARAMETER/*/CHAR">
                    
        <TABLE STYLE="
            border-bottom: 1px dotted rgb(128,128,128);
            margin: 8px;
            vertical-align: bottom; 
        ">
                
        <H3>
            <TR>
                <TD><xsl:value-of select="local-name(..)"/>: </TD>
                <TD STYLE="font-family: monospace;"><xsl:value-of select="."/></TD>
            </TR>
        </H3>
                
        </TABLE>
        
    </xsl:template>


    <!--
        matrix values and parameters template
    -->
    
    <xsl:template match="VALUE/*/MAT|PARAMETER/*/MAT">
                
        <!--
            display depending on dimensions of matrix
        -->
        
        <xsl:choose>
        
            <!-- 
                display scalars
            -->
            
            <xsl:when test="@dims = '0'">
            
                <TABLE STYLE="
                    border-bottom: 1px dotted rgb(128,128,128);
                    margin: 8px;
                    vertical-align: bottom; 
                ">
                
                <H3>
                    <TR>
                        <TD><xsl:value-of select="local-name(..)"/>: </TD>
                        <TD STYLE="font-family: monospace;"><xsl:value-of select="."/></TD>
                    </TR>
                </H3>
                
                </TABLE>
                
            </xsl:when> 
            
            <!-- 
                display vectors 
            -->
            
            <xsl:when test="@dims = '1'">
                            
                <TABLE STYLE="
                    border: 1px dotted black;
                    margin: 8px;
                    vertical-align: bottom; 
                    display: inline;
                ">
                
                <xsl:for-each select="E">
                    <TR STYLE="border: 1px dotted black;"><TD><xsl:value-of select="."/></TD></TR>
                </xsl:for-each>
                
                </TABLE>
                            
            </xsl:when>
            
            <!-- 
                display matrices 
            -->
            
            <xsl:when test="@dims = '2'">
                             
                <TABLE BORDER="2">
                
                <xsl:for-each select="R">
                    <TR>
                    <xsl:for-each select="E">
                        <TD><xsl:value-of select="."/></TD>
                    </xsl:for-each>
                    </TR>
                </xsl:for-each>
                
                </TABLE>
                            
            </xsl:when>
            
        </xsl:choose>
            
    </xsl:template>
    
    
</xsl:stylesheet> 
