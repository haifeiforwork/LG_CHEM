package hris.C.C02Curri.rfc;

import java.io.*;
import java.net.*;
import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriFileLinkRFC.java
 * 교육과정 문서링크 를 가져오는 RFC를 호출하는 Class
 *
 * @author 박영락   
 * @version 1.0, 2002/01/14
 */
public class C02CurriFileLinkRFC extends SAPWrap {

    private String functionName = "ZHRS_RFC_VIEW_ATTA";

    /**
     * 교육과정 문서링크를 가져오는 RFC를 호출하는 Method
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public String getLink( String CHAID ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, CHAID );
            excute(mConnection, function);
            Vector ret = getOutput(function);
            String img = "";
            StringBuffer sb = new StringBuffer();
            
            for ( int i = 0 ; i < ret.size() ; i++ ){
                C02CurriFileInfoData data = (C02CurriFileInfoData)ret.get(i);
                if( ((data.FILE_EXT).toUpperCase()).equals("XLS") ){
                    img = "<img src="+WebUtil.ImageURL+"xls.gif border=0 >";
                } else if( ((data.FILE_EXT).toUpperCase()).equals("DOC") ){
                    img = "<img src="+WebUtil.ImageURL+"doc.gif border=0 >";
                } else if( ((data.FILE_EXT).toUpperCase()).equals("PPT") ){
                    img = "<img src="+WebUtil.ImageURL+"ppt.gif border=0 >";
                } else if( ((data.FILE_EXT).toUpperCase()).equals("ZIP") ){
                    img = "<img src="+WebUtil.ImageURL+"zip.gif border=0 >";
                } else if( ((data.FILE_EXT).toUpperCase()).equals("HTML") ){
                    img = "<img src="+WebUtil.ImageURL+"html.gif border=0 >";
                }else if( ((data.FILE_EXT).toUpperCase()).equals("EXE") ){
                    img = "<img src="+WebUtil.ImageURL+"exe.gif border=0 >";
                }else if( ((data.FILE_EXT).toUpperCase()).equals("HWP") ){
                    img = "<img src="+WebUtil.ImageURL+"hwp.gif border=0 >";
                }else if( ((data.FILE_EXT).toUpperCase()).equals("TXT") ){
                    img = "<img src="+WebUtil.ImageURL+"text.gif border=0 >";
                }else if( ((data.FILE_EXT).toUpperCase()).equals("JPG") ){
                    img = "<img src="+WebUtil.ImageURL+"jpg.gif border=0 >";
                } else {
                    img = "<img src="+WebUtil.ImageURL+"unknown.gif border=0 >";
                }
                sb.append("<a href=\""+WebUtil.ServletURL+"hris.C.C02Curri.C02CurriFileDownSV?PHIO_ID="+data.PHIO_ID+ "&STOR_CAT="+data.STOR_CAT+"&OBJDES="+WebUtil.encode(data.OBJDES)+"&FILE_EXT="+WebUtil.encode(data.FILE_EXT)+"\">");
                sb.append(img +"&nbsp;" + data.OBJDES+"."+(data.FILE_EXT).toLowerCase()+"&nbsp;("+ WebUtil.printNumFormat(Integer.toString(Integer.parseInt(data.OBJLEN)))+" Byte)</a><br>" );
            }

            return sb.toString();
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entity java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key) throws GeneralException{
        String fieldName = "P_OBJKEY";
        String val = "01"+key;
        setField(function, fieldName, val);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C02Curri.C02CurriFileInfoData";
        String tableName = "ITAB";
        return getTable(entityName, function, tableName);
    }
}
