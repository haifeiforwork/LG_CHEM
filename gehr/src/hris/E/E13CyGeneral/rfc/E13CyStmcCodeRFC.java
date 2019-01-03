package hris.E.E13CyGeneral.rfc;

import hris.E.E13CyGeneral.E13CyStmcCodeData;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

/**
 * E13StmcCodeRFC.java
 * ���� �̿� ���˻翡 ���� �����͸� �������� RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2013/02/25
 */
public class E13CyStmcCodeRFC extends SAPWrap {

    //private static String functionName = "ZHRH_RFC_STMC_CODE_DF";
    private static String functionName = "ZGHR_RFC_STMC_CODE_DF";

    /**
     * ���˻翡 ���� �����͸� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getStmcCode(String empNo, String hospCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput( function, empNo,  hospCode);
            excute(mConnection, function);
            Vector ret = getTable(E13CyStmcCodeData.class, function, "T_RESULT");//getOutput(function);
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
