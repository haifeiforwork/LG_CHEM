package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.common.*;

/**
 * EpMyMenuRFC.java
 * ���Ѻ� �������� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author ��α�
 * @version 1.0, 2005/10/02
 */
public class EpMyMenuRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_AUTH_SABUN";

    public Vector getDetail() throws GeneralException {

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
        String entityName = "hris.common.EpMyMenuData";
        String tableName  = "T_AUTH_SABUN";
        return getTable(entityName, function, tableName);
    }

}

