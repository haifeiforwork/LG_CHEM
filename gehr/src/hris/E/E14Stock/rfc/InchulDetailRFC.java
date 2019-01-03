package hris.E.E14Stock.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E14Stock.*;

/**
 * InchulDetailRFC.java
 * ������ ���� ������ ��ȸ�ϴ�  RFC �� ȣ���ϴ� Class                        
 *
 * @author ������
 * @version 1.0, 2002/01/23
 */
public class InchulDetailRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_JINGUP_DETAIL";

    /**
     * �������ϱ�/���ڱ�/���б� ��ȸ RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInchulList(String empNo, String incsnumb) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, incsnumb );
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String incsnumb ) throws GeneralException {
        String fieldName = "PERNR";
        setField( function, fieldName, empNo );
        String fieldName2 = "INCS_NUMB";
        setField( function, fieldName2, incsnumb );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E14Stock.InchulData";
        String tableName = "TAB";
        return getTable(entityName, function, tableName);
    }
    
}

