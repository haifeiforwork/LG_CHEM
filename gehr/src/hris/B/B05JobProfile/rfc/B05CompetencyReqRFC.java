package hris.B.B05JobProfile.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.B.B05JobProfile.*;

/**
 * B05CompetencyReqRFC.java
 * Competency Requirements �󼼳��� ���� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2003/02/12
 */
public class B05CompetencyReqRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_COMPETENCY_REQ";

    public Vector getDetail( String i_objid, String i_sobid ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_objid, i_sobid);
            excute(mConnection, function);

            Vector ret = new Vector();
            
            ret = getOutput(function);
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_objid, String i_sobid ) throws GeneralException {
        String fieldName1 = "I_OBJID";
        setField(function, fieldName1, i_objid);

        String fieldName2 = "I_SOBID";
        setField(function, fieldName2, i_sobid);
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
        
        String entityName1 = "hris.B.B05JobProfile.B05CompetencyReqData";
        Vector P_RESULT    = getTable(entityName1, function, "P_RESULT");
        
        String entityName2 = "hris.B.B05JobProfile.B05CompetencyReqData";
        Vector P_RESULT_Q  = getTable(entityName2, function, "P_RESULT_Q");
        
        String entityName3 = "hris.B.B05JobProfile.B05CompetencyReqData";
        Vector P_RESULT_D  = getTable(entityName3, function, "P_RESULT_D");

        ret.addElement(P_RESULT);
        ret.addElement(P_RESULT_Q);
        ret.addElement(P_RESULT_D);

        return ret;
    }
}

