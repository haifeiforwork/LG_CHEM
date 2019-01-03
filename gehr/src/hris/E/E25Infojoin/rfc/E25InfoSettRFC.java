package	hris.E.E25Infojoin.rfc;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;

import hris.A.A17Licence.A17LicenceData;
import hris.E.E25Infojoin.*;
import hris.common.approval.ApprovalSAPWrap;

/**
 * E25InfoSettRFC.java
 * 신청한 인포멀에 대한 결재를 신청하는 rfc를 호출하는 class
 *
 * @author 이형석
 * @version 1.0, 2002/01/04
 */
public class E25InfoSettRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRH_RFC_INFORMAL_SETT ";
	private String functionName = "ZGHR_RFC_INFORMAL_SETT ";

    /**
     * 신청한 인포멀에 대한 결재 신청 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원번호 java.lang.String 시험코드 java.lang.String 결재일련번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
  /*  public Vector getInfoSett(String empNo, String p_ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, p_ainf_seqn, "1");

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
*/
    public Vector<E25InfoSettData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(E25InfoSettData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    public String build(Vector<E25InfoSettData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

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
     * 신청한 인포멀에 대한 결재 신청을 insert하는 Method
     * @param java.lang.String 사원번호 java.lang.String 시험코드 java.lang.String 결재일련번호 java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
  /*  public void build(String empNo, String p_ainf_seqn, Vector InfoSett_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, p_ainf_seqn, "2");

            setInput(function, InfoSett_vt, "P_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

*/



     /**
     * 신청한 데이터를 삭제하는 Method
     * @param java.lang.String 사원번호 java.lang.String 결재일련번호
     * @exception com.sns.jdf.GeneralException
     */
  /*
    public void delete(String empNo, String p_ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, p_ainf_seqn, "4");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
*/

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
     * @param value java.lang.String 사번 java.lang.String 결재일련번호  java.lang.String 작업구분
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function,String empNo, String p_ainf_seqn, String jobcode) throws GeneralException {
        String fieldName1 = "P_AINF_SEQN"          ;
        setField(function, fieldName1, p_ainf_seqn)  ;

        String fieldName2 = "P_CONT_TYPE"      ;
        setField(function, fieldName2, jobcode);

        String fieldName3 = "P_PERNR"          ;
        setField(function, fieldName3, empNo);



    }

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
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E25Infojoin.E25InfoSettData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }
}


