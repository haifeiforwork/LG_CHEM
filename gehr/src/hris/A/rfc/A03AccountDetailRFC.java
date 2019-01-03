package	hris.A.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.A.A03AccountDetail1Data;

/**
 * A03AccountDetailRFC.java
 * ������� ��ȸ ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/07
 */
public class A03AccountDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_BANK_STOCK_LIST";

    /**
     * �޿����������� �������� �ؿ�RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getAccountDetail(String keycode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode);
            
            excute(mConnection, function);
            
            Vector ret = null;
            ret = getOutputGlobal(function);
//            20160204 start
            if(ret.size()!=0){
            A03AccountDetail1Data ret1 = new A03AccountDetail1Data();
            	ret1 = (A03AccountDetail1Data)ret.get(0);
                ret1.VORNA = ret1.VORNA.replaceAll("#", " ");
                ret.set(0, ret1) ;
            }
            
//            20160204 end
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �޿����������� �������� ��������RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getAccountDetail(String keycode, String flag) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode);
            
            excute(mConnection, function);
            
            Vector ret = null;
            
            if( flag == "10" ) {			// �޿�����
              ret = getOutput(function);
            } else if( flag == "08" ) {		// ���ǰ���
              ret = getOutput1(function);
            } else if( flag == "05" ) {		// F/B���ΰ���
			  ret = getOutput2(function);
			}
            
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
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode) throws GeneralException {
        String fieldName1 = "I_PERNR"            ;
        setField(function, fieldName1, keycode);
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutputGlobal(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A03AccountDetail1Data";
        String tableName  = "T_ITAB"; // Global
        return getTable(entityName, function, tableName);
    }
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A03AccountDetail1Data";
        String tableName  = "T_RESULT";  // Local
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A03AccountDetail2Data";
        String tableName  = "T_RESULT1";// Local
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput2(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A03AccountDetail3Data";
        String tableName  = "T_RESULT2";// Local
        return getTable(entityName, function, tableName);
    }
}