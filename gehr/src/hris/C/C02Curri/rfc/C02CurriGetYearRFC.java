package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriGetYear.java
 * 세부 교육과정 검색기간을 가져온다.
 *
 * @author 박영락   
 * @version 1.0, 2002/03/15
 */
public class C02CurriGetYearRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EVENT_CAL_YEARS";

    /**
     * 세부 교육과정 내용를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getYear( ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            excute(mConnection, function);
            Vector ret = getOutput(function);
            return ret;

        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String E_SYEAR  = getField("E_SYEAR", function );   
        String E_EYEAR  = getField("E_EYEAR", function );
        Vector vt = new Vector(2);
        vt.addElement(E_SYEAR);
        vt.addElement(E_EYEAR);

        return vt;
    }
}
