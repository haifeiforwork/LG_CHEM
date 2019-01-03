package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * DeptCodeNumberingRFC.java
 * 부서에 따른 numbering 값을 가져오는 RFC를 호출하는 Class(@2014 연말정산 소득공제신고서에 추가된 항목)
 *
 * @author 이지은   
 * @version 1.0, 2014/12/18
 *
 */
public class DeptCodeNumberingRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_ORGEH_NUMBERING";

    /**
     * 부서에 따른 numbering 값을 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사번
     * @param java.lang.String 연말정산 년도
     * @return java.lang.String 부서구분번호
     * @exception com.sns.jdf.GeneralException
     * 
     */
    public String getDeptCodeNumber( String webUserId, String targetYear ) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, webUserId, targetYear);

            excute(mConnection, function);
            return getOutput(function);

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
     * @exception com.sns.jdf.GeneralException
     * 
     */
    private void setInput(JCO.Function function, String webUserId, String targetYear) throws GeneralException{
        String fieldName = "I_PERNR";
        setField(function, fieldName, webUserId);
		String fieldName2 = "I_YEAR";
        setField(function, fieldName2, targetYear);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput(JCO.Function function) throws GeneralException {
        //String fieldName = "E_FLAG";      // RFC Export 구성요소 참조
        //return getField(fieldName, function);
    	String fieldName = "E_NUM";

		String E_NUM    = getField(fieldName,    function);  // 회사코드 
        return E_NUM;
    	
    }
}

