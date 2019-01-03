package hris.common.rfc ;
import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
/**
 * ManageInfoRFC.java
 * 경조금,회갑관리담당자/FAQ 관리권한자 조회 RFC를 호출하는 Class
 *
 * @author 손혜영
 * @version 1.0, 2013/09/20
 */
public class ManageInfoRFC extends SAPWrap {
    private static String functionName = "ZHRA_RFC_GET_MANAGE_INFO" ; 
    /**
     * 경조금,회갑관리담당자/FAQ 관리권한자 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector getManageInfo(String gubun) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, gubun);		//업무구분 01:경조금 회갑 관리 담당자, 02:FAQ 관리 권한자	
            excute(mConnection, function);              Vector ret = getOutput(function);            return ret;
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
    private void setInput(JCO.Function function, String gubun) throws GeneralException {
        String fieldName1 = "I_GUBUN";
        setField( function, fieldName1, gubun );
    }    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.common.ManageInfoData";
        String tableName  = "T_EXPORT";
        return getTable(entityName, function, tableName);
    }
}