/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �ް���������                                                */
/*   Program Name : �ް���������                                                */
/*   Program ID   : D03GetWorkdayRFC                                    */
/*   Description  : Leave management                 */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2007-09-13  zhouguangwen  global e-hr update                                                            */
/********************************************************************************/

package	hris.D.D03Vocation.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.D.D03Vocation.D03GetWorkdayData;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VacationGeneratedData;
import hris.D.D03Vocation.D03VacationUsedData;

import java.util.Vector;

/**
 * D03GetWorkdayRFC.java
 * ������ �ް���û ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author ��α�
 * @version 1.0, 2004/07/13
 * update by zhouguangwen 2007/09/13
 */
public class D03GetWorkdayGlobalRFC extends SAPWrap {

    //private String functionName = "ZHRP_GET_NO_OF_WORKDAY";
	private String functionName = "ZGHR_GET_NO_OF_WORKDAY";

    /**
     * ������ �ް���û ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Object getWorkday(String pernr, String currDate) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, pernr, currDate, "");
            excute(mConnection, function);
            Object ret = getOutput(function, ( new D03GetWorkdayData() ));
            return ret;

        }catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String pernr, String date, String flag) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;
        setField(function, fieldName1, pernr);

        String fieldName2 = "I_DATE"          ;
        setField(function, fieldName2, date)  ;

        String fieldName3 = "I_FLAG"      ;
        setField(function, fieldName3, flag);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	 private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        String structureName = "E_WORK";      // RFC
        return getStructor( data, function, structureName);
        }








	 public Vector getNoOfWorkday(String pernr, String year) throws GeneralException {

	        JCO.Client mConnection = null;
	        Vector returnVector = new Vector();
	        try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName) ;

	            setInput(function, pernr, year);
	            excute(mConnection, function);
	            returnVector = getOutput(function);

	            return returnVector;

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

	 private Vector getOutput(JCO.Function function) throws GeneralException {

		Vector ret_vt = new Vector();

		String structureName1 = "S_ITAB";
		D03RemainVocationData remainVocationData = new D03RemainVocationData();

		String structureName2 = "S_ITAB2";
		D03VacationGeneratedData vcationGenerateData = new D03VacationGeneratedData();

		String structureName3 = "S_ITAB3";
		D03VacationUsedData vocationUsedData = new D03VacationUsedData();

		 try{
			 remainVocationData = (D03RemainVocationData)getStructor(new D03RemainVocationData(), function, structureName1);
             ret_vt.addElement(remainVocationData);

             vcationGenerateData = (D03VacationGeneratedData)getStructor(new D03VacationGeneratedData(), function, structureName2);
             ret_vt.addElement(vcationGenerateData);

             vocationUsedData = (D03VacationUsedData)getStructor(new D03VacationUsedData(), function, structureName3);
             ret_vt.addElement(vocationUsedData);

        }catch(GeneralException e){

        	Logger.debug.println("A15CertiRFC.getOutput.(A15CertiData)getStructor(data, function, structureName) exception");
        }
     return ret_vt;

    }



}
