package	hris.D.D05Mpay.rfc;

import java.util.Locale;
import java.util.Vector;

import javax.servlet.http.HttpSession;

import com.common.constant.Area;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.common.WebUserData;

/**
 * D05ZocrsnTextRFC.java
 * �޿����� �ڵ�, ���� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ֿ�ȣ
 * @version 1.0, 2002/01/29
 */
public class D05ZocrsnTextRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_ZOCRSN_TEXT"; //ZHRW_RFC_GET_ZOCRSN_TEXT + ZHRW_RFC_GET_ZOCRSN_TEXT_US
    // morga�� �����ϵ��� �����Ǿ���. (KSC)
   	public Vector getZocrsnText(String empNo, String year) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();

            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year);
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
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    private void setInput(JCO.Function function, String value, String value1) throws GeneralException {
        String fieldName  = "I_PERNR";
        String fieldName1  = "I_ZYYMM";
        setField(function, fieldName, value);
        setField(function, fieldName1, value1);
    }

    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D05Mpay.D05ZocrsnTextData";
        String tableName = "T_OCRSN";
 //     return getCodeVector(function, tableName);
        return getTable(entityName, function, tableName);
    }
}