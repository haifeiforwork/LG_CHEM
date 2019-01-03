package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.common.SearchAddrDataTW;

import java.util.Vector;

/**
 * SearchAddrRFC.java 주소 검색 List 를 가져오는 RFC를 호출하는 Class
 * 
 * @author 박영락
 * @version 1.0, 2001/12/18
 */
public class SearchAddrRFCTw extends SAPWrap {

	private String functionName = "ZGHR_RFC_ZIPP_CODE_F4";

	/**
	 * 주소검색 List 를 가져오는 RFC를 호출하는 Method
	 * 
	 *            동면명
	 * @return java.util.Vector
	 * @exception GeneralException
	 */
	public Vector getAddrDetail(String sVal) throws GeneralException {

		JCO.Client mConnection = null;

		try {
			mConnection = getClient();

			JCO.Function function = createFunction(functionName);

//			setInput(function, sVal);
			setField( function, "I_BEZEI2", sVal );

			excute(mConnection, function);

			return getTable(SearchAddrDataTW.class, function, "T_RESULT");

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

}
