package	hris.D.D06Ypay.rfc;

import java.util.HashMap;
import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.Function;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D06Ypay.D06YpayDetailData_to_year;

/**
 * D06YpayDetail_to_yearRFC.java
 * 2003/01/13  연말정산으로 인한 연급여 생성
 * 개인의 연급여 내역 정보를 가져오는 RFC를 호출하는 Class[유럽]
 * @author yji
 * @version 1.0, 2010/08/04
 */
public class D06YpayDetail_to_yearRFCEurp extends SAPWrap {

    private String functionName = "ZHRP_RFC_YEAR_PAYROLL";

    /**
     * 개인의 연급여 내역 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getYpayDetail( String empNo, String from_year ) throws GeneralException {
    
        JCO.Client mConnection = null;
        HashMap map = null;
        Vector Result = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, from_year);
            excute(mConnection, function);
            
            Vector ret2 = getOutput(function);  //급여내역
            
            return ret2;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
 
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value, String value1) throws GeneralException {
        String fieldName   = "I_PERNR";
        String fieldName1 = "I_PYEAR";
        
        setField(function, fieldName, value);
        setField(function, fieldName1, value1);
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput2(JCO.Function function) throws GeneralException {

    	Vector return_vt = new Vector(); 
    	
	     String fieldName1 = "E_RETURN";        // 리턴코드
 	     String E_RETURN   = getField(fieldName1, function) ;
 	     
	    return_vt.addElement(E_RETURN);
        return return_vt;
    }
    
	private Vector getOutputPerson(Function function) throws GeneralException {
		D06YpayDetailData_to_year data = new D06YpayDetailData_to_year();
		D06YpayDetailData_to_year obj = (D06YpayDetailData_to_year) getStructor(data, function, "E_PERSON");
		Vector v = new Vector();
		v.addElement(obj);
		return v;
	}
	
    /**
     * RFC 실행후 Export 값을 Object 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param data java.lang.Object
     * @return java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {

    	Vector return_vt = new Vector(); 
    	
    	//리턴
	    String fieldName1 = "E_RETURN";
	    String E_RETURN   = getField(fieldName1, function) ;
	     
	     //메시지
	    String fieldName2 = "E_MESSAGE";        
	    String E_MESSAGE   = getField(fieldName2, function) ;
	    
	    //기본정보
		D06YpayDetailData_to_year data = new D06YpayDetailData_to_year();
		D06YpayDetailData_to_year E_PERSON = (D06YpayDetailData_to_year) getStructor(data, function, "E_PERSON");
		
    	Vector monthTotal_vt = new Vector();   	
        String entityName = "hris.D.D06Ypay.D06YpayDetailData_to_year";
        String tableName  = "E_TOTAL_T";
        monthTotal_vt = getTable(entityName, function, tableName);
        
        return_vt.addElement(E_RETURN);
        return_vt.addElement(E_MESSAGE);
        return_vt.addElement(E_PERSON);
        return_vt.addElement(monthTotal_vt);
        
        return return_vt;
    }
    
}