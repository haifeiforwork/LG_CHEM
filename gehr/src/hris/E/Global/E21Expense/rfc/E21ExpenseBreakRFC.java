package hris.E.Global.E21Expense.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E21Expense.*;

/**
 * E21ExpenseBreakRFC.java
 * 학자금/장학금 신청시 휴직기간을 체크 Class
 *
 * @author 최영호
 * @version 1.0, 2003/06/18
 */
public class E21ExpenseBreakRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_BREAK_CHK";


    public String check( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, empNo );
            excute(mConnection, function);

            String I_FLAG = null;

            I_FLAG = getOutput(function);

            return I_FLAG;

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
     * @param P_AINF_SEQN java.lang.String 결재정보 일련번호
     * @param empNo java.lang.String 사원번호
     * @param job java.lang.String 기초신용평가 유형
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String empNo ) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }

   /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput(JCO.Function function) throws GeneralException {
        String fieldName = "I_FLAG";      // 구분자
        return getField(fieldName, function);
    }

}


