package hris.E.E28General.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E28General.*;


/**
 * E28GeneralCancerListRFC.java
 * 7���ϰ��� �ǽó����� ������ RFC �� ȣ���ϴ� Class
 *
 * @author lsa C20130805_81825
 * @version 1.0, 2013/08/05
 */
public class E28GeneralCancerListRFC extends SAPWrap {

   // private String functionName = "ZHRH_RFC_HOSP_DISPLAY_N";
	 private String functionName = "ZGHR_RFC_HOSP_DISPLAY_N";

    /**
     * 7���ϰ��� �ǽó��� ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param java.lang.String
     * @param java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getGeneralList( String PERNR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, PERNR);
            excute(mConnection, function);
            Vector ret = getTable(E28GeneralCancerData.class, function, "T_RESULT");
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
	 * @param java.lang.String
     * @param java.lang.String
     * @param job java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String key1 ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, key1 );
    }

}


