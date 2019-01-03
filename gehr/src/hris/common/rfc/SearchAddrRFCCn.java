package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.common.SearchAddrDataCn;

import java.util.Vector;

/**
 * SearchAddrRFC.java 주소 검색 List 를 가져오는 RFC를 호출하는 Class
 * 
 * @author 박영락
 * @version 1.0, 2001/12/18
 */
public class SearchAddrRFCCn extends SAPWrap {

	private String functionName = "ZGHR_RFC_GET_ZIPCODE_F4";

	/**
	 * 주소검색 List 를 가져오는 RFC를 호출하는 Method
	 *            동면명
	 * @return java.util.Vector
	 * @exception GeneralException
	 */
	public Vector getAddrDetail(String gubun, String name, String prvncd, String citycd, String cntycd) throws GeneralException {

		JCO.Client mConnection = null;

		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			
			setInput(function, gubun,name,prvncd,citycd,cntycd);
			excute(mConnection, function);

			return getTable(SearchAddrDataCn.class,function, "T_RESULT");

     	} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

	private void setInput(JCO.Function function, String gubun, String name, String prvncd, String citycd, String cntycd) throws GeneralException {
        setField( function, "I_GUBUN", gubun );
        setField( function, "I_NAME", name );
        setField( function, "I_PRVNCD", prvncd );
        setField( function, "I_CITYCD", citycd );
        setField( function, "I_CNTYCD", cntycd );
    }
	
	/**
	 * RFC 실행후 Export 값을 Vector 로 Return 한다. 반드시
	 * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function)
	 * 가 호출된후에 실행되어야하는 메소드
	 * 
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @return java.util.Vector
	 * @exception GeneralException
	 */
	  private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector sum = new Vector();
        String entityName = "hris.common.SearchAddrDataCn";
       
        String tableName1  = "ITAB1";
        Vector prvncd= getTable(entityName, function, tableName1);
        
        String tableName2  = "ITAB2";
        Vector citycd= getTable(entityName, function, tableName2);
        
        String tableName3  = "ITAB3";
        Vector cntycd= getTable(entityName, function, tableName3);
        
        String tableName4  = "ITAB4";
        Vector zipcode= getTable(entityName, function, tableName4);
    	
        sum.addElement(prvncd);
        sum.addElement(citycd);
        sum.addElement(cntycd);
        sum.addElement(zipcode);
        
        return sum;
    }

}   
