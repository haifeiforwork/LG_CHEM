package	hris.C.C04Ftest.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.C.C04Ftest.*;

/**
 * C04FtestFirstRFC.java
 * 개인이 신청한 어학능력 검정 일정을 가져오는 class
 *
 * @author 이형석
 * @version 1.0, 2002/01/04
 */
public class C04FtestListRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_LANGUAGE_LIST";

    /**
     * 개인의 어학능력검정 신청 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원번호 java.lang.String 시험코드 java.lang.String 검정일
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFtestList(String empNo, String lang_code, String exam_date) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,lang_code,exam_date, "1");
            
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
     * 어학능력검정신청을 insert하는 Method
     * @param java.lang.String 사원번호 java.lang.String 시험코드 java.lang.String 검정일 java.util.Vector 
     * @exception com.sns.jdf.GeneralException
     */ 
    public void build(String empNo, String lang_code, String exam_date, Vector Language_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, lang_code, exam_date ,"2");

            setInput(function, Language_vt, "P_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
     /**
     * 신청한 데이터를 수정하는 Method
     * @param java.lang.String 사원번호 java.lang.String 시험코드 java.lang.String 검정일 java.util.Vector 
     * @exception com.sns.jdf.GeneralException
     */ 
    public void change(String empNo, String lang_code, String exam_date, Vector Language_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            Logger.sap.println(this, "[[[lang_code : "+lang_code+" exam_date : "+exam_date);
            
            setInput(function, empNo, lang_code, exam_date,"3");

            setInput(function, Language_vt, "P_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
     /**
     * 신청한 데이터를 삭제하는 Method
     * @param java.lang.String 사원번호 java.lang.String 시험코드 java.lang.String 검정일 
     * @exception com.sns.jdf.GeneralException
     */ 
    public void delete(String empNo, String lang_code, String exam_date) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
                        
            setInput(function, empNo, lang_code, exam_date,"4");

            excute(mConnection, function);

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
     * @param value java.lang.String 사번 java.lang.String 시험코드 java.lang.String 검정일 java.lang.String 작업구분
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function,String empNo, String LANG_CODE, String EXAM_DATE, String jobcode) throws GeneralException {
        String fieldName1 = "P_PERNR"          ;
        setField(function, fieldName1, empNo);
        
        String fieldName2 = "P_LANG_CODE"          ;
        setField(function, fieldName2, LANG_CODE)  ;
        
        String fieldName3 = "P_EXAM_DATE"      ;
        setField(function, fieldName3, EXAM_DATE);

        String fieldName4 = "P_COND_TYPE"      ;
        setField(function, fieldName4, jobcode);


    }



// Import Parameter 가 Vector(Table) 인 경우
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C04Ftest.C04FtestFirstData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }
}
