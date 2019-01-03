package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;


/**
 * A15CertiRFC.java
 * 교육과정 조회/신청/수정/삭제 RFC 를 호출하는 Class                        
 *
 * @author 박영락
 * @version 1.0, 2002/01/15
 */
public class C02CurriApplRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EVENT_LIST";

    /**
     * 교육과정 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @param  java.lang.String 사원번호
	 * @param  java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail( String P_AINF_SEQN ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, "1");
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
     * 교육과정 신청 RFC 호출하는 Method
     * @param java.lang.String 사원번호
	 * @param java.lang.String 결재정보 일련번호
	 * @param java.util.Vector 재직증명신청 Vector
	 * @param java.util.Vector 결재정보 Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String P_AINF_SEQN, String P_CHAID, String P_PERNR, String P_FDATE, String P_TDATE, Vector createVector ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, P_AINF_SEQN, P_CHAID, P_PERNR, P_FDATE, P_TDATE, "2");
            setInput(function, createVector, "P_EVENT");
            excute(mConnection, function);
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 교육과정 삭제 RFC 호출하는 Method
     * @param java.lang.String 사원번호
	 * @param java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public void delete( String P_AINF_SEQN  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, P_AINF_SEQN, "4");

            excute(mConnection, function);

        } catch(Exception ex){
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
	 * @param java.lang.String 사원번호
     * @param java.lang.String 결재정보 일련번호
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key, String job) throws GeneralException {
        String fieldName = "P_AINF_SEQN";
        setField( function, fieldName, key );
        String fieldName1 = "P_CONF_TYPE";
        setField( function, fieldName1, job );

    }






    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
	 * @param java.lang.String 사원번호
     * @param java.lang.String 결재정보 일련번호
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String P_AINF_SEQN, String P_CHAID, String P_PERNR, String P_FDATE, String P_TDATE, String job) throws GeneralException {
        String fieldName = "P_AINF_SEQN";
        setField( function, fieldName, P_AINF_SEQN );
		String fieldName2 = "P_CHAID";
        setField( function, fieldName2, P_CHAID );
        String fieldName3 = "P_PERNR";
        setField( function, fieldName3, P_PERNR );
        String fieldName4 = "P_FDATE";
        setField( function, fieldName4, P_FDATE );
        String fieldName5 = "P_TDATE";
        setField( function, fieldName5, P_TDATE );
        String fieldName6 = "P_CONF_TYPE";
        setField( function, fieldName6, job );
    }

// Import Parameter 가 Vector(Table) 인 경우
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName ) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @param tableName java.util.Vector
     * @param prev java.lang.String
     * @exception com.sns.jdf.GeneralException
     */

    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C02Curri.C02CurriApplData";
        Vector  ret = getTable(entityName, function, "P_EVENT");
        return ret ;
    }
}


