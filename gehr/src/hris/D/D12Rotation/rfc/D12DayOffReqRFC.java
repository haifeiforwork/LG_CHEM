package hris.D.D12Rotation.rfc ;

import hris.common.approval.ApprovalSAPWrap;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D12DayOffReqRFC.java
 * 결재요청 입력 RFC를 호출하는 Class
 *
 * @author 김종서
 * @version 1.0, 2009/02/17
 */
public class D12DayOffReqRFC extends ApprovalSAPWrap {

    private String functionName = "ZHRW_RFC_DAY_OFF" ;


    public Vector  build( String i_fromda, String i_toda, String i_orgeh, String i_ainf, Vector p_zhra003t_vt, Vector p_zhra112t_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;
            Logger.debug.println("==========setInput 수행전==========");
            setInput( function, i_fromda, i_toda, i_orgeh, i_ainf, p_zhra003t_vt, p_zhra112t_vt );
            Logger.debug.println("==========setInput 수행후==========");
            excute( mConnection, function );
            Logger.debug.println("==========excute 수행후==========");
        	Vector ret = new Vector();
        	// Export 변수 조회
        	String fieldName1 = "E_RETURN";        // 리턴코드
        	String E_RETURN   = getField(fieldName1, function) ;

        	String fieldName2 = "E_MESSAGE";     // 다이얼로그 인터페이스에 대한 메세지텍스트
        	String E_MESSAGE  = getField(fieldName2, function) ;

        	p_zhra003t_vt = getTable("hris.D.D12Rotation.D12ZHRA003TData", function, "P_ZHRA003T");
        	p_zhra112t_vt = getTable("hris.D.D12Rotation.D12ZHRA112TData", function, "P_ZHRA112T");
        	//ret.addElement(getTable("hris.common.AppLineData", function, "P_ZHRA003T"));
        	//ret.addElement(getTable("hris.D.D12Rotation.D12ZHRA112TData", function, "P_ZHRA112T"));
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

    private void setInput(JCO.Function function, String i_fromda, String i_toda, String i_orgeh, String i_ainf, Vector AppLineData_vt, Vector p_zhra112t_vt) throws GeneralException{

    	setField(function, "I_FROMDA", i_fromda);
    	setField(function, "I_TODA", i_toda);
    	setField(function, "I_ORGEH", i_orgeh);
    	setField(function, "I_AINF", i_ainf);
    	setTable(function, "P_ZHRA003T", AppLineData_vt);
    	setTable(function, "P_ZHRA112T", p_zhra112t_vt);
    	setField(function, "I_COMMAND", "REQ");
    }

}