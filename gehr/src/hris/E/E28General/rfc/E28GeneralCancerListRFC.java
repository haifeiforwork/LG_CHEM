package hris.E.E28General.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E28General.*;


/**
 * E28GeneralCancerListRFC.java
 * 7종암검진 실시내역을 가지는 RFC 를 호출하는 Class
 *
 * @author lsa C20130805_81825
 * @version 1.0, 2013/08/05
 */
public class E28GeneralCancerListRFC extends SAPWrap {

   // private String functionName = "ZHRH_RFC_HOSP_DISPLAY_N";
	 private String functionName = "ZGHR_RFC_HOSP_DISPLAY_N";

    /**
     * 7종암검진 실시내역 조회 RFC 호출하는 Method
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
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


