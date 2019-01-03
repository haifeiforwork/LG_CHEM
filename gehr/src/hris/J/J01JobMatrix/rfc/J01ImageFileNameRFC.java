package hris.J.J01JobMatrix.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.J.J01JobMatrix.*;

/**
 * J01ImageFileNameRFC.java
 * Eloffice�� Job Unit�� KSEA, Job Process Image FileName�� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author  �赵��
 * @version 1.0, 2003/02/12
 */
public class J01ImageFileNameRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_IMAGE_FILENAME";

    public Vector getDetail( String i_gubun, String i_objid, String i_sobid, String i_begda ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_gubun, i_objid, i_sobid, i_begda);
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
    private void setInput(JCO.Function function, String i_gubun, String i_objid, String i_sobid, String i_begda ) throws GeneralException {
        String fieldName1 = "I_GUBUN";
        setField(function, fieldName1, i_gubun);

        String fieldName2 = "I_OBJID";
        setField(function, fieldName2, i_objid);

        String fieldName3 = "I_SOBID";
        setField(function, fieldName3, i_sobid);
        
        String fieldName4 = "I_BEGDA";
        setField(function, fieldName4, i_begda);        
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
        String entityName1 = "hris.J.J01JobMatrix.J01ImageFileNameData";
        Vector P_RESULT    = getTable(entityName1, function, "P_RESULT");
        
        String entityName2 = "hris.J.J01JobMatrix.J01ImageFileNameData";
        Vector P_RESULT_P  = getTable(entityName2, function, "P_RESULT_P");
        
        String entityName3 = "hris.J.J01JobMatrix.J01ImageFileNameData";
        Vector P_RESULT_D  = getTable(entityName3, function, "P_RESULT_D");

//      Export ���� ��ȸ
        String fieldName1  = "E_MATCH" ;
        String E_MATCH     = getField(fieldName1, function) ;

        ret.addElement(P_RESULT);
        ret.addElement(P_RESULT_P);
        ret.addElement(P_RESULT_D);
        ret.addElement(E_MATCH);
        
        return ret;
    }
}

