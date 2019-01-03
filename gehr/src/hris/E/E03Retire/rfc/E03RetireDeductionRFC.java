/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 연금추가납입                                                 */
/*   Program Name : 연금추가납입저장                                   */
/*   Program ID   : E03RetireDeductionRFC                                         */
/*   Description  : 연금추가납입저장                           */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_0015_BDC,  ZSOLRP_RFC_0014_BDC                                                 */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire.rfc;

import hris.E.E03Retire.E03RetireDeductionInfoData;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.DateTime;

public class E03RetireDeductionRFC extends SAPWrap{
	
	private String functionName1 = "ZSOLRP_RFC_0015_BDC"; //당월공제
	private String functionName2 = "ZSOLRP_RFC_0014_BDC"; //반복공제

	public E03RetireDeductionInfoData build(String empNo, Box box) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = null;
            if(box.getString("field_name").equalsIgnoreCase("CHECK_CODE_0015")){
            	function = createFunction(functionName1);
            }else if(box.getString("field_name").equalsIgnoreCase("CHECK_CODE_0014")){
            	function = createFunction(functionName2);
            }
           
            String datum = DateTime.getShortDateString();
            //원화이므로 100을 나눈다.
            String betrg = Double.toString(Double.parseDouble(DataUtil.removeComma(box.getString("betrg"))) / 100.0 ) ;
            setInput(function, box.getString("jobid"), empNo, box.getString("field_name"), betrg, datum);
            excute(mConnection, function);
  
            E03RetireDeductionInfoData data = (E03RetireDeductionInfoData)getOutput(function, (new E03RetireDeductionInfoData()));
            return data;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.getMessage());
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
    private void setInput(JCO.Function function, String jobid, String empNo, String field_name, String betrg, String datum) throws GeneralException {
        String fieldName1 = "PERNR";
        String fieldName2 = "BETRG";
        String fieldName3 = field_name;
        String fieldName4 = "DATUM";
        
        setField( function, fieldName1, empNo );
        setField( function, fieldName2, betrg);
        setField( function, fieldName3, jobid );
        setField( function, fieldName4, datum );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
    private Object getOutput(JCO.Function function, E03RetireDeductionInfoData data) throws GeneralException {
    	return getFields(data, function);
    }

}	

