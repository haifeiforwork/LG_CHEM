package hris.D.D01OT.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D01OTCheckRFC.java
 * 초과근무 해당여부를 첵크하는 RFC 를 호출하는 Class
 *
 * @author 박영락
 * @version 1.0, 2002/03/15
 *
 * @update 김정인
 * @version 1.1, 2008/11/26 [C20081125_62978] IFlag 변수 추가.
 */
public class D010TOvertimeGlobalRFC extends SAPWrap {

//    private String functionName = "ZHR_RFC_OVERTIME_TOTAL";
//    private String functionName1 = "ZHRW_RFC_WORKDAY_CHECK";
    private String functionName = "ZGHR_RFC_OVERTIME_TOTAL";
    private String functionName1 = "ZGHR_RFC_WORKDAY_CHECK";

    /**
     * 초과근무 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @param java.lang.String 결재정보 일련번호
     * @param java.lang.String 사원번호
     * @param java.lang.String 사원번호
     * @param java.lang.String 사원번호
     * @param java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public String check( String PERSNO, String BEGDA, String IFlag ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, PERSNO, BEGDA, IFlag);
            excute(mConnection, function);
            String ret = getOutput(function);
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * get work days Method
     * @return java.lang.String
     * @param java.lang.String employee id
     * @param java.lang.String work date
     * @param java.lang.String apply date
     * @exception com.sns.jdf.GeneralException
     */
    public String getWorkDays( String PERSNO, String BEGDA, String BEGUZ ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;
            //setInput(function, PERSNO, BEGDA, BEGUZ);
            setField( function, "I_PERNR", PERSNO );
            setField( function, "I_BEGDA", BEGDA );
            setField( function, "I_ENDDA", BEGUZ );
        	// for Old RFC
//            setField( function, "PERNR", PERSNO );
//            setField( function, "BEGDA", BEGDA );
//            setField( function, "ENDDA", BEGUZ );

            excute(mConnection, function);
            String ret =  getField("E_DAYS", function);
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
    private void setInput(JCO.Function function, String PERSNO, String BEGDA, String IFlag ) throws GeneralException {
    	// for Old RFC
//        setField( function, "PERNR", PERSNO );
//        setField( function, "BEGDA", BEGDA );
//        setField( function,  "FLAG", IFlag );
        // for New RFC 
        setField( function, "I_PERNR", PERSNO );
        setField( function, "I_BEGDA", BEGDA );
        setField( function,  "I_FLAG", IFlag );
        
        /*String fieldName3 = "I_ENDDA";
        setField( function, fieldName3, ENDDA );
        String fieldName4 = "I_BEGUZ";
        setField( function, fieldName4, BEGTI );
        String fieldName5 = "I_ENDUZ";
        setField( function, fieldName5, ENDTI );*/

    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput(JCO.Function function) throws GeneralException {
        String ret = getField("E_ANZHL", function);
        return ret ;
    }
}


