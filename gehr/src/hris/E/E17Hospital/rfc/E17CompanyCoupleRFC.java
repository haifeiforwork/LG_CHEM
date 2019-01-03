package hris.E.E17Hospital.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E17Hospital.* ;

/**
 * E17CompanyCoupleRFC.java
 *  사내 배우자 여부를 가져오는 RFC를 호출하는 Class
 *  [CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가
 * @author 김성일
 * @version 1.0, 2002/01/08
 */
public class E17CompanyCoupleRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_CHECK_COMPANY_COUPLE" ;
    private String functionName = "ZGHR_RFC_CHECK_COMPANY_COUPLE" ;

    /**
     * 사내 배우자 여부를 가져오는 RFC 호출하는 Method
     * @param java.lang.String 사원번호
     * @return hris.E.E05House.E05PersInfoData
     * @exception com.sns.jdf.GeneralException
     */
    public String getData(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            String return_str = "";

            setInput(function, empNo);
            excute(mConnection, function);
            return_str = getField("E_FLAG",  function);// getOutput(function);

            return return_str;
        }catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ([CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가)
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param PERNR java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String PERNR) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, PERNR );
    }


}
