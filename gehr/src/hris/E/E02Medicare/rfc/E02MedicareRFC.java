package hris.E.E02Medicare.rfc;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.A.A17Licence.A17LicenceData;
import hris.E.E02Medicare.*;
import hris.common.approval.ApprovalSAPWrap;


/**
 * E02MedicareRFC.java
 * 건강보험증 변경/재발급 조회/신청/수정/삭제 RFC 를 호출하는 Class
 *
 * @author 박영락
 * @version 1.0, 2002/01/28
 */
public class E02MedicareRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRW_RFC_HEALTH_INSURANCE";
	private String functionName = "ZGHR_RFC_HEALTH_INSURANCE";

    /**
     * 건강보험증 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @param java.lang.String 결재정보 일련번호
     * @param java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail( String P_AINF_SEQN , String P_PERNR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "1");
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

    public Vector<E02MedicareData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(E02MedicareData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 건강보험증 신청 RFC 호출하는 Method
  	 * @param java.lang.String 결재정보 일련번호
     * @param java.lang.String 사원번호
	 * @param java.util.Vector 건강보험증신청 Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String P_AINF_SEQN, String P_PERNR, Vector createVector ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "2", createVector);
            excute(mConnection, function);
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public String build(Vector<E02MedicareData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setTable(function, "T_RESULT", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 건강보험증 수정 RFC 호출하는 Method
     * @param java.lang.String 결재정보 일련번호
     * @param java.lang.String 사원번호
     * @param java.util.Vector 건강보험증 Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void change( String P_AINF_SEQN, String P_PERNR, Vector createVector  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "3", createVector);
            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 건강보험증 삭제 RFC 호출하는 Method
     * @param java.lang.String 결재정보 일련번호
     * @param java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public void delete( String P_AINF_SEQN, String P_PERNR  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "4");
            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public RFCReturnEntity delete() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            return executeDelete(mConnection, function);

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
    private void setInput(JCO.Function function, String key1, String key2, String job) throws GeneralException {
        String fieldName = "P_AINF_SEQN";
        setField( function, fieldName, key1 );
        String fieldName1 = "P_PERNR";
        setField( function, fieldName1, key1 );
        String fieldName2 = "P_CONF_TYPE";
        setField( function, fieldName2, job );

    }


    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param java.lang.String 결재정보 일련번호
     * @param java.lang.String 사원번호
     * @param job java.lang.String 기능정보
     * @param job java.util.Vector entityVector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String P_AINF_SEQN, String P_PERNR, String job, Vector entityVector) throws GeneralException {
        String fieldName = "P_AINF_SEQN";
        setField( function, fieldName, P_AINF_SEQN );
        String fieldName2 = "P_PERNR";
        setField( function, fieldName2, P_PERNR );
        String fieldName3 = "P_CONF_TYPE";
        setField( function, fieldName3, job );
        String tableName = "P_RESULT";
        setTable(function, tableName, entityVector);
    }



    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E02Medicare.E02MedicareData";
        Vector  ret = getTable(entityName, function, "P_RESULT");
        return ret ;
    }
}


