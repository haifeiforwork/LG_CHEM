package	hris.E.E11Personal.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E11Personal.*;

/**
 * E11PersonalApplRFC.java
 * 개인연금/마이라이프 해약 신청/신청조회를 하는 class
 *
 * @author 박영락
 * @version 1.0, 2002/02/04
 */
public class E11PersonalApplRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_PENTION_APPLICATION";

    /**
     * 개인연금/마이라이프 신청 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원번호 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPersList(String p_ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, p_ainf_seqn, "1", "2");
            
            excute(mConnection, function);
            
            Vector ret = getOutput(function);
            
            if( ret.size() > 0 ) {
                E11PersonalData data = (E11PersonalData)ret.get(0);
                
                data.MNTH_AMNT = Double.toString(Double.parseDouble(data.MNTH_AMNT) * 100.0 );
                data.PERL_AMNT = Double.toString(Double.parseDouble(data.PERL_AMNT) * 100.0 );
                data.CMPY_AMNT = Double.toString(Double.parseDouble(data.CMPY_AMNT) * 100.0 );
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
     * 개인연금/마이라이프 신청 insert하는 Method
     * @param java.lang.String 사원번호 java.lang.String 시험코드 java.lang.String 검정일 java.util.Vector 
     * @exception com.sns.jdf.GeneralException
     */ 
    public void build(String p_ainf_seqn, Vector personal_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, p_ainf_seqn, "2" , "2");

            E11PersonalData data = (E11PersonalData)personal_vt.get(0);
            
            data.MNTH_AMNT = Double.toString(Double.parseDouble(data.MNTH_AMNT) / 100.0 );
            data.PERL_AMNT = Double.toString(Double.parseDouble(data.PERL_AMNT) / 100.0 );
            data.CMPY_AMNT = Double.toString(Double.parseDouble(data.CMPY_AMNT) / 100.0 );

            setInput(function, personal_vt, "IT");

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
     * @param java.lang.String 사원번호  
     * @exception com.sns.jdf.GeneralException
     */ 
    public void delete( String p_ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
                        
            setInput(function, p_ainf_seqn,"4", "2" );

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
    private void setInput(JCO.Function function,String p_ainf_seqn, String jobcode, String p_appl_type ) throws GeneralException {
        String fieldName1 = "P_AINF_SEQN"          ;
        setField(function, fieldName1, p_ainf_seqn);
        
        String fieldName2 = "P_CONT_TYPE"          ;
        setField(function, fieldName2, jobcode)  ;
                
        String fieldName3 = "P_APPL_TYPE"      ;
        setField(function, fieldName3, p_appl_type);


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
        String entityName = "hris.E.E11Personal.E11PersonalData";
        String tableName  = "IT";
        return getTable(entityName, function, tableName);
    }
}


