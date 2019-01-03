package	hris.D.D11TaxAdjust.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D11TaxAdjust.*;

/**
 * D11TaxAdjustGibuDonaCheckRFC
 * 기부금전월공제 유형명 입력년도 오류체크결과를  가져오는 RFC를 호출하는 Class
 *
 * @author LSA
 * @version 1.0, 2011/12/27
 */
public class D11TaxAdjustGibuDonaCheckRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_DONATION_CO_CHECK";
 
    /**
     * 기부금유형명을 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getResult(String DOCO, String CRVYR, String  BEGDA) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, DOCO,CRVYR,BEGDA);
            excute(mConnection, function);
            
            String fieldName = "RTYPE" ;
            String RTYPE       = getField( fieldName, function ) ;
            String fieldName1 = "RTEXT" ;
            String RTEXT       = getField( fieldName1, function ) ;
            Vector ret = new Vector();
            ret.addElement(RTYPE);
            ret.addElement(RTEXT);
            return ret ;
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String DOCO, String CRVYR, String  BEGDA) throws GeneralException {
        String fieldName1 = "I_DOCOD";
        setField( function, fieldName1, DOCO );
        String fieldName2 = "I_CRVYR";
        setField( function, fieldName2, CRVYR );
        String fieldName3 = "I_BEGDA";
        setField( function, fieldName3, BEGDA );
    }

}