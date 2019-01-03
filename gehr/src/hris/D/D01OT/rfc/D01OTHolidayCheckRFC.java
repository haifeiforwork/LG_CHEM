package hris.D.D01OT.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D01OTHolidayCheckRFC.java
 * 휴일, 공유일 체크하는 RFC 를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2014-05-13  C20140515_40601
 */
public class D01OTHolidayCheckRFC extends SAPWrap {

	private String functionName = "DAY_ATTRIBUTES_GET";

    /**
     * 휴일, 공유일 체크 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector check( String GUBN, String BEGDA, String ENDDA  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, GUBN, BEGDA, ENDDA );
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
	 * @param java.lang.String 사원번호
     * @param java.lang.String 결재정보 일련번호
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String GUBN, String BEGDA, String ENDDA  ) throws GeneralException {
        String fieldName1 = "HOLIDAY_CALENDAR";
        setField( function, fieldName1, GUBN );
        String fieldName2 = "DATE_FROM";
        setField( function, fieldName2, BEGDA );
        String fieldName3 = "DATE_TO";
        setField( function, fieldName3, ENDDA );

    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D01OT.D01OTHolidayCheckData";
        Vector ret = getTable(entityName, function, "DAY_ATTRIBUTES");
        return ret ;
    }
}


