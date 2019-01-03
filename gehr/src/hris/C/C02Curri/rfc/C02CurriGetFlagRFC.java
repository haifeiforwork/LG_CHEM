package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;


/**
 * C02CurriGetFlagRFC.java
 * ��û�ϴ� ������ �Ⱓ�� �ߺ��Ǵ����� üũ�ϴ� Class                        
 *
 * @author  �赵��
 * @version 1.0, 2002/05/25
 */
public class C02CurriGetFlagRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_CHECK_YYMMDD";

    /**
     * �ߺ��Ⱓ üũ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String check( String Pernr, String Begda, String Endda, String Sobid ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, Pernr, Begda, Endda, Sobid );
            excute(mConnection, function);
            
            return getField("YNO_FLAG", function);
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
    private void setInput( JCO.Function function, String Pernr, String Begda, String Endda, String Sobid ) throws GeneralException {
        String fieldName1 = "E_PERNR";
        setField( function, fieldName1, Pernr );
        String fieldName2 = "E_BEGDA";
        setField( function, fieldName2, Begda );
        String fieldName3 = "E_ENDDA";
        setField( function, fieldName3, Endda );
        String fieldName4 = "E_SOBID";
        setField( function, fieldName4, Sobid );
    }
}


