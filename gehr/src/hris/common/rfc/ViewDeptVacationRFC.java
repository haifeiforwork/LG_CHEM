/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : �μ��ް���Ȳ                                                */
/*   Program ID   : ViewDeptVacationRFC                                         */
/*   Description  : �ʱ�ȭ�鿡�� �μ� �ް� ��Ȳ�� ���� RFC ����                 */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-17 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

 
/**
 * ViewDeptVacationRFC
 * �ʱ�ȭ�鿡�� �μ� �ް� ��Ȳ�� ���� RFC�� ȣ���ϴ� Class
 *
 * @author �����   
 * @version 1.0, 2005/03/17
 */
public class ViewDeptVacationRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_ORGEH_HOLI_RATE";

    /**
     * �μ��ڵ����� �ް������� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Object getDeptVacation( String i_deptid, String i_lower ) throws GeneralException {
        
        JCO.Client mConnection = null; 
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_deptid, i_lower);
            excute(mConnection, function);
            Object ret = getOutput(function);
             
            return ret;
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_deptid, String i_lower) throws GeneralException {
        String fieldName1  = "I_ORGEH";
        setField(function, fieldName1,  i_deptid);
        String fieldName2  = "I_LOWERYN";
        setField(function, fieldName2,  i_lower);
    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	// Table ��� ��ȸ
        String entityName = "hris.common.ViewDeptVacationData";
        String tableName = "T_EXPORT";
        return getTable(entityName, function, tableName);
    }
}


