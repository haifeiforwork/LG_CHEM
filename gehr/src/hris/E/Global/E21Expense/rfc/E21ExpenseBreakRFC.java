package hris.E.Global.E21Expense.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E21Expense.*;

/**
 * E21ExpenseBreakRFC.java
 * ���ڱ�/���б� ��û�� �����Ⱓ�� üũ Class
 *
 * @author �ֿ�ȣ
 * @version 1.0, 2003/06/18
 */
public class E21ExpenseBreakRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_BREAK_CHK";


    public String check( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, empNo );
            excute(mConnection, function);

            String I_FLAG = null;

            I_FLAG = getOutput(function);

            return I_FLAG;

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param P_AINF_SEQN java.lang.String �������� �Ϸù�ȣ
     * @param empNo java.lang.String �����ȣ
     * @param job java.lang.String ���ʽſ��� ����
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String empNo ) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }

   /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput(JCO.Function function) throws GeneralException {
        String fieldName = "I_FLAG";      // ������
        return getField(fieldName, function);
    }

}


