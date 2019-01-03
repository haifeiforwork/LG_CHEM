package hris.E.E09House.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E09House.*;

/**
 * E09HouseListRFC.java
 * 개인의 주거지원 정보를 조회하는 RFC 를 호출하는 Class
 *
 * @author 이형석
 * @version 1.0, 2002/12/23
 */
public class E09HouseListRFC extends SAPWrap {

    //private  static String functionName = "ZHRW_RFC_HOUSE_FUND_DISPLAY";
    private  static String functionName = "ZGHR_RFC_HOUSE_FUND_DISPLAY";

    /**
     * 개인의 주거지원 정보를 조회하는 RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getHouseList( String empNo , String YearMonth) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,YearMonth);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            for(int i=0; i< ret.size();i++){
                E09HouseData data = (E09HouseData)ret.get(i);

                data.DARBT      = Double.toString(Double.parseDouble(data.DARBT)      * 100.0 );
                data.BETRG      = Double.toString(Double.parseDouble(data.BETRG)      * 100.0 );
                data.REDEMPTION = Double.toString(Double.parseDouble(data.REDEMPTION) * 100.0 );
                data.REDARBT    = Double.toString(Double.parseDouble(data.REDARBT)    * 100.0 );
                data.OPELO      = Double.toString(Double.parseDouble(data.OPELO)      * 100.0 );
                data.INTSP      = Double.toString(Double.parseDouble(data.INTSP)      * 100.0 ); //[CSR ID:2995203]이자지원액
                data.INTSP_YR      = Double.toString(Double.parseDouble(data.INTSP_YR)      * 100.0 );    // [CSR ID:2995203]이자지원액(당해)
            }
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    public Vector getHouseList( String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        Vector<E09HouseData> resultList = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);
            //Vector ret = getOutput(function);
            resultList = getTable(E09HouseData.class, function, "T_RESULT");

            for(int i=0; i< resultList.size();i++){
                E09HouseData data = (E09HouseData)resultList.get(i);

                data.DARBT      = Double.toString(Double.parseDouble(data.DARBT)      * 100.0 );
                data.BETRG      = Double.toString(Double.parseDouble(data.BETRG)      * 100.0 );
                data.REDEMPTION = Double.toString(Double.parseDouble(data.REDEMPTION) * 100.0 );
                data.REDARBT    = Double.toString(Double.parseDouble(data.REDARBT)    * 100.0 );
                data.OPELO      = Double.toString(Double.parseDouble(data.OPELO)      * 100.0 );
                data.INTSP      = Double.toString(Double.parseDouble(data.INTSP)      * 100.0 ); //이자지원액(보상명세서 추가)
                data.INTSP_YR      = Double.toString(Double.parseDouble(data.INTSP_YR)      * 100.0 );    // 이자지원액(당해)(보상명세서 추가)
            }
            return resultList;
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
    private void setInput(JCO.Function function, String empNo, String YearMonth ) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
        String fieldName1 = "I_YM";
        setField( function, fieldName1, YearMonth );

    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo ) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );

    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E09House.E09HouseData";
        String tableName = "T_RESULT";
        return getTable(entityName, function, tableName);
    }

}
