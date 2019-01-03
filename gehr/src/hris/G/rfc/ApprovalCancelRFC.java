/*
 * 작성된 날짜: 20013. 09. 20.
 * 			2016.10.10 GEHR 통합작업 수정; KSC
 */
package hris.G.rfc;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;

import hris.G.ApprovalCancelData;
import hris.common.approval.ApprovalSAPWrap;

/**
 * @author 손혜영
 *
 */
public class ApprovalCancelRFC extends ApprovalSAPWrap
{
    private String functionName = "ZGHR_RFC_APPR_CANC_REQUEST";//ZHRW_RFC_APPR_CANC_REQUEST
   
    public Vector get(String pernr, String ainfSeqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, pernr, ainfSeqn, "1");            
            excuteDetail(mConnection, function);            
            Vector ret = getTable(hris.G.ApprovalCancelData.class, function, "T_RESULT");//P_RESULT            
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
     * @exception com.sns.jdf.GeneralException
     */ 
    public String build(String pernr, String ainfSeqn, Vector vocation, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            ApprovalCancelData data = (ApprovalCancelData) vocation.get(0);
            if(data != null) {
            	String I_NTM = data.getI_NTM();
            	setField(function, "I_NTM", I_NTM);
            }
            
            setInput(function, pernr, ainfSeqn, "2");
            setTable(function, "T_RESULT", vocation); //P_RESULT
            return executeRequest(mConnection, function, box, req);          

        } catch(Exception e){
        	Logger.debug("@@@@@@@@@여기였나....");
        	Logger.error(e);
            Logger.sap.println(this, "SAPException : "+e.toString());
            throw new GeneralException(e);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * 휴가신청 수정 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void change(String pernr, String ainfSeqn, Vector vocation, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, pernr, ainfSeqn, "3");
            setTable(function, "T_RESULT", vocation);//P_RESULT
            executeChange(mConnection, function, box, req);
        	                     
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
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete(String pernr, String ainfSeqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);
            setInput(function, pernr, ainfSeqn, "4");
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String pernr, String ainfSeqn, String jobcode) throws GeneralException {
        String fieldName1 = "I_PERNR";//P_PERNR
        setField(function, fieldName1, pernr);
        
        String fieldName2 = "I_AINF_SEQN";//P_AINF_SEQN
        setField(function, fieldName2, ainfSeqn);
        
        String fieldName3 = "I_GTYPE";//P_CONT_TYPE
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
