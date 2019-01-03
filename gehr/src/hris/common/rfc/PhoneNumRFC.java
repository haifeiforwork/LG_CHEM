package hris.common.rfc;

import hris.common.PhoneNumData;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * PhoneNumRFC.java
 * 전화번호를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일   
 * @version 1.0, 2001/12/13
 * @history PhoneNumRFC는 이름과는 달리 전화번호뿐 아니라 사원번호에 따른 사원정보를 가져오는 용으로 사용되고 있음. 2010/06/15 YangJoungim
 */
public class PhoneNumRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_GET_PHONE_NUM";

    /**
     *  전화번호를 가져오는 RFC를 호출하는 Method
     *  @param java.lang.String 사번
     *  @return java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    public Object getPhoneNum(String empNo) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo);
            excute(mConnection, function);
            Object ret = getOutput(function, ( new PhoneNumData() ) );

            return ret;
        }catch(Exception ex){
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
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }

    /**
     * RFC 실행후 Export 값을 Object 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param data java.lang.Object
     * @return java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        return getFields( data, function );
    }
}

