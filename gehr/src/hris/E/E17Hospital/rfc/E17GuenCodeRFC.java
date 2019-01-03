package hris.E.E17Hospital.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.E.E17Hospital.E17ChildData;
import hris.common.PersonData;

import org.apache.commons.collections.map.HashedMap;

import java.util.Map;
import java.util.Vector;

/**
 * E17GuenCodeRFC.java
 * 본인,배우자 구분 데이터를 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/09/16
 * update:		2018-04-20 cykim [CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건
 */
public class E17GuenCodeRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_P_GUEN_CODE";

    /**
     * 본인,배우자 구분 데이터를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Map<String, Vector> getGuenCode(String I_PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_PERNR", I_PERNR);

            excute(mConnection, function);


            Map<String, Vector> resultMap = new HashedMap();

            resultMap.put("T_RESULT", getCodeVector(function, "T_RESULT", "VALPOS", "DDTEXT"));
            resultMap.put("T_CHILD", getTable(E17ChildData.class, function, "T_CHILD"));
            //[CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 start. @결혼기념일, 입사일자 받아옴
            resultMap.put("T_DATE", getTable(E17ChildData.class, function, "T_DATE"));
            //[CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 end

            return resultMap;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 자녀 리스트를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getChildList(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);
            Vector ret = getOutput2(function);

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
     * @param keycode java.lang.String 결재정보 일련번호
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "PERNR";
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
        String tableName = "P_RESULT";      // RFC Export 구성요소 참조
        return getCodeVector( function,tableName, "VALPOS", "DDTEXT");
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput2(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E17Hospital.E17ChildData";
        String tableName  = "P_CHILD";
        return getTable(entityName, function, tableName);
    }
}

