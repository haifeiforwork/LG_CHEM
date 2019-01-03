package hris.C.C03EventCancel.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*; 
import com.sap.mw.jco.*; 
import hris.C.C03EventCancel.*;


/**
 * C03EventCancelApplRFC.java
 * �������� ��ҽ�û ��ȸ/��û/����/���� RFC �� ȣ���ϴ� Class                        
 *
 * @author lsa
 * @version 1.0, 2013/06/15 ������ҽ�û ���� �߰� | [��û��ȣ]C20130627_58399
 */
public class C03EventCancelApplRFC extends SAPWrap {

    private String functionName = "ZHRD_RFC_EVENT_CANCLE_APPROVAL";

    /**
     * �������� ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param  java.lang.String �����ȣ
	 * @param  java.lang.String �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail( String ainfSeqn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, ainfSeqn, "1");
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
	 * @param java.lang.String �����ȣ
     * @param java.lang.String �������� �Ϸù�ȣ
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key, String job) throws GeneralException {
        String fieldName = "P_AINF_SEQN";
        setField( function, fieldName, key );
        String fieldName1 = "P_CONF_TYPE";
        setField( function, fieldName1, job );

    }
 
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @param tableName java.util.Vector
     * @param prev java.lang.String
     * @exception com.sns.jdf.GeneralException
     */

    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C03EventCancel.C03EventCancelData";
        Vector  ret = getTable(entityName, function, "P_EVENT");
        return ret ;
    }
}


