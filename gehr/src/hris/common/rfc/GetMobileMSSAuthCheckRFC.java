package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * GetMobileMSSAuthCheckRFC.java
 * G-mobile에서 인사 조회 권한이 있는지를 확인하는 function
 *
 * @author 이지은
 * @version 1.0, 2016-01-27
 * @[CSR ID:2991671] g-mobile 내 인사정보 조회 기능 추가 개발 요청
 *
 */
public class GetMobileMSSAuthCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_MOBILE_AUTH_CHECK";

    public String getMbMssAuthChk( String webUserId ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, webUserId);

            excute(mConnection, function);
            return getOutput(function);

        } catch(Exception ex) {
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
     *
     */
    private void setInput(JCO.Function function, String webUserId) throws GeneralException{
        String fieldName = "I_PERNR";
        setField(function, fieldName, webUserId);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput(JCO.Function function) throws GeneralException {
        //String fieldName = "E_FLAG";      // RFC Export 구성요소 참조
        //return getField(fieldName, function);
    	String fieldName = "E_FLAG";

		String E_FLAG    = getField(fieldName,    function);  // Y.N
        return E_FLAG;

    }
}

