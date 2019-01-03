package hris.D.D03Vocation.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.D.D03Vocation.*;


/**
 * D03ShiftCheckRFC.java
 * ��ġ����ٹ������� üũ�ϴ� Class                        
 *
 * @author  �赵��
 * @version 1.0, 2002/05/29
 */
public class D03ShiftCheckRFC extends SAPWrap {

//    private String functionName = "ZHRW_RFC_SHIFT_CHECK";
    private String functionName = "ZGHR_RFC_SHIFT_CHECK";

    /**
     * ��ġ����ٹ��� üũ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String check( String i_pernr, String i_date ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, i_pernr, i_date );
            excute(mConnection, function);
            
            return getField("E_FLAG", function);
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

