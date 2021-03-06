package hris.J.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

/**
 * J00MenuOpenFlagRFC.java
 * 사원별 ESS Job Description Menu Open 여부를 조회하는 RFC를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2003/06/09
 */
public class J00MenuOpenFlagRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_MENU_OPEN_FLAG";

    public Vector getDetail( String i_pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_pernr);
            excute(mConnection, function);

            Vector ret = new Vector();
            
            ret = getOutput(function);
            
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
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_pernr ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, i_pernr);
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

//      Export 변수 조회
        String fieldName1  = "E_MENU_1" ;           //Job Description Menu Open 여부
        String E_MENU_1    = getField(fieldName1, function) ;

        String fieldName2  = "E_MENU_2" ;           //팀원 Job Description 조회 Menu Open 여부
        String E_MENU_2    = getField(fieldName2, function) ;

        String fieldName3  = "E_MENU_3" ;           //Job Description 조회ㆍ수정ㆍ생성 Menu Open 여부
        String E_MENU_3    = getField(fieldName3, function) ;

        ret.addElement(E_MENU_1);
        ret.addElement(E_MENU_2);
        ret.addElement(E_MENU_3);

        return ret;
    }
}

