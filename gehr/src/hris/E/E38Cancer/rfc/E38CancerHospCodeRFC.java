package hris.E.E38Cancer.rfc;

import hris.E.E38Cancer.E38CancerData;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

/**
 * E38CancerHospCodeRFC.java
 *   �� ���������� ���� �����͸� �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2013/06/21 C20130620_53407
 */
public class E38CancerHospCodeRFC extends SAPWrap {

    //private static String functionName = "ZHRH_RFC_P_HOSP_CODE_N";
    private static String functionName = "ZGHR_RFC_P_HOSP_CODE_N";

    /**
     * ���������� ���� �����͸� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getHospCode(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput( function, empNo );
            excute(mConnection, function);
            Vector ret = getTable(E38CancerData.class, function, "T_RESULT");   //getOutput(function);
            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
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
    private void setInput(JCO.Function function, String value) throws GeneralException {
        String fieldName = "I_PERNR";
        setField(function, fieldName, value);
    }

}

