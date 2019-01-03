package hris.E.Global.E21Expense.rfc;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.Global.E21Expense.*;
import hris.common.approval.ApprovalSAPWrap;

/**
 * E21ExpenseRFC.java
 * 학자금/장학금 신청,조회,삭제 RFC 를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/01/03
 */
public class E21ExpenseRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRW_RFC_REIMBURSE_REQUEST";
    private String functionName = "ZGHR_RFC_REIMBURSE_REQUEST";

    /**
     * 학자금/장학금 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @param P_AINF_SEQN java.lang.String 결재정보 일련번호
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public E21ExpenseStructData displayData(String empNo,String subty,String schoolty,String cname,String cdate,String waers,String OBJPS ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput1(function,empNo,"","5",subty,schoolty,cname,cdate,"",OBJPS);

            excute(mConnection, function);
            E21ExpenseStructData ret = getOutput(function,new E21ExpenseStructData());
            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public String displayWaers(String empNo,String cdate) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function,empNo,"","6","","","",cdate,"");

            excute(mConnection, function);
            return getField("E_WAERS", function);  // 변수명 확인.  P_WAERS
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * 학자금/장학금  신청 RFC 호출하는 Method
     * @return java.util.Vector
     * @param P_AINF_SEQN java.lang.String 결재정보 일련번호
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public String build(  String empNo,String ainf_seqn , Vector data ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setInput(function, empNo,ainf_seqn, "2","","","","","" ) ;
            setInput(function,data,"T_ITAB");
            excute(mConnection, function);
            return getField("E_MESSAGE", function);
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public String build(Vector<E21ExpenseData> T_RESULT, Box box, HttpServletRequest req, Vector tem) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            //Logger.debug.println(this, "====box.get ========= : " + box );
            //setInput(function, empNo, I_INSUR, ainf_seqn, type, cdate, waers);


            setField(function, "I_GTYPE",  box.get("I_GTYPE"));
			setField(function, "I_RTYPE", box.get("I_RTYPE"));			//2016.11.18
            setTable(function, "T_ITAB", T_RESULT);
            setTable(function, "T_FILE", tem);   //2016.11.18
            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 학자금/장학금  등록 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<E21ExpenseData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            //Logger.debug.println(this, "====box.get ========= : " + box );
            //setInput(function, empNo, I_INSUR, ainf_seqn, type, cdate, waers);

            setField(function, "I_GTYPE",  box.get("I_GTYPE"));
            setTable(function, "T_ITAB", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 학자금/장학금  수정 RFC 호출하는 Method
     * @return java.util.Vector
     * @param P_AINF_SEQN java.lang.String 결재정보 일련번호
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public String change(  String empNo,String ainf_seqn , Vector data ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setInput(function, empNo,ainf_seqn, "3","","","","","" ) ;
            setInput(function,data,"T_ITAB");
            excute(mConnection, function);
            return getField("E_MESSAGE", function);
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * 학자금/장학금  삭제 RFC 호출하는 Method
     * @return java.util.Vector
     * @param P_AINF_SEQN java.lang.String 결재정보 일련번호
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public String delete(String pernr,  String AINF_SEQN ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function,pernr,AINF_SEQN, "4","","","","","" );
            excute(mConnection, function);
            return getField("E_MESSAGE", function);
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector detail(String pernr,  String AINF_SEQN ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function,pernr,AINF_SEQN, "1","","","","","" );
            //excute(mConnection, function);
            excuteDetail(mConnection, function);

            return getTable(hris.E.Global.E21Expense.E21ExpenseData.class, function, "T_ITAB");

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
    private void setInput(JCO.Function function,String empNo,String ainf_seqn, String type,String subty,String schoolty,String cname,String cdata,String waers ) throws GeneralException {
        String fieldName = "I_ITPNR";
        setField( function, fieldName, empNo );
        String fieldName2 = "I_AINF_SEQN";
        setField( function, fieldName2, ainf_seqn );
        String fieldName3 = "I_GTYPE";
        setField( function, fieldName3, type );
        String fieldName4 = "I_SUBTY";
        setField( function, fieldName4, subty );
        String fieldName5 = "I_SCHL_TYPE";
        setField( function, fieldName5, schoolty );
        String fieldName6 = "I_CHLD_NAME";
        setField( function, fieldName6, cname );
        String fieldName7 = "I_DATE";
        setField( function, fieldName7, cdata );
        String fieldName8 = "I_WAERS";
        setField( function, fieldName8, waers );
    }


    private void setInput1(JCO.Function function,String empNo,String ainf_seqn, String type,String subty,String schoolty,String cname,String cdata,String waers ,String objps) throws GeneralException {
        String fieldName = "I_ITPNR";
        setField( function, fieldName, empNo );
        String fieldName2 = "I_AINF_SEQN";
        setField( function, fieldName2, ainf_seqn );
        String fieldName3 = "I_GTYPE";
        setField( function, fieldName3, type );
        String fieldName4 = "I_SUBTY";
        setField( function, fieldName4, subty );
        String fieldName5 = "I_SCHL_TYPE";
        setField( function, fieldName5, schoolty );
        String fieldName6 = "I_CHLD_NAME";
        setField( function, fieldName6, cname );
        String fieldName7 = "I_DATE";
        setField( function, fieldName7, cdata );
        String fieldName8 = "I_WAERS";
        setField( function, fieldName8, waers );
        String fieldName9 = "I_OBJPS";
        setField( function, fieldName9, objps );
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

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    private E21ExpenseStructData getOutput(JCO.Function function,E21ExpenseStructData data) throws GeneralException {
        //String structureName = "WA_ITAB";
        E21ExpenseStructData returnData = new E21ExpenseStructData();
        try{
                returnData = (E21ExpenseStructData)getStructor(data, function, "S_ITAB");
           }catch(GeneralException e){

           	Logger.debug.println("E21ExpenseRFC.getOutput.(E21ExpenseStructData)E21ExpenseStructData(data, function, structureName) exception");
           }
        return returnData;
   }

    /**
     * 자금/장학금  삭제 RFC 호출하는 Method
     * @return java.util.Vector
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


}


