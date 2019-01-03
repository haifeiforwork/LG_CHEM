package hris.E.E29PensionDetail.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E29PensionDetail.*;

/**
 * PensionTotalRFC.java
 * ���ο��ݴ��� ������ ��ȸ�ϴ� RFC �� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2002/01/29
 */
public class E29PensionTotalRFC extends SAPWrap {

    //private String functionName = "ZHRW_PENSION_TOTAL_DISPLAY";
	private String functionName = "ZGHR_PENSION_TOTAL_DISPLAY";

    /**
     * ���ο��ݴ��� ���� ��ȸ RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.object PensionDetailData
     * @exception com.sns.jdf.GeneralException
     */

    public E29PensionDetailData getPension( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);
            E29PensionDetailData ret = (E29PensionDetailData)getFields(new E29PensionDetailData() ,function);

            ret.E_MY_PAYMENT    = Double.toString(Double.parseDouble(ret.E_MY_PAYMENT ) * 100.0 );
            ret.E_FIRM_PAYMENT = Double.toString(Double.parseDouble(ret.E_FIRM_PAYMENT) * 100.0 );
            ret.E_TOTAL_PAYMENT     = Double.toString(Double.parseDouble(ret.E_TOTAL_PAYMENT) * 100.0 );
            ret.E_RETIRE_PAYMENT = Double.toString(Double.parseDouble(ret.E_RETIRE_PAYMENT) * 100.0 );
            ret.E_PENI_AMNT = Double.toString(Double.parseDouble(ret.E_PENI_AMNT) * 100.0 );
            ret.E_PENC_AMNT = Double.toString(Double.parseDouble(ret.E_PENC_AMNT) * 100.0 );
            ret.E_PENB_AMNT = Double.toString(Double.parseDouble(ret.E_PENB_AMNT) * 100.0 );

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
    private void setInput(JCO.Function function, String empNo ) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );

    }

}
