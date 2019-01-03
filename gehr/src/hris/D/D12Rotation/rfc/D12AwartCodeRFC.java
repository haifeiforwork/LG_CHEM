package hris.D.D12Rotation.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D12Rotation.*;

/**
 * D12AwartCodeRFC.JAVA
 * �޹����� �����͸� �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2008/11/10
 */
public class D12AwartCodeRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_AWART";
      private String functionName = "ZGHR_RFC_AWART";


    /**
     * �ް� ���� �����͸� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAwartCode() throws GeneralException {

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
        String entityName = "hris.D.D12Rotation.D12AwartData";
        String tableName  = "T_RESULT";
        return getTable(entityName, function, tableName);
    }
}

