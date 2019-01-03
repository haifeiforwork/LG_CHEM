package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriPreChkRFC.java
 * ���� �ڰ� ���ǳ����� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ڿ���   
 * @version 1.0, 2002/01/16
 */
public class C02CurriPreChkRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_PRE_EVENT_CHECK";

    /**
     * �����ڰݿ�� ���븦 �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����ȣ
     * @return java.util.Vector �����ڰݿ��
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCurriPreCheck( String PERNR , Vector PLAN ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, PERNR, PLAN );
            excute(mConnection, function);
            Vector ret = getOutput(function);
            return ret;

        } catch(Exception ex) {
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
     * @param java.lang.String �����ȣ
     * @param java.util.Vector �����ڰݿ��
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1, Vector entityVector )  throws GeneralException{
        String fieldName = "PERNR";
        setField(function, fieldName, key1);
        setTable(function, "PRE_EVENT", entityVector);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C02Curri.C02CurriCheckData";
        return getTable(entityName, function, "PP_PLAN");
    }
}
