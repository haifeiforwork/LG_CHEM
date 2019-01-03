package	hris.E.E15General.rfc;

import java.util.*;

import com.sap.mw.jco.*;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E15General.*;

/**
 * E15SexyFlagRFC.java
 * 본인, 배우자에 대한 검진대상자 여부 데이터를 가져오는 RFC를 호출하는 Class
 *
 * @author 이형석
 * @version 1.0, 2001/12/20
 */
public class E15SexyFlagRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_GET_HOSP_SEXY_FLAG";
    private String functionName = "ZGHR_RFC_GET_HOSP_SEXY_FLAG";

    /**
     * 주택자금 신청에 대한 데이터를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원번호 , java.lang.String 검진대상연도
     * @return hris.E.E15General.E15GeneralData
     * @exception com.sns.jdf.GeneralException
     */
    public E15GeneralData getSexyFlag(String empNo, String p_exam_year) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, empNo, p_exam_year);
            excute(mConnection, function);
            E15GeneralData ret = (E15GeneralData)getOutput(function, ( new E15GeneralData() ));
            return ret;

        }catch(Exception ex){
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
     * @param @param java.lang.String 사원번호 , java.lang.String 검진대상연도
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function,String empNo, String p_exam_year ) throws GeneralException {
        String fieldName = "I_PERNR"          ;
        setField(function, fieldName, empNo);

        String fieldName1= "I_EXAM_YEAR" ;         ;
        setField(function, fieldName1, p_exam_year);
    }

    /**
     * RFC 실행후 Export 값을 Object 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param data java.lang.Object
     * @return java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private Object getOutput(JCO.Function function, E15GeneralData data) throws GeneralException {
          return getFields( data, function );
    }
}

