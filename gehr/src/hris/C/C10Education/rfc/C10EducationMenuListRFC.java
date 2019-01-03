package hris.C.C10Education.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C10Education.*;

/**
 * C10EducationMenuListRFC.java
 * ���� ����/�޴� ���� table���� list�� �д´�.
 *
 * @author  �赵��
 * @version 1.0, 2005/05/24
 */
public class C10EducationMenuListRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EDUCATION_MENU_LIST";

    /**
     * @param i_bukrs java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getList( String i_bukrs ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_bukrs);
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
     * @param i_bukrs java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_bukrs) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, i_bukrs );
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
        
        String entityName = "hris.C.C10Education.C10EducationMenuListData";
        
        Vector T_RESULT1  = getTable(entityName, function, "T_RESULT1");
        Vector T_RESULT2  = getTable(entityName, function, "T_RESULT2");
        
        ret.addElement(T_RESULT1);
        ret.addElement(T_RESULT2);
        
        return ret;
    }
}


