package hris.E.E15General.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E15General.*;

/**
 * E15PossNumRFC.java
 * 검진병원별 년월별 예약가능인원 및 예약인원수에 대한 데이터를 가져오는 RFC를 호출하는 Class
 *
 * @author Lsa
 * @version 1.0, 2008/01/30
 */
public class E15PossNumRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_REQU_POSS_NUM";
    private String functionName = "ZGHR_RFC_REQU_POSS_NUM";

    /**
     * 검진병원에 대한 데이터를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInwonCnt(String empNo,String yyMm,String hospCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput( function, empNo, yyMm, hospCode);
            excute(mConnection, function);
            Vector ret = getTable(E15PossNumData.class, function, "T_CARE"); //getOutput(function);
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
    private void setInput(JCO.Function function, String empNo,String yyMm,String hospCode) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_YYMM";
        setField(function, fieldName2, yyMm);
        String fieldName3 = "I_HOSP_CODE";
        setField(function, fieldName3, hospCode);
    }


}

