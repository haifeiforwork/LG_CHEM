package	hris.C.C07Language.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.C.C07Language.*;

/**
 * C07LanguageRFC.java
 * 어학지원 신청 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2003/04/14
 */
public class C07LanguageRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_LANGUAGE_SUPPORT";

    /**
     * 어학지원 신청 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail(String empNo, String seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, seqn, "1");
            
            excute(mConnection, function);
            
            Vector ret = getOutput(function);

            if( ret.size() > 0 ) {
                C07LanguageData data = (C07LanguageData)ret.get(0);

                data.SETL_WONX = Double.toString(Double.parseDouble(data.SETL_WONX) * 100.0 ) ;  // 결제금액
                data.CMPY_WONX = Double.toString(Double.parseDouble(data.CMPY_WONX) * 100.0 ) ;  // 회사지원금액
            }
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * 어학지원 입력 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */ 
    public void build( String empNo, String seqn, Object pension) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            C07LanguageData data = (C07LanguageData)pension;

            data.SETL_WONX = Double.toString(Double.parseDouble(data.SETL_WONX) / 100.0 ) ;  // 결제금액
            data.CMPY_WONX = Double.toString(Double.parseDouble(data.CMPY_WONX) / 100.0 ) ;  // 회사지원금액

            Vector pensionVector = new Vector();
            pensionVector.addElement(data);

            setInput(function, empNo, seqn, "2");

            setInput(function, pensionVector, "P_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * 어학지원 수정 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    public void change( String empNo, String seqn, Object pension) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            C07LanguageData data = (C07LanguageData)pension;

            data.SETL_WONX = Double.toString(Double.parseDouble(data.SETL_WONX) / 100.0 ) ;  // 결제금액
            data.CMPY_WONX = Double.toString(Double.parseDouble(data.CMPY_WONX) / 100.0 ) ;  // 회사지원금액

            Vector pensionVector = new Vector();
            pensionVector.addElement(data);

            setInput(function, empNo, seqn, "3");

            setInput(function, pensionVector, "P_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * 어학지원 삭제 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    public void delete( String empNo, String seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, seqn, "4");
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value, String seqn, String jobcode) throws GeneralException {
        String fieldName1 = "P_PERNR";
        setField(function, fieldName1, value);
        
        String fieldName2 = "P_AINF_SEQN";
        setField(function, fieldName2, seqn);
        
        String fieldName3 = "P_CONF_TYPE";
        setField(function, fieldName3, jobcode);
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
        String entityName = "hris.C.C07Language.C07LanguageData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }
}