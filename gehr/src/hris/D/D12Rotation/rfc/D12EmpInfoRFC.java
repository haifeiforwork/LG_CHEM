package hris.D.D12Rotation.rfc ;

import java.util.HashMap;
import java.util.Map;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D12EmpInfoRFC.java
 * 사원정보조회 RFC를 호출하는 Class
 *
 * @author 김종서
 * @version 1.0, 2009/02/10
 */
public class D12EmpInfoRFC extends SAPWrap {

   // private String functionName = "ZHRW_RFC_PERNR" ;
	 private String functionName = "ZGHR_RFC_PERNR" ;

    /**
     * 사원정보조회 - 사원번호나 RFC 호출하는 Method
     * @return java.util.Map
     * @exception com.sns.jdf.GeneralException
     */
    public Map  getEmpInfo( String pernr, String ename, String orgeh, String datum ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        	Logger.info.println("pernr : "+pernr);
        	Logger.info.println("ename : "+ename);
        	Logger.info.println("orgeh : "+orgeh);
        	Logger.info.println("datum : "+datum);
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;
            setInput( function, pernr, ename, orgeh, datum );

            excute( mConnection, function );

            Map ret = new HashMap();

        	// Export 변수 조회

        	String E_RETURN   = getField("E_RETURN", function); //리턴코드
        	String E_MESSAGE  = getField("E_MESSAGE", function); // 다이얼로그 인터페이스에 대한 메세지텍스트
        	ret.put("E_RETURN",E_RETURN);
        	ret.put("E_MESSAGE",E_MESSAGE);

        	String E_PERNR   = getField("E_PERNR", function) ;
        	String E_ENAME  = getField("E_ENAME", function) ;
        	ret.put("E_PERNR",E_PERNR);
        	ret.put("E_ENAME",E_ENAME);

        	Logger.info.println("E_RETURN : "+E_RETURN);
        	Logger.info.println("E_MESSAGE : "+E_MESSAGE);
        	Logger.info.println("E_PERNR : "+E_PERNR);
        	Logger.info.println("E_ENAME : "+E_ENAME);

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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String pernr, String ename, String orgeh, String datum) throws GeneralException {
    	setField(function, "I_ORGEH", orgeh);
        setField(function, "I_DATUM", datum);
        setField(function, "I_PERNR", pernr);
    	setField(function, "I_ENAME", ename);
    }



}