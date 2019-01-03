package	hris.D.D03Vocation.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.*;

/**
 * D03OvertimeCodeRFC.java
 * ���������ڵ带 �������� RFC�� ȣ���ϴ� Class
 *
 * @author LSA    
 * @version 1.0, 2006/01/18
 */
public class D03OvertimeCodeRFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_OVERTIME_CODE";

    /**
     * ���������ڵ带 �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getOvertimeCode( String burks, String menu_code ) throws GeneralException {
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, burks, menu_code);
            excute(mConnection, function);
            
            Vector ret = null;
            ret = getOutput(function);            
            return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
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
    private void setInput(JCO.Function function, String value, String value1) throws GeneralException {
        String fieldName  = "I_BUKRS";
        String fieldName1 = "I_MENU_CODE";
        setField(function, fieldName, value);
        setField(function, fieldName1, value1);
        
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

        String entityName1 = "hris.D.D03Vocation.D03OvertimeCodeData";
        Vector L_ZHRC108T = getTable(entityName1, function, "T_RESULT");
        String entityName2 = "hris.D.D03Vocation.D03OvertimeCode2Data";
        Vector L_ZHRC109T = getTable(entityName2, function, "T_RESULT2");
        String entityName3 = "hris.D.D03Vocation.D03OvertimeCode3Data";
        Vector L_ZHRC110T = getTable(entityName3, function, "T_RESULT3");
        // �ʰ��ٹ�/�ް� �����ؽ�Ʈ 1            
        // �ʰ��ٹ�/�ް� �����ؽ�Ʈ 2            
        // �ʰ��ٹ�/�ް� �����ؽ�Ʈ 3
        ret.addElement(L_ZHRC108T);
        ret.addElement(L_ZHRC109T);
        ret.addElement(L_ZHRC110T);

        return ret ;

    }
}