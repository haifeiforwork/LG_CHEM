package hris.E.E01Medicare.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E01Medicare.*;

/**
 * E01HealthGuarHintchRFC.java
 * �ǰ����� �Ǻξ��� ����� ���� ��ȣ �ؽ�Ʈ�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/02/29
 */
public class E01HealthGuarHintchRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_P_HEATH_GUAR_HINTCH";
	private String functionName = "ZGHR_RFC_P_HEATH_GUAR_HINTCH";

    /**
     * �ǰ����� �Ǻξ��� �ڰ� ��� ������ �������� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getHealthGuarHintch() throws GeneralException {

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
        return getCodeVector(function, tableName, "HITCH_TYPE", "HITCH_TEXT");
    }
}