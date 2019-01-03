package hris.E.E19Congra.rfc;

import hris.E.E19Congra.E19CongFlowerInfoData;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

/**
 * E19CongraFlowerInfoRFC.java
 * 주문업체정보를 가져오는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2014/04/18
 */
public class E19CongraFlowerInfoRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_FLOWER_INFO";
	private String functionName = "ZGHR_RFC_GET_FLOWER_INFO";

    /**
     * 인사하위영역 인사그룹핑 Code를 가져오는 RFC를 호출하는 Method
     * @param companyCode java.lang.String 회사코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    public Vector getFlowerInfoCode(String CONG_CODE) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function,CONG_CODE);
            excute(mConnection, function);
            Vector ret = getTable(E19CongFlowerInfoData.class, function, "T_ITAB");
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
//////////////////////////////


    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode,String gubn) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
        String fieldName1 = "I_UPMU_TYPE";
        setField( function, fieldName1, gubn );
    }


    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    private void setInput(JCO.Function function, String CONG_CODE) throws GeneralException {
        String fieldName = "I_CODE";
        setField( function, fieldName, CONG_CODE );

    }
/////////////////////

}


