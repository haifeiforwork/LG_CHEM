/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : �ް���Ȳ                                                    */
/*   Program ID   : ViewEmpVacationRFC                                          */
/*   Description  : �ʱ�ȭ�鿡�� ��� �ް� ��Ȳ�� ���� RFC ����                 */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-03 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common.rfc;

import hris.common.ViewEmpVacationData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

 
/**
 * ViewEmpVacationRFC
 * �ʱ�ȭ�鿡�� ��� �ް� ��Ȳ�� ���� RFC�� ȣ���ϴ� Class
 *
 * @author �����   
 * @version 1.0, 2005/03/03
 */
public class ViewEmpVacationRFC extends SAPWrap {

    private String functionName = "ZHRP_GET_NO_OF_WORKDAY";

    /**
     * ������� �ް������� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String ���
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Object getEmpVacation( String i_empId ) throws GeneralException {
        
        JCO.Client mConnection = null; 
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_empId);
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
    private void setInput(JCO.Function function, String i_empId) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName,  i_empId);
    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Object getOutput(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
 
    	// Table ��� ��ȸ
    	ViewEmpVacationData vacation = new ViewEmpVacationData();
    	Object E_WORK  = getStructor(vacation,  function, "E_WORK"); 
    	
    	return E_WORK;
    }
}


