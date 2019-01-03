package hris.E.E29PensionDetail.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E29PensionDetail.*;

/**
 * PensionTotalRFC.java
 * 국민연금누계 내역을 조회하는 RFC 를 호출하는 Class
 *
 * @author 이형석
 * @version 1.0, 2002/01/29
 */
public class E29PensionTotalRFC extends SAPWrap {

    //private String functionName = "ZHRW_PENSION_TOTAL_DISPLAY";
	private String functionName = "ZGHR_PENSION_TOTAL_DISPLAY";

    /**
     * 국민연금누계 내역 조회 RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo ) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );

    }

}
