package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriInfoRFC.java
 * ���� �������� �̺�Ʈ���� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ڿ���   
 * @version 1.0, 2002/01/14
 */
public class C02CurriInfoRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EVENT_INFORM2";

    /**
     * ���� �������� ���븦 �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.Object hris.C.C02Curri.C02CurriInfoData Object.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCurriInfo( String OBJID, String SOBID ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, OBJID, SOBID );
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
     * @param java.lang.String OBJID ������ƮID
     * @param java.lang.String SOBID ���ÿ�����ƮID
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1, String key2) throws GeneralException{
        String fieldName1 = "P_OBJID";
        setField(function, fieldName1, key1);
        String fieldName2 = "P_SOBID";
        setField(function, fieldName2, key2);
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
        
        String entityName1 = "hris.C.C02Curri.C02CurriEventInfoData";//�̺�Ʈ�����ȳ�����
        Vector P_EVENT_INFORM = getTable(entityName1, function, "P_EVENT_INFORM");
        
        String entityName2 = "hris.C.C02Curri.C02CurriEventData";//�̺�Ʈ��������
        Vector P_EVENT_TYPE = getTable(entityName2, function, "P_EVENT_TYPE");
        
        String entityName3 = "hris.C.C02Curri.C02CurriData";//���̼�����
        Vector P_PRE_COURSE = getTable(entityName3, function, "P_PRE_COURSE");
        
        String entityName4 = "hris.C.C02Curri.C02CurriData";//�ڰݿ��ȹ��
        Vector P_PRE_GET = getTable(entityName4, function, "P_PRE_GET");
        
        String entityName5 = "hris.C.C02Curri.C02CurriData";//�����ڰݿ��
        Vector P_PRE_GRANT = getTable(entityName5, function, "P_PRE_GRANT");

        ret.addElement(P_EVENT_INFORM);
        ret.addElement(P_EVENT_TYPE);
        ret.addElement(P_PRE_COURSE);
        ret.addElement(P_PRE_GET);
        ret.addElement(P_PRE_GRANT);

        return ret;
    }
}
