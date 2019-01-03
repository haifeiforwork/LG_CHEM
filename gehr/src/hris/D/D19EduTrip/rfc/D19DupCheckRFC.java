package hris.D.D19EduTrip.rfc;

import java.util.*;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.D.D19EduTrip.*;


/**
 * D19DupCheckRFC.java
 * 교육,출장신청가능여부 체크하는 Class
 *
 * @author  lsa
 * @version 1.0, 2006/08/18
 */
public class D19DupCheckRFC extends SAPWrap {

  //  private String functionName = "ZHRW_RFC_CHECK_ATTD_APPLY";
	  private String functionName = "ZGHR_RFC_CHECK_ATTD_APPLY";

    /**
     * 교육,출장신청가능여부 체크 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity check( D19EduTripData d19EduTripData) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, d19EduTripData );
            excute(mConnection, function);
            return getReturn();
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
    private void setInput( JCO.Function function, D19EduTripData d19EduTripData) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, d19EduTripData.PERNR );
        String fieldName2 = "I_APPL_FROM";
        setField( function, fieldName2, d19EduTripData.APPL_FROM );
        String fieldName3 = "I_APPL_TO";
        setField( function, fieldName3, d19EduTripData.APPL_TO );
        String fieldName4 = "I_AINF_SEQN";
        setField( function, fieldName4, d19EduTripData.AINF_SEQN );
    }
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    private Object getOutput(JCO.Function function,D19DupCheckData data) throws GeneralException {
            return getFields(data, function);
    }

}


