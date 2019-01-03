package hris.J.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

/**
 * J00MenuOpenFlagRFC.java
 * ����� ESS Job Description Menu Open ���θ� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author  �赵��
 * @version 1.0, 2003/06/09
 */
public class J00MenuOpenFlagRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_MENU_OPEN_FLAG";

    public Vector getDetail( String i_pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_pernr);
            excute(mConnection, function);

            Vector ret = new Vector();
            
            ret = getOutput(function);
            
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
    private void setInput(JCO.Function function, String i_pernr ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, i_pernr);
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
        String fieldName1  = "E_MENU_1" ;           //Job Description Menu Open ����
        String E_MENU_1    = getField(fieldName1, function) ;

        String fieldName2  = "E_MENU_2" ;           //���� Job Description ��ȸ Menu Open ����
        String E_MENU_2    = getField(fieldName2, function) ;

        String fieldName3  = "E_MENU_3" ;           //Job Description ��ȸ������������ Menu Open ����
        String E_MENU_3    = getField(fieldName3, function) ;

        ret.addElement(E_MENU_1);
        ret.addElement(E_MENU_2);
        ret.addElement(E_MENU_3);

        return ret;
    }
}

