package hris.E.E01Medicare.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E01Medicare.*;

/**
 * E01HealthGuarAccqRFC.java
 * �ǰ����� �Ǻξ��� �ڰ� ��� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/02/29
 */
public class E01HealthGuarAccqRFC extends SAPWrap {

   // private String functionName = "ZHRW_RFC_P_HEALTH_GUAR_ACCQ";
	 private String functionName = "ZGHR_RFC_P_HEALTH_GUAR_ACCQ";

    /**
     * �ǰ����� �Ǻξ��� �ڰ� ��� ������ �������� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getHealthGuarAccq() throws GeneralException {

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
        String tableName = "T_RESULT";
        return getCodeVector(function, tableName, "ACCQ_LOSS_TYPE", "ACCQ_LOSS_TEXT");
    }
}