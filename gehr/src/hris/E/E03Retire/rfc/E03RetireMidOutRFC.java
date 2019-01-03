/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 중도인출                                           */
/*   Program Name : 중도인출 신청/조회/변경/삭제                              */
/*   Program ID   : E03RetireMidOutRFC                                         */
/*   Description  : 중도인출 신청/조회/변경/삭제                       */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_MID_SEP_REQ                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire.rfc;

import hris.E.E03Retire.E03RetireMidOutInfoData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

public class E03RetireMidOutRFC extends SAPWrap {

    private String functionName = "ZSOLRP_RFC_MID_SEP_REQ";   

    /**
     * 중도인출 신청정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * 조회는 신청자의 사번을 입력하지 않음 - 결재화면에서는 신청자의 사번을 모르므로..
     */
    public Vector detail(String ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "", "1");

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
     * 중도인출 정보를 변경 신청하는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build(String empNo, String ainf_seqn, Vector MidOutData_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

//            Logger.sap.println(this, "%%%%%%%%%%%%%%%%%%%%%%setRetireMidOut%%%%%%%%%%%%%%%%%%%%%%");
//            Logger.sap.println(this, "ainf_seqn%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+ainf_seqn);
//            Logger.sap.println(this, "empNo%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+empNo);
//            Logger.sap.println(this, "MidOutData_vt%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+MidOutData_vt.toString());
            
            setInput(function, ainf_seqn, empNo, "2");
            setInput(function, MidOutData_vt, "E_RESULT");
            excute(mConnection, function);
            E03RetireMidOutInfoData data = (E03RetireMidOutInfoData)getOutput(function, new E03RetireMidOutInfoData());
        	
        	//에러메시지를 먼저 체크해서 create 안되게 한다.
        	if(data.RETEXT.length() > 0){
        		throw new GeneralException(data.RETEXT);
        	}            
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 중도인출 정보를 변경 신청 후 수정하는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void change(String empNo, String ainf_seqn, Vector MidOutData_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

//            Logger.sap.println(this, "%%%%%%%%%%%%%%%%%%%%%%setRetireMidOut%%%%%%%%%%%%%%%%%%%%%%");
//            Logger.sap.println(this, "ainf_seqn%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+ainf_seqn);
//            Logger.sap.println(this, "empNo%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+empNo);
//            Logger.sap.println(this, "MidOutData_vt%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+MidOutData_vt.toString());
            
            setInput(function, ainf_seqn, empNo, "3");
            setInput(function, MidOutData_vt, "E_RESULT");
            excute(mConnection, function);
            E03RetireMidOutInfoData data = (E03RetireMidOutInfoData)getOutput(function, new E03RetireMidOutInfoData());
        	
        	//에러메시지를 먼저 체크해서 create 안되게 한다.
        	if(data.RETEXT.length() > 0){
        		throw new GeneralException(data.RETEXT);
        	}            
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }    
    
    /**
     * 중도인출 변경 신청정보를 삭제하는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector delete(String empNo, String ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, empNo, "4");

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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String ainf_seqn, String empNo, String cont_type ) throws GeneralException {
        String fieldName1  = "I_AINF_SEQN";
        setField( function, fieldName1, ainf_seqn );
        String fieldName2 = "I_PERNR";
        setField( function, fieldName2, empNo );
        String fieldName3 = "I_CONT_TYPE";
        setField( function, fieldName3, cont_type );          
        
//        Logger.sap.println(this, "ainf_seqn===================="+ainf_seqn);
//        Logger.sap.println(this, "empNo===================="+empNo);
//        Logger.sap.println(this, "cont_type===================="+cont_type);
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
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E03Retire.E03RetireMidOutInfoData";
        return getTable(entityName, function, "E_RESULT");
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
    private Object getOutput(JCO.Function function, E03RetireMidOutInfoData data) throws GeneralException {
    	return getFields(data, function);
    }    
}