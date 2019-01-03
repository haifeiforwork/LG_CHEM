package	hris.D.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.*;

/**
 * D04VocationDetailN100RFC.java
 * ������ �ް���Ȳ ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �赵�� - ����ȭ�� ����
 * @version 1.0, 2004/09/16
 */
public class D04VocationDetailN100RFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_HOLIDAY_DISPLAY_N";

    /**
     * ������ �ް���Ȳ ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getVocationDetail( String empNo, String year ) throws GeneralException {
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year);
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
        String fieldName  = "P_PERNR";
        String fieldName1 = "P_YEAR";
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
        
//      Export ���� ��ȸ
        String fieldName1      = "P_NON_ABSENCE";      // ���ٿ�����
        String P_NON_ABSENCE   = getField(fieldName1, function) ;

        String fieldName2      = "P_LONG_SERVICE";     // �ټӿ�����
        String P_LONG_SERVICE  = getField(fieldName2, function) ;
        
        String fieldName3      = "P_COMPEN_CNT";       // ���� �����
        String P_COMPEN_CNT    = getField(fieldName3, function) ;
        
//      Table ��� ��ȸ
        String entityName      = "hris.D.D04VocationDetail1Data";
        Vector P_OCCUR_RESULT  = getTable(entityName,  function, "P_OCCUR_RESULT");

        String entityName1     = "hris.D.D04VocationDetail1Data";
        Vector P_OCCUR_RESULT1 = getTable(entityName1, function, "P_OCCUR_RESULT1");

        String entityName2     = "hris.D.D04VocationDetail1Data";
        Vector P_OCCUR_RESULT2 = getTable(entityName2, function, "P_OCCUR_RESULT2");
        
        String entityName3     = "hris.D.D04VocationDetail2Data";
        Vector P_USED_RESULT   = getTable(entityName3, function, "P_USED_RESULT");

        String entityName4     = "hris.D.D04VocationDetail2Data";
        Vector P_USED_RESULT1  = getTable(entityName4, function, "P_USED_RESULT1");

        String entityName5     = "hris.D.D04VocationDetail2Data";
        Vector P_USED_RESULT2  = getTable(entityName5, function, "P_USED_RESULT2");
        
        ret.addElement(P_NON_ABSENCE);
        ret.addElement(P_LONG_SERVICE);
        ret.addElement(P_OCCUR_RESULT);
        ret.addElement(P_OCCUR_RESULT1);
        ret.addElement(P_OCCUR_RESULT2);
        ret.addElement(P_USED_RESULT);
        ret.addElement(P_USED_RESULT1);
        ret.addElement(P_USED_RESULT2);
        ret.addElement(P_COMPEN_CNT);

        return ret;
    }

}
