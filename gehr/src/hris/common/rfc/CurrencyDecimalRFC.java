package hris.common.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * CurrencyDecimalRFC.java
 * ��ȭŰ���� �Ҽ��ڸ����� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/02/15
 */
public class CurrencyDecimalRFC extends SAPWrap {

    //private String functionName = "ZHRW_GET_MONETARY_UNIT";
    private String functionName = "ZGHR_GET_MONETARY_UNIT";

    /**
     *  ��ȭŰ���� �Ҽ��ڸ����� �������� RFC�� ȣ���ϴ� Method
     *  @return java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getCurrencyDecimal() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            Vector ret = getCodeVector( function, "T_RESULT", "CURRKEY", "CURRDEC" );//getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        //String tableName  = "T_RESULT";      // RFC Export ������� ����
        //String codeField  = "CURRKEY";
        //String valueField = "CURRDEC";
        return getCodeVector( function, "T_RESULT", "CURRKEY", "CURRDEC" );
    }
}


