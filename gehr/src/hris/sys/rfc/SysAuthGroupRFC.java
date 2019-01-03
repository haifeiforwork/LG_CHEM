/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 메뉴                                                        */
/*   Program Name : 메뉴                                                        */
/*   Program ID   : SysAuthGroupRFC.java                                        */
/*   Description  : 메뉴 목록 가져오기                                          */
/*   Note         : [관련 RFC] : ZHRC_RFC_GET_AUTHGROUP                         */
/*   Creation     : 2007-04-16  lsa                                             */
/*   Update       : CSR ID:C20140106_63914    */
/*                                                                              */
/********************************************************************************/

package hris.sys.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

public class SysAuthGroupRFC extends SAPWrap {

    private String functionName = "ZHRC_RFC_GET_AUTHGROUP";

    /**
     * 메뉴 목록 가져오는 RFC를 호출하는 Method
     * @param companyCode java.lang.String 회사코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String getAuthGroup(String AUTHORIZATION) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, AUTHORIZATION);
            excute(mConnection, function);
            Vector ret = new Vector();
            ret = getOutput(function);  

            SysAuthGroupData retData = new SysAuthGroupData();  
            
            if (ret.size()>0){
            	//SysAuthGroupData retData = (SysAuthGroupData)ret.get(0); //C20140106_63914
            	retData = (SysAuthGroupData)ret.get(0);
            }else{
            	retData.DETAILCODE = ""; 
            }
            
            return retData.DETAILCODE;
            
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
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String AUTHORIZATION) throws GeneralException {
        String fieldName = "AUTHORIZATION";
        setField( function, fieldName, AUTHORIZATION );
		    
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.sys.SysAuthGroupData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }
}
