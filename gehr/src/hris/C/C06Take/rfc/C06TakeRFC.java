package hris.C.C06Take.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C06Take.*;
import hris.C.C02Curri.*;
/**
 * C06TakeRFC.java
 * 수강 신청 현황을 조회하는 RFC 를 호출하는 Class                        
 *
 * @author 이형석
 * @version 1.0, 2002/12/23
 */
public class C06TakeRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EVENT_INQUIRY";

    /**
     * 수강신청 현황 RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호, empNo java.lang.String 해당연도
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getTakeList( String empNo, String year ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            
            Vector edu = (Vector)ret.get(1);
            
            for(int i=0; i<edu.size();i++){
                
                C02CurriInfoData infodata = (C02CurriInfoData)edu.get(i);

                infodata.IKOST = Double.toString(Double.parseDouble(infodata.IKOST) * 100.0 );
            }
   
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
     * @param empNo java.lang.String 사원번호, empNo java.lang.String 해당연도
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String year) throws GeneralException {
        String fieldName = "PERNR";
        setField( function, fieldName, empNo );
        String fieldName1 = "YEAR";
        setField( function, fieldName1, year );
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

        String entityName1 = "hris.C.C06Take.C06TakeData";
        Vector P_RESULT = getTable(entityName1, function, "P_RESULT");

        String entityName2 = "hris.C.C02Curri.C02CurriInfoData";
        Vector P_EDU_INFORM = getTable(entityName2, function, "P_EDU_INFORM");
        
        ret.addElement(P_RESULT);
        ret.addElement(P_EDU_INFORM);

        return ret;

    }

}
