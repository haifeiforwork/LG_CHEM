package hris.E.E19Congra.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E19Congra.*;

/**
 * E19CongraDupCheckRFC.java
 * �����ݽ�û�� �ߺ� ��û�� �����ֱ����ؼ� INFOTYPE, TEMP_TABLE�� �̹� ��û�� ���� �о�´�.
 *
 * @author  �赵��
 * @version 1.0, 2003/02/20
 */
public class E19CongraDupCheckRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_CONGRA_DUP_CHECK";
	private String functionName = "ZGHR_RFC_CONGRA_DUP_CHECK";

    /**
     * ��������ȸ RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCheckList( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);

            Vector ret =  getTable(E19CongraDupCheckData.class, function, "T_RESULT");

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
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }


}


