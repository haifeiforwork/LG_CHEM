package hris.D.D03Vocation.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.D.D03Vocation.*;


/**
 * D03MinusRestRFC.java
 * ���̳ʽ� �ް��� ��û�Ҽ� �ִ� ����� ���̳ʽ� �ް� �Ѱ踦 ��ȸ�ϴ� Class                        
 *
 * @author  �赵��
 * @version 1.0, 2002/05/29
 */
public class D03MinusRestRFC extends SAPWrap {

//    private String functionName = "ZHRW_RFC_MINUS_REST";
    private String functionName = "ZGHR_RFC_MINUS_REST";

    /**
     * ��ġ����ٹ��� üũ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String check( String i_pernr, String i_bukrs, String i_date ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, i_pernr, i_date );
            excute(mConnection, function);
            
            String urlzk = getField("E_URLZK", function);
//          ���̳ʽ� �ް� ������ ��� - ����ȭ���� ��� ��� ����� ���ؼ� ���̳ʽ� �ް� ��û �����ϴ�.
            if( i_bukrs.equals("N100") || (i_bukrs.equals("C100") && urlzk.equals("3")) ) {
                return getField("E_QTNEG", function);       // ���̳ʽ� �ް� �Ѱ� ��
            } else {
                return "0";
            }
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    public String getE_ANZHL( String i_pernr, String i_date ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, i_pernr, i_date );
            excute(mConnection, function);
            
            String anzhl = getField("E_ANZHL", function);
            return anzhl;
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
    private void setInput( JCO.Function function, String i_pernr, String i_date ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, i_pernr );
        String fieldName2 = "I_DATE";
        setField( function, fieldName2, i_date );
    }
}


