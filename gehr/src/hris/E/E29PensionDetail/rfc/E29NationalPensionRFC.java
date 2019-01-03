package hris.E.E29PensionDetail.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E29PensionDetail.*;

/**
 * NationalPensionRFC.java
 * 년도별 상세내역을 조회하는 RFC 를 호출하는 Class
 *
 * @author 이형석
 * @version 1.0, 2002/01/29
 */
public class E29NationalPensionRFC extends SAPWrap {

    //private String functionName = "ZHRW_NATIONAL_PENSION_DISPLAY";
	private String functionName = "ZGHR_NATIONAL_PENSION_DISPLAY";

    /**
     * 국민연금 년도별 조회 RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호
     * @param empNo java.lang.String 조회연도
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getNationalList( String empNo, String year ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year);
            excute(mConnection, function);
            Vector ret = getTable(E29PensionDetailData.class, function, "T_RESULT");
            for ( int i = 0 ; i < ret.size() ; i++ ) {
                E29PensionDetailData data = (E29PensionDetailData)ret.get(i);
                data.BETRG = Double.toString( Double.parseDouble(data.BETRG) * 100.0 ) ;
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
     * @param empNo java.lang.String 사원번호
     * @param empNo java.lang.String 조회연도
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String year) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
        String fieldName1= "I_YEAR";
        setField( function, fieldName1, year );
    }

 }

