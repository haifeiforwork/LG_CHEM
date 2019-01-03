/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 신규신청                                           */
/*   Program Name : 주택자금 신규신청                                           */
/*   Program ID   : E05HouseRFC                                                 */
/*   Description  : 개인의 주택자금 신청, 조회, 수정, 삭제를 할 수 있는 Class   */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_FUND_NEW_APP                      */
/*   Creation     : 2005-03-04  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.E.E05House.rfc;

import hris.E.E05House.E05HouseData;
import hris.common.approval.ApprovalSAPWrap;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;

public class E05HouseRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRA_RFC_GET_FUND_NEW_APP";
    private String functionName = "ZGHR_RFC_GET_FUND_NEW_APP";

    /**
     * 개인의 주택자금 신청 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String ainf_seqn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "1");
            excuteDetail(mConnection, function); //excute(mConnection, function);
            Vector ret = getTable(E05HouseData.class, function, "T_RESULT"); //getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 개인의 주택자금  등록 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<E05HouseData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            //Logger.debug.println(this, "====box.get ========= : " + box );
            //setInput(function, ainf_seqn, "2");

            setField(function, "I_GTYPE",  box.get("I_GTYPE"));
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
     * 주택자금 신규신청 RFC 호출하는 Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String ainf_seqn, Vector house_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setInput(function, ainf_seqn, "2");

            //setInput(function, house_vt, "T_EXPORTA");
            setInput(function, house_vt, "T_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 주택자금 신규신청 수정 RFC 호출하는 Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public void change(  String ainf_seqn, Vector house_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "3");
            //setInput(function, house_vt, "T_EXPORTA");
            setInput(function, house_vt, "T_RESULT");

            excute(mConnection, function);

         } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 주택자금 신규신청 삭제 RFC 호출하는 Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public void delete( String ainf_seqn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "4");

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
     * @param ainf_seqn java.lang.String 결재정보 일련번호
     * @param conf_type java.lang.String 기초신용평가 유형
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String ainf_seqn, String conf_type ) throws GeneralException {
        String fieldName  = "I_AINF_SEQN"; // I_AINF_SEQN
        setField( function, fieldName, ainf_seqn );
        String fieldName2 = "I_GTYPE";//"I_CONF_TYPE";
        setField( function, fieldName2, conf_type );
    }

    // Import Parameter 가 Vector(Table) 인 경우
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
     * 주택자금  삭제 RFC 호출하는 Method
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
