package	hris.E.E38Cancer.rfc;

import hris.E.E38Cancer.E38CancerData;
import hris.common.approval.ApprovalSAPWrap;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;


/**
 * E15GeneralListRFC.java
 * 개인이 신청한 암검진신청 일정을 가져오는 class
 *
 * @author lsa
 * @version 1.0, 2013/06/21 C20130620_53407
 */
public class E38CancerListRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRH_RFC_BANK_HOSP_AREA_LIST_N";
    private String functionName = "ZGHR_RFC_BANK_HOSP_AREA_LIST_N";

    /**
     * 개인의 종합검진 신청 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원번호 java.lang.String 결재일련번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getGeneralList(String empNo, String ainfseqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainfseqn, "1");

            excuteDetail(mConnection, function); //excute(mConnection, function);

            Vector ret = getTable(E38CancerData.class, function, "T_ENTR_RESULT");//getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector getGeneralListAinf(String empNo, String ainfseqn, String rqpnr) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainfseqn, "1");

            setField(function, "I_RQPNR", rqpnr);

            excute(mConnection, function);

            Vector ret = getTable(E38CancerData.class, function, "T_ENTR_RESULT");//getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 추가 암검진 insert하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<E38CancerData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_GTYPE",  box.get("I_GTYPE"));
            setTable(function, "T_ENTR_RESULT", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * 어학능력검정신청을 insert하는 Method
     * @param java.lang.String 사원번호 java.lang.String 결재일련번호 java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build(String empNo, String ainfseqn, Vector General_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainfseqn,"2");

            setInput(function, General_vt, "T_ENTR_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
     /**
     * 신청한 데이터를 수정하는 Method
     * @param java.lang.String 사원번호 java.lang.String 결재일련번호 java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void change(String empNo, String ainfseqn, Vector General_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainfseqn ,"3");

            setInput(function, General_vt, "T_ENTR_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
     /**
     * 신청한 데이터를 삭제하는 Method
     * @param java.lang.String 사원번호 java.lang.String 결재일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public void delete(String empNo, String ainfseqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainfseqn, "4");

            excute(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 신청한 데이터를 삭제하는 Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            return executeDelete(mConnection, function);

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
     * @param java.lang.String 사원번호 java.lang.String 결재일련번호 java.lang.String 작업구분
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function,String empNo, String ainfseqn, String jobcode) throws GeneralException {
//        /String fieldName1 = "I_PERNR"          ;
        String fieldName1 = "I_ITPNR"          ;
        setField(function, fieldName1, empNo);

        String fieldName2 = "I_AINF_SEQN"       ;
        setField(function, fieldName2, ainfseqn)  ;

        String fieldName3 = "I_GTYPE"      ;
        setField(function, fieldName3, jobcode);
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
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

}

