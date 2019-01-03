package hris.E.E16Health.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E16Health.*;

/**
 * E16HealthRFC.java
 * 임직원건강관리카드에  대한 데이터를 가져오는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2010/05/31
 *  2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
 */
public class E16HealthRFC extends SAPWrap {

 //  private String functionName = "ZHRW_RFC_HEALTH_CARD_DISPLAY";
    private String functionName = "ZGHR_RFC_HEALTH_CARD_DISPLAY";

    /**
     * 임직원건강관리카드에 대한 데이터를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail(String empNo, String year, String userempNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput( function, empNo,  year,userempNo);
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
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String year, String userempNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_YEAR";
        setField(function, fieldName2, year);
        String fieldName3 = "I_SPERNR";
        setField(function, fieldName3, userempNo);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {

        Vector ret = new Vector();

        Vector T_9416S = getTable( E16Health9416Data.class, function, "T_9416" ); // 검진이력
        Vector T_9419S = getTable( E16Health9419Data.class, function, "T_9419" ); // 건강검진결과
        Vector T_9420S = getTable( E16Health9420Data.class, function, "T_9420" ); // 건강검진 상담
        Vector T_9421S = getTable( E16Health9421Data.class, function, "T_9421" ); // 가족력 관리



        ret.addElement(T_9416S);
        ret.addElement(T_9419S);
        ret.addElement(T_9420S);

        Logger.sap.println(this, "T_9416S : "+T_9416S.toString());
        Logger.sap.println(this, "T_9419S : "+T_9419S.toString());

        // Export 변수 조회
        String E_ENAME = getField("E_ENAME",  function);  //이름
        String E_TITEL  = getField("E_TITEL",    function);  //제목
        String E_REGNO = getField("E_REGNO",   function);  //주민등록번호
        String E_ORGEH = getField("E_ORGEH",   function);  //조직 단위
        String E_STEXT = getField("E_STEXT",   function);  //오브젝트 이름
        String E_DARDT = getField("E_DARDT",   function);  //일자유형에 대한 일자
        String E_PRINT = getField("E_PRINT",   function);  //출력여부
        String E_CENAME = getField("E_CENAME",   function);  //조직장 이름
        String E_HENAME = getField("E_HENAME",   function);  //보건담당자 이름
        //  [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
        String E_TITL2 = getField("E_TITL2",   function);  //직책

        ret.addElement(E_ENAME);
        ret.addElement(E_TITEL);
        ret.addElement(E_REGNO);
        ret.addElement(E_ORGEH);
        ret.addElement(E_STEXT);
        ret.addElement(E_DARDT);
        ret.addElement(E_PRINT);
        ret.addElement(E_CENAME);
        ret.addElement(E_HENAME);
        ret.addElement(T_9421S);
        ret.addElement(E_TITL2);//  [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건

        return ret;
    }
}

