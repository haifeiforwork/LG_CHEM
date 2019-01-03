/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : �����߰�����                                                 */
/*   Program Name : �����߰����Խ���                                   */
/*   Program ID   : E03RetireDeductionListSearchRFC                                         */
/*   Description  : �����߰����Խ���                           */
/*   Note         : [���� RFC] : ZSOLRP_RFC_GET_DEDUCTION                                                  */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire.rfc;

import hris.E.E03Retire.E03RetireDeductionListData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DateTime;

public class E03RetireDeductionListSearchRFC extends SAPWrap{
	
	private String functionName = "ZSOLRP_RFC_GET_DEDUCTION"; //��������

	public Vector setRetireList(String empNo, Box box) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);
            	
            String datum = DateTime.getShortDateString();
            setInput(function, empNo, box.getString("year"), datum);
            excute(mConnection, function);
           
            Vector v = (Vector)getOutput(function, new E03RetireDeductionListData());
            return v;
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
    private void setInput(JCO.Function function, String empNo, String year, String datum) throws GeneralException {
        String fieldName1 = "I_PERNR";
        String fieldName2 = "I_YEAR";
        String fieldName3 = "I_BEGDA";
        String fieldName4 = "I_ENDDA";
        String fieldName5 = "I_DATUM";
        String fieldName6 = "I_SAP01";  
        
        setField( function, fieldName1, empNo);
        setField( function, fieldName2, year);
        setField( function, fieldName3, year+"0101");
        setField( function, fieldName4, year+"1231");
        setField( function, fieldName5, datum);
        setField( function, fieldName6, "");
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
   
    private Vector getOutput(JCO.Function function, E03RetireDeductionListData data) throws GeneralException {
    	Vector v_table = new Vector();

    	v_table = getTable("hris.E.E03Retire.E03RetireDeductionListData", function, "E_DED_ITAB" );
    	
    	E03RetireDeductionListData d_field = (E03RetireDeductionListData)getFields(data, function);
    	
    	Vector ret = new Vector();
    	ret.addElement(v_table);
    	ret.addElement(d_field);
        return ret ;
 
    }    

}	

