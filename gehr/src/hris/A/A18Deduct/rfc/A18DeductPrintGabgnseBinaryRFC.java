package hris.A.A18Deduct.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * A18DeductPrintGunroSodukBinaryRFC.java
 *갑근세  PDF Data를 리턴하는 RFC를 호출하는 Class
 * [CSR ID:1639484] ESS 갑근세  출력 PDF 변환 2012.07.23   
 * @author  lsa
 * @version 1.0, 2012/07/23
 */
public class A18DeductPrintGabgnseBinaryRFC extends SAPWrap {
	
	//private String functionName = "ZHRP_RFC_PTX_PRINT";
	private static String functionName = "ZHRP_RFC_PTX_PRINT"; 
    
    /**
     * 갑근세 PDF Binary Table을 리턴하는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @param  java.lang.String 사원번호
     * @param  java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getData(String P_PERNR, String P_AINF ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_PERNR, P_AINF  );
            excute(mConnection, function);
            return  getBinary(function);
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
	 * @param java.lang.String 사원번호
     * @param java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String P_PERNR, String P_AINF  ) throws GeneralException {
 	
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, P_PERNR );
        String fieldName2 = "I_AINF_SEQN";
        setField( function, fieldName2, P_AINF );
    }
    /**
     * RFC 실행후 Binary Table을 Vector로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getBinary(JCO.Function function) throws GeneralException {
    	Vector result = new Vector();
    	result = getTable(function, "E_TABLE");
    	return result;
    }
}