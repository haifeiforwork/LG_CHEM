package hris.D.D12Rotation.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D12Rotation.* ;

/**
 * D12OrgehRFC.java
 * 부서원 기본정보 / 기 저장된 근태정보 조회 하는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2009/01/07
 */
public class D12OrgehRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_DAY_READER" ;

    /**
     * 계장 근태 입력 - 작업 Data를 조회하는 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetailForOrgeh( String datum, String orgeh ) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInputForOrgeh( function, datum, orgeh );
            excute( mConnection, function );

            Vector ret = getOutput( function );

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 계장 근태 입력 - 작업 Data를 조회하는 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetailForPernr( String datum, String pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInputForPernr( function, datum, pernr );
            excute( mConnection, function );

            Vector ret = getOutput( function );

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
    private void setInputForOrgeh(JCO.Function function, String datum, String orgeh) throws GeneralException {
        String fieldName1 = "I_DATUM";
        setField( function, fieldName1, datum );
        String fieldName2 = "I_ORGEH";
        setField( function, fieldName2, orgeh );
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInputForPernr(JCO.Function function, String datum, String pernr) throws GeneralException {
        String fieldName1 = "I_DATUM";
        setField( function, fieldName1, datum );
        String fieldName2 = "I_PERNR";
        setField( function, fieldName2, pernr );
    }

    /**
     * Import Parameter 가 Vector(Table) 인 경우
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
//      대근 입력 가능 조직 리스트 조회
    	Vector ret = new Vector();
        String entityName = "hris.D.D12Rotation.D12RotationData";
        String tableName  = "T_RESULT";

    	Vector OBJPS_OUT  = getTable(entityName, function, tableName);

    	/*String fieldName2 = "E_RETURN";        // 리턴코드
    	String E_RETURN   = getField(fieldName2, function) ;

    	String fieldName3 = "E_MESSAGE";     // 다이얼로그 인터페이스에 대한 메세지텍스트
    	String E_MESSAGE  = getField(fieldName3, function) ;*/

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName4 = "E_STATUS";     // 다이얼로그 인터페이스에 대한 메세지텍스트
    	String E_STATUS  = getField(fieldName4, function) ;
    	String fieldName5 = "E_OTEXT";     // 다이얼로그 인터페이스에 대한 메세지텍스트
    	String E_OTEXT  = getField(fieldName5, function) ;
    	String fieldName6 = "E_ORGEH";     // 다이얼로그 인터페이스에 대한 메세지텍스트
    	String E_ORGEH  = getField(fieldName6, function) ;
    	ret.addElement(OBJPS_OUT);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(E_STATUS);
    	ret.addElement(E_OTEXT);
    	ret.addElement(E_ORGEH);
        return ret;
    }
}