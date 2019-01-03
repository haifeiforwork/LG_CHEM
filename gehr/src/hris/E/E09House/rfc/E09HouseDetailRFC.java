package hris.E.E09House.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E09House.*;

/**
 * E09HouseDetailRFC.java
 * 주택자금융자 세부내역을 조회 하는 RFC 를 호출하는 Class
 *
 * @author 박영락
 * @version 1.0, 2002/12/31
 */
public class E09HouseDetailRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_HOUSE_FUND_DETAIL";
    private String functionName = "ZGHR_RFC_HOUSE_FUND_DETAIL";

    /**
     * 주택자금융자 세부내역 조회 RFC 호출하는 Method
     * @param empNo java.lang.Object
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Object getHouseDetail( Object key ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            Logger.debug.println(this, key.toString());
            setInput(function, key);
            excute(mConnection, function);
            E09HouseDetailData data = (E09HouseDetailData)getOutput(function);

            data.E_BETRG           = Double.toString(Double.parseDouble(data.E_BETRG         ) * 100.0 );
            data.E_DARBT           = Double.toString(Double.parseDouble(data.E_DARBT         ) * 100.0 );
            data.E_REMAIN_BETRG    = Double.toString(Double.parseDouble(data.E_REMAIN_BETRG  ) * 100.0 );
            data.E_TILBT           = Double.toString(Double.parseDouble(data.E_TILBT         ) * 100.0 );
            data.E_TILBT_BETRG     = Double.toString(Double.parseDouble(data.E_TILBT_BETRG   ) * 100.0 );
            data.E_TOTAL_DARBT     = Double.toString(Double.parseDouble(data.E_TOTAL_DARBT   ) * 100.0 );
            data.E_TOTAL_INTEREST  = Double.toString(Double.parseDouble(data.E_TOTAL_INTEREST) * 100.0 );
            Logger.debug.println(this, data.toString());
            return data;
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Object key ) throws GeneralException {
        setFields( function, key);

    }
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    private Object getOutput(JCO.Function function) throws GeneralException {
        E09HouseDetailData data = new E09HouseDetailData();
        return getFields(data, function);
    }

}
