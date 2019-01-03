package hris.D.D12Rotation.rfc ;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D12AINFInfoRFC.java
 * 결재번호로 / 기 저장된 근태정보 조회 하는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2009/01/07
 */
public class D12AINFInfoRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_DOCU_STATUS" ;

    /**
     * 계장 근태 입력 - 작업 Data를 조회하는 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAINFInfo( String AINF_SEQN ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, AINF_SEQN );
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
    private void setInput(JCO.Function function, String AINF_SEQN) throws GeneralException {
        setField( function, "I_AINF", AINF_SEQN );
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
        
        Vector T_EXPORTA  = getTable("hris.D.D12Rotation.D12RotationBuild2Data", function, "T_EXPORTA");
    	
    	
    	String E_RETURN   = getField("E_RETURN", function) ;
    	String E_MESSAGE  = getField("E_MESSAGE", function) ;
    	
    	ret.addElement(T_EXPORTA);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	
        return ret;
    }
}