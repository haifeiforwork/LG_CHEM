package	hris.F.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.F.*;

/**
 * F72MajorPeCodeRFC.java
 * ���� �ڵ�, ���� �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2006/03/15
 */
public class F72MajorPeCodeRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_MAJOR_PE";

    /**
     * ���� �ڵ�, ���� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getMajorPe(String FAART) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_FAART", FAART);
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
        String tableName = "TAB";
        return getCodeVector(function, tableName, "FAART", "FTEXT");
    }
}