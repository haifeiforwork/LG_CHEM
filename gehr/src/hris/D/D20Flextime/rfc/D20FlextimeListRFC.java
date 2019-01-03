package hris.D.D20Flextime.rfc ;

import hris.D.D20Flextime.D20FlextimeListData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D20FlextimeListRFC.java
 * Flextime 실적을 조회하는 RFC
 * 2017-08-01  eunha    [CSR ID:3438118] flexible time 시스템 요청
 * @author eunha
 * @version 1.0, 2017/08/02
 */
public class D20FlextimeListRFC extends SAPWrap {

//	 private String functionName = "ZGHR_RFC_FLEXTIME_LIST" ;
	 private String functionName = "ZGHR_RFC_NTM_FLEXTIME_LIST" ;

    /**
     * Flextime 실적
     * @exception com.sns.jdf.GeneralException
     */
	    public Vector<D20FlextimeListData> getList( String I_PERNR, String I_YEAR) throws GeneralException {

	        JCO.Client mConnection = null;

	        try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName) ;

	            setField(function, "I_PERNR", I_PERNR);
	            setField(function, "I_YEAR", I_YEAR);

	            excute(mConnection, function);

	            return getTable(D20FlextimeListData.class, function, "T_LIST_M");

	        } catch(Exception ex){
	            Logger.error(ex);
	            throw new GeneralException(ex);
	        } finally {
	            close(mConnection);
	        }
	    }

}