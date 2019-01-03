package hris.E.E38Cancer.rfc;

import hris.E.E38Cancer.E38CancerStmcCodeData;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

/**
 * E38CancerSeltCodeRFC.java
 * ���� �Ϻ��������ð˻� possible entry RFC �� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2013/06/21 C20130620_53407
 */
public class E38CancerSeltCodeRFC extends SAPWrap {

    //private static String functionName = "ZHRH_RFC_SELT_CODE_N";
    private static String functionName = "ZGHR_RFC_SELT_CODE_N";

    /**
     * �Ϻ��������ð˻� possible entry RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getSeltCode(String empNo, String hospCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,hospCode);
            excute(mConnection, function);
            Vector ret = getTable(E38CancerStmcCodeData.class, function, "T_RESULT");//getOutput(function);

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
    private void setInput(JCO.Function function, String empNo, String hospCode) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_HOSP_CODE";
        setField(function, fieldName2, hospCode);
    }

}


