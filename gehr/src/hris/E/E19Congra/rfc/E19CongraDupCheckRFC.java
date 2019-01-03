package hris.E.E19Congra.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E19Congra.*;

/**
 * E19CongraDupCheckRFC.java
 * 경조금신청시 중복 신청을 막아주기위해서 INFOTYPE, TEMP_TABLE에 이미 신청된 건을 읽어온다.
 *
 * @author  김도신
 * @version 1.0, 2003/02/20
 */
public class E19CongraDupCheckRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_CONGRA_DUP_CHECK";
	private String functionName = "ZGHR_RFC_CONGRA_DUP_CHECK";

    /**
     * 경조금조회 RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }


}


