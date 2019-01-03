/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 상환신청                                           */
/*   Program Name : 주택자금 상환신청                                           */
/*   Program ID   : E06RehouseRequestRFC                                        */
/*   Description  : 개인의 주택자금 상환 신청, 조회, 수정, 삭제를 할 수 있는 Class */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_FUND_REFUND_APP                   */
/*   Creation     : 2005-03-04  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.E.E06Rehouse.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

public class E06RehouseRequestRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_FUND_REFUND_APP";

    /**
     * 개인의 주택자금 상환신청 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String ainf_seqn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "1");
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
     * 주택자금 상환신청 RFC 호출하는 Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String ainf_seqn, Vector rehouse_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);
            
            setInput(function, ainf_seqn, "2");
            setInput(function, rehouse_vt, "T_EXPORTA");
            
            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 주택자금 상환신청 수정 RFC 호출하는 Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public void change(  String ainf_seqn, Vector rehouse_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "3");
            setInput(function, rehouse_vt, "T_EXPORTA");

            excute(mConnection, function);
 
         } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * 주택자금 상환신청 삭제 RFC 호출하는 Method
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
     * @param ainf_seqn java.lang.String 결재정보 일련번호
     * @param conf_type java.lang.String 기초신용평가 유형
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String ainf_seqn, String conf_type ) throws GeneralException {
        String fieldName  = "I_AINF";
        setField( function, fieldName, ainf_seqn );
        String fieldName2 = "I_CONF_TYPE";
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
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E06Rehouse.E06RehouseData";
        return getTable(entityName, function, "T_EXPORTA");
    }
}
