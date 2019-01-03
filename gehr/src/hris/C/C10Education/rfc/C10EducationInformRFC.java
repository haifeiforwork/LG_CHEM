package hris.C.C10Education.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C10Education.*;

/**
 * C10EducationInformRFC.java
 * 교육 과정 상세정보를 읽는다.
 *
 * @author  김도신
 * @version 1.0, 2005/05/28
 */
public class C10EducationInformRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EDUCATION_INFORM";

    /**
     * @param i_objid java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInfo( String i_objid ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_objid);
            excute(mConnection, function);

            Vector ret = getOutput(function);

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
     * @param i_objid java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_objid) throws GeneralException {
        String fieldName = "I_OBJID";
        setField( function, fieldName, i_objid );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret        = new Vector();

        String entityName1 = "hris.C.C10Education.C10EducationInformData";       //이벤트유형정보
        Vector T_RESULT1   = getTable(entityName1, function, "T_RESULT1");
        
        String entityName2 = "hris.C.C02Curri.C02CurriEventInfoData";            //이벤트유형안내정보
        Vector T_RESULT2   = getTable(entityName2, function, "T_RESULT2");
        
        ret.addElement(T_RESULT1);
        ret.addElement(T_RESULT2);

        return ret;
    }
}


