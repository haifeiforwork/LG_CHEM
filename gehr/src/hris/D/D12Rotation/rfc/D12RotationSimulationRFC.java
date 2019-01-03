package hris.D.D12Rotation.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D12Rotation.* ;

/**
 * D12RotationSimulationRFC.java
 * 저장 전, 인포타입 등록가능여부 시뮬레이션 수행 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2009/01/07
 */
public class D12RotationSimulationRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_DAY_SIMULATION" ;

    /**
     * 계장 근태 입력 - 작업 Data를 저장하는 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector  CheckData( Vector main_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, main_vt,     "T_RESULT" );

            excute( mConnection, function );
        	Vector ret = new Vector();
        	// Export 변수 조회
        /*	String fieldName1 = "E_RETURN";        // 리턴코드
        	String E_RETURN   = getField(fieldName1, function) ;

        	String fieldName2 = "E_MESSAGE";     // 다이얼로그 인터페이스에 대한 메세지텍스트
        	String E_MESSAGE  = getField(fieldName2, function) ;*/

        	String E_RETURN   = getReturn().MSGTY;
        	String E_MESSAGE   = getReturn().MSGTX;

        	ret.addElement(E_RETURN);
        	ret.addElement(E_MESSAGE);
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
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

}