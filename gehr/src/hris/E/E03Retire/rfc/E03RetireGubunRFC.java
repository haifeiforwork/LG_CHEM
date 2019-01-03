/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : ��������                                                 */
/*   Program Name : �������� ���Ա���                                   */
/*   Program ID   : E03RetireGubunRFC                                         */
/*   Description  : �������� ���Ա���                           */
/*   Note         : [���� RFC] : ZSOLRP_GET_REPEGUBN                                                  */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire.rfc;

import hris.E.E03Retire.E03RetireGubunData;


import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;


public class E03RetireGubunRFC extends SAPWrap {
	
	private String functionName = "ZSOLRP_GET_REPEGUBN";
	
	public String getRetireGubunInfo(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            String begda = DateTime.getShortDateString();
            String edda = "99991231";
            setInput(function, "D", empNo, begda, edda);	//�������� ���Ա��� D
            excute(mConnection, function);
           
            E03RetireGubunData data = (E03RetireGubunData)getOutput(function, (new E03RetireGubunData()));

            String retireType = data.E_REPE_GUBN;
            
            if(retireType.equals("1"))
            	return "DB";
            else if(retireType.equals("2"))
            	return "DC";
            else
            	return "";	//���� �ȵ� ����� �ƹ��͵� �ȵǰ�..
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
    private void setInput(JCO.Function function, String i_code, String empNo, String begda, String endda) throws GeneralException {
        String fieldName1 = "I_CODE";
        String fieldName2 = "I_PERNR";
        String fieldName3 = "I_BEGDA";
        String fieldName4 = "I_ENDDA";
        setField( function, fieldName1, i_code );
        setField( function, fieldName2, empNo );
        setField( function, fieldName3, begda );
        setField( function, fieldName4, endda );        
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
    private Object getOutput(JCO.Function function, E03RetireGubunData data) throws GeneralException {
    	return getFields(data, function);
    }

}
