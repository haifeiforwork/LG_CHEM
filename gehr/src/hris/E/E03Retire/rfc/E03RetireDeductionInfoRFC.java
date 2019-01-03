/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 연금추가납입                                                 */
/*   Program Name : 연금추가납입현황                                   */
/*   Program ID   : E03RetireDeductionInfoRFC                                         */
/*   Description  : 연금추가납입현황                           */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_CHECK_REQ_OR_DEL                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                       */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire.rfc;

import hris.E.E03Retire.E03RetireDeductionInfoData;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.DateTime;

public class E03RetireDeductionInfoRFC extends SAPWrap{
	
	private String functionName = "ZSOLRP_RFC_CHECK_REQ_OR_DEL"; 


	public E03RetireDeductionInfoData getCurrRetireInfo(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            String datum = DateTime.getShortDateString();
            setInput(function, empNo, datum);
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
    private void setInput(JCO.Function function, String empNo, String datum) throws GeneralException {
        String fieldName1 = "PERNR";
        String fieldName2 = "DATUM";
        setField( function, fieldName1, empNo );
        setField( function, fieldName2, datum );
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

