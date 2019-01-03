package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriPersonRFC.java
 * ���������� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author �ڿ���   
 * @version 1.0, 2002/01/15
 */
public class C02CurriPersonRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_PERSON_INFORM";

    /**
     * ���������� ��ȸ�ϴ� RFC�� ȣ���ϴ� Method
     * @param java.lang.Object hris.C.C02Curri.C02CurriInfoData Object.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCurriPerson( String PERNR ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, PERNR );
            excute(mConnection, function);
            return getOutput(function);

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
    private void setInput(JCO.Function function, String key1 ) throws GeneralException{
        String fieldName1 = "PERNR";
        setField(function, fieldName1, key1);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        
        String entityName1 = "hris.C.C02Curri.C02CurriPersonData";
        Vector ret = getTable(entityName1, function, "P_PERSON");
        return ret;
    }
}
