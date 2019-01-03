package hris.D.rfc ;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 *  D16OTHDDupCheckRFC2.java
 *  초과근무, 휴가 신청 시 중복 체크를 한 결과를 리턴받음
 * 
IMPORT				
    필드명				타입		길이	설명			비고
	PERNR			UMC		8		사원 번호	
	UPMU_TYPE		CHAR		3		업무구분	
	BEGDA			DATS		8		시작 일자		"휴가인경우 휴가 시작일, 초과근무인 경우 실제 근무 일자"
	ENDDA			DATS		8		종료 일자		"휴가인경우 휴가 종료일,	초과근무인 경우 실제 근무 일자"
EXPORT				
	필드명				타입		길이	설명			비고
	E_FLAG			CHAR		1		중복여부		Y:중복, N:OK
	E_MESSAGE		CHAR		200	중복여부 		메세지	

 *  
 *  [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건
 * @author 이지은
 * @version 1.0, 2014/08/24
 */
public class D16OTHDDupCheckRFC2 extends SAPWrap {

//    private String functionName = "ZHRW_RFC_OTHD_DUP_CHECK2";
	private String functionName = "ZGHR_RFC_OTHD_DUP_CHECK2";

    /**
     * 초과근무와 휴가 신청시 중복 체크를 위한 RFC를 호출하는 Method
     * @param empNo java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getChecResult( String empNo, String UPMU_TYPE, String BEGDA, String ENDDA ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, UPMU_TYPE, BEGDA, ENDDA);
            excute(mConnection, function);

            Vector ret = new Vector();
            ret = getOutput(function);
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    public String getCheckField( String empNo, String UPMU_TYPE ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, UPMU_TYPE, "", "");
            excute(mConnection, function);

            String fieldName = "E_FLAG" ;

            return getField( fieldName, function ) ;
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
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String UPMU_TYPE, String BEGDA, String ENDDA) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_UPMU_TYPE";
        setField( function, fieldName2, UPMU_TYPE );
        String fieldName3 = "I_BEGDA";
        setField( function, fieldName3, BEGDA );
        String fieldName4 = "I_ENDDA";
        setField( function, fieldName4, ENDDA );
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
		String fieldName = "E_FLAG";
		String E_FLAG     = getField(fieldName, function) ;
//		String fieldName2    = "E_MESSAGE";
//		String E_MESSAGE  = getField(fieldName2, function) ;
		String E_MESSAGE  = getReturn().MSGTX;
		ret.addElement(E_FLAG);
		ret.addElement(E_MESSAGE);
        return ret;
    }


//    private Object getOutput2(JCO.Function function, D16OTHDDupCheckData2 data2) throws GeneralException {
//        return getFields( data2, function );
//    }
}