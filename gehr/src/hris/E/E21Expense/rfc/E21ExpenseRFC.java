package hris.E.E21Expense.rfc;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E21Expense.*;
import hris.common.approval.ApprovalSAPWrap;

/**
 * E21ExpenseRFC.java
 * 학자금/장학금 신청,조회,삭제 RFC 를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/01/03
 */
public class E21ExpenseRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRW_RFC_SCHOOL_FEE_LIST";
    private String functionName = "ZGHR_RFC_SCHOOL_FEE_LIST";

    /**
     * 학자금/장학금 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @param P_AINF_SEQN java.lang.String 결재정보 일련번호
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String P_AINF_SEQN, String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, P_AINF_SEQN, empNo, "1");
            excuteDetail(mConnection, function); //excute(mConnection, function);
            Vector ret = getTable(E21ExpenseData.class, function, "T_SCHOOL_RESULT");// getOutput(function);

//          2002.06.12. 통화키에 따른 소숫점 관리 RFC를 읽어 처리했으나
//                      현재 R3가 KRW를 제외한 나머지 통화키를 2자리로 셋팅하여 관리하므로
//                      ESS에서도 소숫점 관리 RFC를 읽지 않도록 한다.
//          2002.06.12. KRW를 제외한 나머지 통화키는 읽어온 그대로 보여준다. KRW는 100을 곱한다.
            for( int i = 0 ; i < ret.size() ; i++ ) {
                E21ExpenseData data = (E21ExpenseData)ret.get(i);

//              신청액
                if( data.WAERS.equals("KRW") ) {
                    if(data.PROP_AMNT.equals("")){ data.PROP_AMNT=""; }else{ data.PROP_AMNT=Double.toString(Double.parseDouble(data.PROP_AMNT) * 100.0 ) ; }
                }

//              회사지급액
                if( data.WAERS1.equals("KRW") ) {
                    if(data.PAID_AMNT.equals("")){ data.PAID_AMNT=""; }else{ data.PAID_AMNT=Double.toString(Double.parseDouble(data.PAID_AMNT) * 100.0 ) ; }
                }

//              연말정산반영액 - 항상 KRW
                    if(data.YTAX_WONX.equals("")){ data.YTAX_WONX=""; }else{ data.YTAX_WONX=Double.toString(Double.parseDouble(data.YTAX_WONX) * 100.0 ) ; }
            }
//          2002.06.12. KRW를 제외한 나머지 통화키는 읽어온 그대로 보여준다. KRW는 100을 곱한다.
            return ret;
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
    public void build( String P_AINF_SEQN , String empNo, Object school_obj ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            E21ExpenseData school_data = (E21ExpenseData)school_obj;

//          2002.06.12. 통화키에 따른 소숫점 관리 RFC를 읽어 처리했으나
//                      현재 R3가 KRW를 제외한 나머지 통화키를 2자리로 셋팅하여 관리하므로
//                      ESS에서도 소숫점 관리 RFC를 읽지 않도록 한다.
//          2002.06.12. KRW를 제외한 나머지 통화키는 그대로 저장해준다. KRW는 100을 나눈다.
            if( school_data.WAERS.equals("KRW") ) {
                school_data.PROP_AMNT = Double.toString(Double.parseDouble(school_data.PROP_AMNT) / 100 ) ;  // 신청액
            }
//          2002.06.12. KRW를 제외한 나머지 통화키는 읽어온 그대로 보여준다. KRW는 100을 곱한다.

            Vector schoolVector = new Vector();

            schoolVector.addElement(school_data);

            setInput(function, P_AINF_SEQN, empNo, "2");
            setInput(function, schoolVector, "T_SCHOOL_RESULT");
            excute(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
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
    public void change(  String P_AINF_SEQN , String empNo, Object school_obj ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            E21ExpenseData school_data = (E21ExpenseData)school_obj;

//          2002.06.12. 통화키에 따른 소숫점 관리 RFC를 읽어 처리했으나
//                      현재 R3가 KRW를 제외한 나머지 통화키를 2자리로 셋팅하여 관리하므로
//                      ESS에서도 소숫점 관리 RFC를 읽지 않도록 한다.
//          2002.06.12. KRW를 제외한 나머지 통화키는 그대로 저장해준다. KRW는 100을 나눈다.
            if( school_data.WAERS.equals("KRW") ) {
                school_data.PROP_AMNT = Double.toString(Double.parseDouble(school_data.PROP_AMNT) / 100 ) ;  // 신청액
            }
//          2002.06.12. KRW를 제외한 나머지 통화키는 읽어온 그대로 보여준다. KRW는 100을 곱한다.

            Vector schoolVector = new Vector();

            schoolVector.addElement(school_data);

            setInput(function, P_AINF_SEQN, empNo, "3");
            setInput(function, schoolVector, "T_SCHOOL_RESULT");
            excute(mConnection, function);

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
    public void delete(  String P_AINF_SEQN, String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, empNo, "4");
            excute(mConnection, function);

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
    private void setInput(JCO.Function function, String P_AINF_SEQN, String empNo, String job) throws GeneralException {
        String fieldName = "I_AINF_SEQN";
        setField( function, fieldName, P_AINF_SEQN );
        String fieldName2 = "I_ITPNR";
        setField( function, fieldName2, empNo );
        //String fieldName3 = "P_CONT_TYPE";
        String fieldName3 = "I_GTYPE";
        setField( function, fieldName3, job );
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
            setTable(function, "T_SCHOOL_RESULT", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
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


