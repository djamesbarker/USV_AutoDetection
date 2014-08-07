
/* NOTE: part of a first attempt to produce a document interface for exported logs */


// popup_clip - popup for display of clip image and play
// -----------------------------------------------------
//
// popup_clip(id, clip, clip_image, x, y)
//
// Input:
// ------
//  id - event id
//  clip - clip location
//  clip_image - clip image location
//  x - width in pixels of image displayed
//  y - height in pixels of image displayed

/*
%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2005-02-24 21:18:55 -0500 (Thu, 24 Feb 2005) $
% $Revision: 609 $
%--------------------------------
*/

function popup_clip(id, clip, clip_image, x, y) {

	//--------------------------------
	// create window
	//--------------------------------
	
	out = window.open("",
		menubar = 0, resizable = 0, scrollbars = 0, toolbar = 0
	);
		
	out.resizeTo(x + 70, y + 140);
	
	out.focus();
	
	//--------------------------------
	// create window content
	//--------------------------------

	//--
	// open window document
	//--
	
	out.document.open();
	
	//--
	// display image
	//--
	
	out.document.write(
		"<TABLE width = '100%'>\n<TR>\n<TD align = 'center'>\n"
	);
	
	out.document.write(
		"<DIV style = 'margin: 0px; padding: 0px;'>\n"
	);
	
	out.document.write(
		"<IMG class = 'popup_clip' " +
			"src = '" + clip_image + "' " +
			"style = 'horizontal-align: center; margin: 16px; border: 1px solid silver;' " +
		"/>\n"
	);
	
	out.document.write(
		"</DIV>\n</TD>\n</TR>\n"
	);
	
	//--
	// add play controller
	//--
	
	out.document.write("<TR>\n<TD align = 'center'>\n");
	
	out.document.write("<DIV style = 'width: 100%; margin: 0px;'>\n");
	
	out.document.write(
		"<OBJECT " + 
			"classid='clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B' " +
			"width = '" + x + "' height = '16' " + 
			"codebase='http://www.apple.com/qtactivex/qtplugin.cab'>\n" +
			"\t<PARAM name = 'src' value = '" + clip + "'>\n" +
			"\t<PARAM name = 'autoplay' value = 'false'>\n" +
			"\t<PARAM name = 'controller' value = 'true'>\n" +
			"\t<EMBED " +		
				"src = '" + clip + "' " + 
				"width = '" + x + "' height = '16' controller = 'true' " +
				"pluginspage = 'http://www.apple.com/quicktime/download/'>\n" + 
		"</OBJECT>\n"
	);
	
	out.document.write(
		"</DIV>\n</TD>\n</TR>"
	);

	//--
	// close window document
	//--
	
	// NOTE: this needs to happen before the document is displayed
	
	out.document.close();
	
}

// NOTE: clearly this approach can be generalized

// code_toggle - toggle display of event code
// ------------------------------------------
//
// code_toggle()

/*
%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2005-02-24 21:18:55 -0500 (Thu, 24 Feb 2005) $
% $Revision: 609 $
%--------------------------------
*/

function code_toggle() {

	// NOTE: this rule only contains display information
	
	//--
	// delete previous rule
	//--
	
	j = get_cssrule("span.code_container");
		
	if (j) {
		document.styleSheets[0].deleteRule(j);
	}
		
	//-- 
	// add current rule
	//--
	
	if (document.all.code_toggle.checked) {

		document.styleSheets[0].insertRule(
			"span.code_container {display: inline}", document.styleSheets[0].cssRules.length
		);

	} else {

		document.styleSheets[0].insertRule(
			"span.code_container {display: none}", document.styleSheets[0].cssRules.length
		);

	}
}


// info_toggle - toggle display of event info
// ------------------------------------------
//
// info_toggle()

/*
%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2005-02-24 21:18:55 -0500 (Thu, 24 Feb 2005) $
% $Revision: 609 $
%--------------------------------
*/

function info_toggle() {

	// NOTE: this rule only contains display information
	
	//--
	// delete previous rule
	//--
	
	j = get_cssrule("div.info_container");
		
	if (j) {
		document.styleSheets[0].deleteRule(j);
	}
		
	//-- 
	// add current rule
	//--
	
	if (document.all.info_toggle.checked) {

		document.styleSheets[0].insertRule(
			"div.info_container {display: inline}", document.styleSheets[0].cssRules.length
		);

	} else {

		document.styleSheets[0].insertRule(
			"div.info_container {display: none}", document.styleSheets[0].cssRules.length
		);

	}

}


// get_cssrule - get css rule from stylesheet via selector
// -------------------------------------------------------
//
// j = get_cssrule(selector)

/*
%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2005-02-24 21:18:55 -0500 (Thu, 24 Feb 2005) $
% $Revision: 609 $
%--------------------------------
*/

function get_cssrule(selector)
{
	
    var sheetList = document.styleSheets;
	
    var ruleList;
    
	var i, j;

   	// NOTE: we look through stylesheets in reverse order, think cascade
    
	for (i = (sheetList.length - 1); i >= 0; i--) {
	
		// NOTE: selector must be in lowercase
		
        ruleList = sheetList[i].cssRules;
				
        for (j = 0; j < ruleList.length; j++) {
        					
			if (
				(ruleList[j].type == CSSRule.STYLE_RULE) && 
				(ruleList[j].selectorText == selector)
			) {
                return j;
            } 
			
        }
    
	}

    return null;
	
}