package hris.E.E20Congra.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E20Congra.*;

/**
 * E20DisaDisplayRFC.java
 * �������ؽŰ���ȸ RFC �� ȣ���ϴ� Class
 *
 * @author �ڿ���
 * @version 1.0, 2001/12/20
 */
public class E20DisaDisplayRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_DISASTER_DISPLAY";
	private String functionName = "ZGHR_RFC_DISASTER_DISPLAY";

    /**
     * �������ؽŰ���ȸ RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @param CONG_DATE java.lang.String �߻�����
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDisaDisplay( String empNo, String CONG_DATE ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, CONG_DATE);
            excute(mConnection, function);
            Vector ret = getTable(E20DisasterData.class, function, "T_RESULT");

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
     * @param CONG_DATE java.lang.String �߻�����
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String CONG_DATE ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        String fieldName2 = "I_CONG_DATE";
        setField( function, fieldName1, empNo );
        setField( function, fieldName2, CONG_DATE );
    }
}