package	hris.D.D03Vocation.rfc;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;

import hris.D.D03Vocation.D03VocationData;
import hris.common.approval.ApprovalSAPWrap;

/**
 * D03VocationRFC.java
 * 개인의 휴가신청 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/01/21
 * 
 * Update       : 2018-05-17  성환희 [WorkTime52] 보상휴가 추가 건
 */
public class D03VocationRFC extends ApprovalSAPWrap {
 
    //private String functionName = "ZHRW_RFC_HOLIDAY_REQUEST";
    private static String functionName = "ZGHR_RFC_HOLIDAY_REQUEST";

    /**
     * 개인의 휴가신청 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getVocation(String keycode, String seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, seqn, "1","");

            excuteDetail(mConnection, function);
            
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
     * 휴가신청 입력 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */ 
    public String  build(String keycode, Object vocation, String P_A002_SEQN, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            D03VocationData data = (D03VocationData)vocation;

            Vector vocationVector = new Vector();
            vocationVector.addElement(data);

            setInput(function, keycode, null, "2",P_A002_SEQN);

            setInput(function, vocationVector, "T_RESULT");//P_RESULT

            /* 모바일에서 결재라인 관련 처리 */
            if(box.getObject("T_IMPORTA") != null)
                setTable(function, "T_IMPORTA", (Vector) box.getObject("T_IMPORTA"));

            return executeRequest(mConnection, function, box, req);

//        	Vector ret = new Vector();
//        	// Export 변수 조회
//        	String fieldName1 = "E_RETURN";        // 리턴코드
//        	String E_RETURN   = getField(fieldName1, function) ;
//        	
//        	String fieldName2 = "E_MESSAGE";     // 다이얼로그 인터페이스에 대한 메세지텍스트
//        	String E_MESSAGE  = getField(fieldName2, function) ; 
//        	ret.addElement(E_RETURN);
//        	ret.addElement(E_MESSAGE);
//            return ret;            

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * 휴가신청 수정 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    public Vector change(String keycode, String seqn, Object vocation, String P_A002_SEQN ,Box box,  HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            D03VocationData data = (D03VocationData)vocation;

            Vector vocationVector = new Vector();
            vocationVector.addElement(data);

            setInput(function, keycode, seqn, "3",P_A002_SEQN);

            setInput(function, vocationVector, "T_RESULT");

            executeChange(mConnection, function, box, req);

        	Vector ret = new Vector();
        	// Export 변수 조회
//        	String fieldName1 = "E_RETURN";        // 리턴코드
//        	String E_RETURN   = getField(fieldName1, function) ;
//        	
//        	String fieldName2 = "E_MESSAGE";     // 다이얼로그 인터페이스에 대한 메세지텍스트
//        	String E_MESSAGE  = getField(fieldName2, function) ; 
//        	ret.addElement(E_RETURN);
//        	ret.addElement(E_MESSAGE);
            return ret;            
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * 휴가신청 삭제 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete(String keycode, String seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, seqn, "4","");
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
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode, String seqn, String jobcode,String P_A002_SEQN) throws GeneralException {
        String fieldName1 = "I_ITPNR"          ;//P_PERNR
        setField(function, fieldName1, keycode);
        
        String fieldName2 = "I_AINF_SEQN"          ;//P_AINF_SEQN
        setField(function, fieldName2, seqn)  ;
        
        String fieldName3 = "I_GTYPE"      ;//P_CONT_TYPE
        setField(function, fieldName3, jobcode);

        String fieldName4 = "I_A002_SEQN";//P_A002_SEQN
        setField(function, fieldName4, P_A002_SEQN);               

        setField(function, "I_NTM", "X");
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
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D03Vocation.D03VocationData";
        String tableName  = "T_RESULT";
        return getTable(entityName, function, tableName);
    }
}