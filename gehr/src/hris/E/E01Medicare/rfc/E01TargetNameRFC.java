package hris.E.E01Medicare.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E01Medicare.*;

/**
 * E01TargetNameRFC.java
 * �ǰ����� �Ǻξ��� �ڰ�(���/���) ��û�� �̸� possible entry�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ڿ���
 * @version 1.0, 2002/02/28
 */
public class E01TargetNameRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_P_GET_TARGET_NAME";

    /**
     * �ǰ������� ����� �̸��� �������� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getTargetName( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, empNo );
            excute(mConnection, function);
            Vector ret = getTable(E01TargetNameData.class, function, "T_RESULT");
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
    }

}