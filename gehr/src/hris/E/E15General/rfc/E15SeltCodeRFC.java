package hris.E.E15General.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E15General.*;

/**
 * E15SeltCodeRFC.java
 * 병원별선택검사 possible entry RFC 를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2007/02/21
 */
public class E15SeltCodeRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_SELT_CODE";
    private String functionName = "ZGHR_RFC_SELT_CODE";


    /**
     * 경조대상자관계 possible entry RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getSeltCode(String empNo, String hospCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,hospCode);
            excute(mConnection, function);
            Vector ret = getTable(E15StmcCodeData.class, function, "T_RESULT");//getOutput(function);

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
    private void setInput(JCO.Function function, String empNo, String hospCode) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_HOSP_CODE";
        setField(function, fieldName2, hospCode);
    }

}


