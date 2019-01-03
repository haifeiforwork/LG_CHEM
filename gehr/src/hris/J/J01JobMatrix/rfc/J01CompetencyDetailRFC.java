package hris.J.J01JobMatrix.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.J.J01JobMatrix.*;

/**
 * J01CompetencyDetailRFC.java
 * Competency �󼼳����� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2003/05/13
 */
public class J01CompetencyDetailRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_COMPETENCY_DETAIL";

    public Vector getDetail( String i_objid, String i_begda ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_objid, i_begda);
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
    private void setInput(JCO.Function function, String i_objid, String i_begda ) throws GeneralException {
        String fieldName1 = "I_OBJID";
        setField(function, fieldName1, i_objid);

        String fieldName2 = "I_BEGDA";
        setField(function, fieldName2, i_begda);        
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
        
        String entityName1 = "hris.J.J01JobMatrix.J01CompetencyDetailData";
        Vector P_RESULT    = getTable(entityName1, function, "P_RESULT");
        
        String entityName2 = "hris.J.J01JobMatrix.J01CompetencyDetailData";
        Vector P_RESULT_D  = getTable(entityName2, function, "P_RESULT_D");

        String fieldName1  = "E_STEXT_Q" ;
        String E_STEXT_Q   = getField( fieldName1, function ) ;

        ret.addElement(P_RESULT);
        ret.addElement(P_RESULT_D);
        ret.addElement(E_STEXT_Q);

        return ret;
    }
  
}

