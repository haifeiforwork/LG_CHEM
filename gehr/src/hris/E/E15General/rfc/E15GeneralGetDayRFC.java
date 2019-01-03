package	hris.E.E15General.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.E.E15General.*;

/**
 * E15GeneralGetDayRFC.java ZHRW047T
 * 종합검진 신청 기간 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author LSA
 * @version 1.0, 2012/01/02
 */
public class E15GeneralGetDayRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_MEDIC_APPLY";
    private String functionName = "ZGHR_RFC_MEDIC_APPLY";

    /**
     * 개인의 휴가신청 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getMedicday(String pernr ) throws GeneralException {

        JCO.Client mConnection = null;

        Vector vcRet = new Vector();
        E15GeneralDayData DayData = new E15GeneralDayData();
        String E_HEALTH;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, pernr );
            excute(mConnection, function);

            getStructor(DayData ,function, "S_APPLY");
            E_HEALTH = getField("E_HEALTH" ,function);

            vcRet.add(DayData);
            vcRet.add(E_HEALTH);
            return vcRet;

        }catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String pernr ) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;
        setField(function, fieldName1, pernr);
    }

}
