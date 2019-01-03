package	hris.E.E10Personal.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E10Personal.*;

/**
 * E10PentionMoneyRFC.java
 * ���ο���/���̶����� ������ ��ȸ�ϴ� RFC�� ȣ���ϴ� class
 *
 * @author �赵��
 * @version 1.0, 2002/10/10
 */
public class E10PentionMoneyRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_PENTION_MONEY";

    /**
     * ���ο���/���̶����� ��û,����,��ȸ �ϴ� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����Ϸù�ȣ 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPentionMoney( String i_bukrs, String i_date, String i_gubun ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_bukrs, i_date, i_gubun);
            
            excute(mConnection, function);
            
            Vector ret = getOutput(function);
            
            if( ret.size() > 0 ) {
                E10PentionMoneyData data = (E10PentionMoneyData)ret.get(0);
            
                data.DEDUCT   = Double.toString(Double.parseDouble(data.DEDUCT) * 100.0 );
                data.ASSIST   = Double.toString(Double.parseDouble(data.ASSIST) * 100.0 );
                data.DISCOUNT = Double.toString(Double.parseDouble(data.DISCOUNT) * 100.0 );
            }
     
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
     * @param value java.lang.String �����Ϸù�ȣ java.lang.String �۾����� java.lang.String ���� �� Ż�𿩺� �ڵ� 
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String i_bukrs, String i_date, String i_gubun ) throws GeneralException {
        String fieldName1 = "I_BUKRS";
        setField(function, fieldName1, i_bukrs);
        
        String fieldName2 = "I_DATE" ;
        setField(function, fieldName2, i_date) ;
                
        String fieldName3 = "I_GUBUN";
        setField(function, fieldName3, i_gubun);
    }


// Import Parameter �� Vector(Table) �� ���
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E10Personal.E10PentionMoneyData";
        String tableName  = "IT";
        return getTable(entityName, function, tableName);
    }
}


