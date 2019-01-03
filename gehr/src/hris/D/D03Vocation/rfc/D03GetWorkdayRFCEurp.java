/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 휴가실적정보                                                */
/*   Program Name : 휴가실적정보                                                */
/*   Program ID   : D03GetWorkdayRFCEurp                                    */
/*   Description  : Leave management                 */
/*   Note         :                                                             */
/*   Creation     : 2010-07-29  yji                                                           */
/********************************************************************************/

package	hris.D.D03Vocation.rfc;

import java.util.HashMap;
import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.Function;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VacationUsedData;

/**
 * D03GetWorkdayRFCEurp.java
 * 개인의 휴가신청 정보를 가져오는 RFC를 호출하는 Class[유럽용]
 *
 * @author yji
 * @version 1.0, 2010/07/29
 */
public class D03GetWorkdayRFCEurp extends SAPWrap {

    private String functionName = "ZGHR_GET_NO_OF_WORKDAY2";

    /**
     * 휴가신청 정보를 조회RFC를 호출하는 메소드
     * @param pernr
     * @param year
     * @return
     * @throws GeneralException
     */
	 public HashMap getNoOfWorkday(String pernr, String year) throws GeneralException {

	        JCO.Client mConnection = null;
	        D03RemainVocationData dataITAB = null;
	        D03VacationUsedData dataITAB3 = null;
	        Vector dataITAB2 = null;

	        try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName) ;

	            setInput(function, pernr, year);
	            excute(mConnection, function);
	            dataITAB = getOutputITAB(function); //changing parameter ITAB
	            dataITAB3 = getOutputITAB3(function); //changing parameter - Quota Used  Details
	            dataITAB2= getOutputITAB2(function);  //Quota Generated

	            HashMap map = new HashMap();
	            map.put("dataITAB", dataITAB);
	            map.put("dataITAB3", dataITAB3);
	            map.put("dataITAB2", dataITAB2);

	            Logger.debug.println(this, "[D03GetWorkdayRFCEurp, getNoOfWorkday: 휴가신청정보] " + map.toString());

	            return map;

	        }catch(Exception ex){
	            Logger.sap.println(this, "SAPException : "+ex.toString());
	            throw new GeneralException(ex);
	        } finally {
	            close(mConnection);
	        }
	    }

	 private void setInput(JCO.Function function, String pernr, String year) throws GeneralException {
		 String fieldName1 = "I_PERNR"          ;
	        setField(function, fieldName1, pernr);

	        String fieldName2 = "I_YEAR"          ;
	        setField(function, fieldName2, year)  ;

	    }

	 	/**
	 	 * Quota Generated Result
	 	 * @param function
	 	 * @return ret_vt
	 	 * @throws GeneralException
	 	 */
		private Vector getOutputITAB2(Function function) throws GeneralException {

			Vector ret_vt = new Vector();

			 String entityName2 = "hris.D.D03Vocation.D03VacationGeneratedDataEurp";
			 String tableName2 = "T_ITAB2";
			 ret_vt = getTable(entityName2, function, tableName2);

			return ret_vt;
		}

	/**
	 * getting basic information of leave Data
	 *
	 * @param function
	 * @return ret_vt
	 * @throws GeneralException
	 */
	 private D03RemainVocationData getOutputITAB(JCO.Function function) throws GeneralException {
			Vector ret_vt = new Vector();
			D03RemainVocationData data = new D03RemainVocationData();
			D03RemainVocationData obj = (D03RemainVocationData) getStructor(data, function, "S_ITAB");
	     return obj;
	  }

		/**
		 * getting Quota Used  Details
		 *
		 * @param function
		 * @return
		 * @throws GeneralException
		 */
	 private D03VacationUsedData getOutputITAB3(JCO.Function function) throws GeneralException {
				 D03VacationUsedData data2 = new D03VacationUsedData();
				 D03VacationUsedData obj2 = (D03VacationUsedData) getStructor(data2, function, "S_ITAB3");
	     return obj2;
    }

}