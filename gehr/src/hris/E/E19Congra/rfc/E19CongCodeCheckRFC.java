package hris.E.E19Congra.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E19Congra.*;

/**
 * E19CongCodeCheckRFC.java
 * 경조내역 Code를 가져오는 RFC를 호출하는 Class
 *
 * @author 송범근
 * @version 1.0, 2006/06/20
 */
public class E19CongCodeCheckRFC extends SAPWrap {

   // private String functionName = "ZHRW_RFC_CHECK_CONGCOND_LIST";
	 private String functionName = "ZGHR_RFC_CHECK_CONGCOND_LIST";

    /**
     * 경조내역 Code를 가져오는 RFC를 호출하는 Method
     * @param companyCode java.lang.String 회사코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public E19CongCodeCheckData getCongCodeCheck(String companyCode , String cong_date , String cong_code , String rela_code , String pernr) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode , cong_date , cong_code,  rela_code , pernr);
            excute(mConnection, function);
            E19CongCodeCheckData ret = (E19CongCodeCheckData)getOutput(function, ( new E19CongCodeCheckData() ));
            return ret;
            //Vector ret = getOutput(function);

            //return ret;
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
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode ,String cong_date , String cong_code, String rela_code , String pernr) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
        fieldName = "I_CONG_DATE";
        setField( function, fieldName, cong_date );
        fieldName = "I_CONG_CODE";
        setField( function, fieldName, cong_code );
        fieldName = "I_RELA_CODE";
        setField( function, fieldName, rela_code );
        fieldName = "I_PERNR";
        setField( function, fieldName, pernr );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    private Object getOutput(JCO.Function function,E19CongCodeCheckData data) throws GeneralException {

    	data.E_FLAG = getReturn().MSGTY;
    	data.E_MESSAGE =	getReturn().MSGTX;
        return getFields(data, function);
    }

}


