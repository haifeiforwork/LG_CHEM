package hris.E.E10Personal.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E10Personal.*;

/**
 * GuenCodeRFC.java
 * �����ΰ� ���� �������� RFC�� ȣ���ϴ� Class
 *
 * @author ������   
 * @version 1.0, 2001/12/13
 */
public class InsureCodeRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_P_PENTION_INSURE";   

    /**
     *  �����ڵ� �������� RFC�� ȣ���ϴ� Method
     *  @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInsureCode() throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

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
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "IT";      // RFC Export ������� ����
        return getCodeVector( function,tableName, "BANK_TYPE", "BANK_TEXT");
    }
}



