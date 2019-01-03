package hris.A.A13Address.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.common.SearchAddrDataHk;

import java.util.Vector;

/**
 * A13AddressNationRFC.java
 * 국가 코드, 명을 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2001/12/26
 */
public class A13AddressAreaTypeRFC1 extends SAPWrap {

    private String functionName = "ZGHR_RFC_DISTRICT_AREA_F4";

    /**
     * 국가 코드, 명을 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector getAddressType(String counc) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, counc );
            excute(mConnection, function);
            Vector ret = getOutput1(function);
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    public Vector getAddressType() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
      
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
    private void setInput(JCO.Function function, String value) throws GeneralException {
        String fieldName = "I_AREA";
        setField(function, fieldName, value);
    }
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception GeneralException
     */
	private Vector getOutput(JCO.Function function) throws GeneralException {
		return getTable(SearchAddrDataHk.class, function, "T_ITAB2");
	}
	private Vector getOutput1(JCO.Function function) throws GeneralException {
        return getTable(SearchAddrDataHk.class, function, "T_ITAB2");
	}
}