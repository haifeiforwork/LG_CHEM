document.onreadystatechange=function()
{
 if (document.readyState == 'complete')
 {
      if (document.all['divShowInstall'])
        document.all['divShowInstall'].style.visibility = 'hidden';
  }
}

var strScripts ="<OBJECT ID='wec' CLASSID='CLSID:92D02CB1-2A1F-4EA5-A414-DFCBEC538494' WIDTH='539' HEIGHT='325' CodeBase='/web/namo7/NamoWec.cab#Version=7,0,0,55'>";
strScripts +="<PARAM NAME='UserLang' VALUE=kor>";
strScripts +="<PARAM NAME='InitFileURL' VALUE='/web/namo7/As7Init.xml'>";
strScripts +="</OBJECT>";


document.write(strScripts);