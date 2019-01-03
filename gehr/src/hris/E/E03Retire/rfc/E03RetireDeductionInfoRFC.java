/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : �����߰�����                                                 */
/*   Program Name : �����߰�������Ȳ                                   */
/*   Program ID   : E03RetireDeductionInfoRFC                                         */
/*   Description  : �����߰�������Ȳ                           */
/*   Note         : [���� RFC] : ZSOLRP_RFC_CHECK_REQ_OR_DEL                                                  */
/*   Creation     : 2010-07-07 �ڹο�                                           */
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String datum) throws GeneralException {
        String fieldName1 = "PERNR";
        String fieldName2 = "DATUM";
        setField( function, fieldName1, empNo );
        setField( function, fieldName2, datum );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
    private Object getOutput(JCO.Function function, E03RetireDeductionInfoData data) throws GeneralException {
    	return getFields(data, function);
    }

}	

