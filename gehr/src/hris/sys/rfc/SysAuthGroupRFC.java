/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �޴�                                                        */
/*   Program Name : �޴�                                                        */
/*   Program ID   : SysAuthGroupRFC.java                                        */
/*   Description  : �޴� ��� ��������                                          */
/*   Note         : [���� RFC] : ZHRC_RFC_GET_AUTHGROUP                         */
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
     * �޴� ��� �������� RFC�� ȣ���ϴ� Method
     * @param companyCode java.lang.String ȸ���ڵ�
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String AUTHORIZATION) throws GeneralException {
        String fieldName = "AUTHORIZATION";
        setField( function, fieldName, AUTHORIZATION );
		    
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
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
