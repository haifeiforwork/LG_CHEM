package hris.E.E19Disaster.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E19Disaster.*;

/**
 * E19CongMoreRelaRFC.java
 * ������ ���� ���� �߰� �����͸� �������� RFC �� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2001/12/18
 */
public class E19CongMoreRelaRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_CONGCOND_COMMWAGE";
	private String functionName = "ZGHR_RFC_CONGCOND_COMMWAGE";

    /**
     * ������ ���� ���� �߰� �����͸� �������� RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCongMoreRela( String empNo, String beginDate ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, beginDate);
            excute(mConnection, function);
            Vector ret =   getTable(E19CongcondData.class,function, "T_RESULT");

            for ( int i = 0 ; i < ret.size() ; i++ ) {
                E19CongcondData data = (E19CongcondData)ret.get(i);
                data.WAGE_WONX = Double.toString(Double.parseDouble(data.WAGE_WONX) * 100.0 ) ; // ������
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
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String beginDate ) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
        fieldName = "I_BEGDA";
        setField( function, fieldName, beginDate );
    }

}

