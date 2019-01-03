package	hris.D.D03Vocation.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D03Vocation.*;

/**
 * D03RemainVocationRFC.java
 * 개인의 잔여휴가일수 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/01/21
 */
public class D03RemainVocationRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_REMAIN_HOLIDAY";//ZHRW_RFC_GET_REMAIN_HOLIDAY

    /**
     * 개인의 잔여휴가일수 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @return hris.D.D03Vocation.D03RemainVocationData
     * @exception com.sns.jdf.GeneralException
     */
    public D03RemainVocationData getRemainVocation(String keycode, String reqdate) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, reqdate);

            excute(mConnection, function);

//            D03RemainVocationData ret = (D03RemainVocationData)getFields((new D03RemainVocationData()), function);

    		D03RemainVocationData remainVocationData = new D03RemainVocationData();
			remainVocationData = (D03RemainVocationData)getStructor(new D03RemainVocationData(), function, "S_WORK");

			getFields( remainVocationData, function );

            Logger.debug.println(this, remainVocationData.toString());

            return remainVocationData;
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
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode, String reqdate) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;//P_PERNR
        setField(function, fieldName1, keycode);

        String fieldName2 = "I_REQUEST_DATE"   ;//P_REQUEST_DATE
        setField(function, fieldName2, reqdate);

        String fieldName3 = "I_NTM"   ;//I_NTM
        setField(function, fieldName3, "X");
    }
}