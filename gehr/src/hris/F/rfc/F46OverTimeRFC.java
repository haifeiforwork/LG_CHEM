package hris.F.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import hris.F.F46OverTimeData;

/**
 * F46OverTimeRFC
 * 부서코드에 따른 연장근로실적 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  손혜영
 * @version 1.0
 */
public class F46OverTimeRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_WORK_OVERTIME";
    private String functionName = "ZGHR_RFC_GET_WORK_OVERTIME";

    /**
     * 부서코드에 따른 연장근로실적 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위부서조회 여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getOverTime(F46OverTimeData data) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function,data);
            excute(mConnection, function);
			ret = getOutput(function);
			Logger.debug.println(this, " ret = " + ret);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return ret;
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, F46OverTimeData data) throws GeneralException {
        String fieldName1  = "I_ORGEH";
        setField(function, fieldName1, data.I_ORGEH);
        String fieldName2 = "I_TODAY";
        setField(function, fieldName2, data.I_TODAY);
        String fieldName3  = "I_GUBUN";
        setField(function, fieldName3, data.I_GUBUN);
        String fieldName4 = "I_LOWERYN";
        setField(function, fieldName4, data.I_LOWERYN);
        String fieldName5  = "I_OVERYN";
        setField(function, fieldName5, data.I_OVERYN);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector retVt = new Vector();
    	String fieldName1 = "E_YYYYMON";      // 조회년월
    	String E_YYYYMON  = getField(fieldName1, function) ;
    	retVt.addElement(E_YYYYMON);
        String tableName  = "T_EXPORT";
        Vector tableT = new Vector();
        tableT = getTable(hris.F.F46OverTimeData.class, function, tableName);
        retVt.addElement(tableT);
        return retVt;
    }

}


