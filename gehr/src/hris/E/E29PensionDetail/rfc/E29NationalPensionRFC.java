package hris.E.E29PensionDetail.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E29PensionDetail.*;

/**
 * NationalPensionRFC.java
 * �⵵�� �󼼳����� ��ȸ�ϴ� RFC �� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2002/01/29
 */
public class E29NationalPensionRFC extends SAPWrap {

    //private String functionName = "ZHRW_NATIONAL_PENSION_DISPLAY";
	private String functionName = "ZGHR_NATIONAL_PENSION_DISPLAY";

    /**
     * ���ο��� �⵵�� ��ȸ RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @param empNo java.lang.String ��ȸ����
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getNationalList( String empNo, String year ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year);
            excute(mConnection, function);
            Vector ret = getTable(E29PensionDetailData.class, function, "T_RESULT");
            for ( int i = 0 ; i < ret.size() ; i++ ) {
                E29PensionDetailData data = (E29PensionDetailData)ret.get(i);
                data.BETRG = Double.toString( Double.parseDouble(data.BETRG) * 100.0 ) ;
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
     * @param empNo java.lang.String ��ȸ����
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String year) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
        String fieldName1= "I_YEAR";
        setField( function, fieldName1, year );
    }

 }

