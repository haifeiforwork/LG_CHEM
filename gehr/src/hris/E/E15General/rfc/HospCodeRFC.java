package hris.E.E15General.rfc;

import hris.E.E15General.E15GeneralData;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

/**
 * HospCodeRFC.java
 * 검진병원에 대한 데이터를 가져오는 RFC를 호출하는 Class
 *
 * @author 이형석
 * @version 1.0, 2001/12/13
 */
public class HospCodeRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_P_HOSP_CODE";
    private String functionName = "ZGHR_RFC_P_HOSP_CODE";

    /**
     * 검진병원에 대한 데이터를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getHospCode(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput( function, empNo );
            excute(mConnection, function);
            Vector ret = getTable(E15GeneralData.class, function, "T_RESULT");//getOutput(function);
            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
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
     */
    private void setInput(JCO.Function function, String value) throws GeneralException {
        String fieldName = "I_PERNR";
        setField(function, fieldName, value);
    }


}

