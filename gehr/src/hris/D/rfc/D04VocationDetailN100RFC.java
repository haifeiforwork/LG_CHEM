package	hris.D.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.*;

/**
 * D04VocationDetailN100RFC.java
 * 개인의 휴가현황 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  김도신 - 석유화학 전용
 * @version 1.0, 2004/09/16
 */
public class D04VocationDetailN100RFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_HOLIDAY_DISPLAY_N";

    /**
     * 개인의 휴가현황 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getVocationDetail( String empNo, String year ) throws GeneralException {
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year);
            excute(mConnection, function);
            
            Vector ret = null;
                        
            ret = getOutput(function);
            
            return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
 
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value, String value1) throws GeneralException {
        String fieldName  = "P_PERNR";
        String fieldName1 = "P_YEAR";
        setField(function, fieldName, value);
        setField(function, fieldName1, value1);
        
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();
        
//      Export 변수 조회
        String fieldName1      = "P_NON_ABSENCE";      // 개근연차계
        String P_NON_ABSENCE   = getField(fieldName1, function) ;

        String fieldName2      = "P_LONG_SERVICE";     // 근속연차계
        String P_LONG_SERVICE  = getField(fieldName2, function) ;
        
        String fieldName3      = "P_COMPEN_CNT";       // 교대 보상계
        String P_COMPEN_CNT    = getField(fieldName3, function) ;
        
//      Table 결과 조회
        String entityName      = "hris.D.D04VocationDetail1Data";
        Vector P_OCCUR_RESULT  = getTable(entityName,  function, "P_OCCUR_RESULT");

        String entityName1     = "hris.D.D04VocationDetail1Data";
        Vector P_OCCUR_RESULT1 = getTable(entityName1, function, "P_OCCUR_RESULT1");

        String entityName2     = "hris.D.D04VocationDetail1Data";
        Vector P_OCCUR_RESULT2 = getTable(entityName2, function, "P_OCCUR_RESULT2");
        
        String entityName3     = "hris.D.D04VocationDetail2Data";
        Vector P_USED_RESULT   = getTable(entityName3, function, "P_USED_RESULT");

        String entityName4     = "hris.D.D04VocationDetail2Data";
        Vector P_USED_RESULT1  = getTable(entityName4, function, "P_USED_RESULT1");

        String entityName5     = "hris.D.D04VocationDetail2Data";
        Vector P_USED_RESULT2  = getTable(entityName5, function, "P_USED_RESULT2");
        
        ret.addElement(P_NON_ABSENCE);
        ret.addElement(P_LONG_SERVICE);
        ret.addElement(P_OCCUR_RESULT);
        ret.addElement(P_OCCUR_RESULT1);
        ret.addElement(P_OCCUR_RESULT2);
        ret.addElement(P_USED_RESULT);
        ret.addElement(P_USED_RESULT1);
        ret.addElement(P_USED_RESULT2);
        ret.addElement(P_COMPEN_CNT);

        return ret;
    }

}
