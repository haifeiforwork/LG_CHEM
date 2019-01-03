package hris.E.E30HealthInsurance.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E30HealthInsurance.*;

/**
 * E30HealthInsuranceRFC.java
 * 건강보험 관련 정보를 조회하는 RFC 를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2003/02/19
 */
public class E30HealthInsuranceRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_GET_HEALTH_INSURANCE";
	private String functionName = "ZGHR_RFC_GET_HEALTH_INSURANCE";

    /**
     * 건강보험 관련 정보를 조회 RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호
     * @return java.object E30HealthInsuranceData
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);

            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * (대상정보) 사업장 기호를 조회하는 RFC를 호출하는 Method
     * @exception com.sns.jdf.GeneralException
     */
    public String getE_MINUM( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_MINUM" ;
            String ret       = getField( fieldName, function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * (대상정보) 의료보험카드번호를 조회하는 RFC를 호출하는 Method
     * @exception com.sns.jdf.GeneralException
     */
    public String getE_MICNR( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_MICNR" ;
            String ret       = getField( fieldName, function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
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
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

        Vector P_RESULT    = getTable(E30HealthInsuranceData.class, function, "T_RESULT");

        Vector P_RESULT_21 = getTable(E30HealthInsuranceData.class, function, "T_RESULT_21");


        ret.addElement(P_RESULT);
        ret.addElement(P_RESULT_21);

        return ret;
    }

}
