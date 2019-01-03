package hris.J.J03JobCreate.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * J03RequireLevelRFC.java
 * �����Ͻ� ����Ʈ �䱸���� RFC�� ȣ���ϴ� Class
 *
 * @author  ������   
 * @version 1.0, 2003/06/16
 */
public class J03RequireLevelRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_REQUIRE_LEVEL";   

    /**
     *  �����Ͻ� ����Ʈ �䱸���� RFC�� ȣ���ϴ� Method
     *  @return java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
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
        Vector ret = new Vector();
        
//      Table ��� ��ȸ
        String entityName1 = "hris.J.J03JobCreate.J03RequireLevelData";
        Vector L_RESULT    = getTable(entityName1, function, "L_RESULT");        

//      Table ��� ��ȸ
        String entityName2 = "hris.J.J03JobCreate.J03QKData";
        Vector QK_RESULT    = getTable(entityName2, function, "QK_RESULT");        
        
        ret.addElement(L_RESULT);
        ret.addElement(QK_RESULT);                      
        return ret;
    }
}


