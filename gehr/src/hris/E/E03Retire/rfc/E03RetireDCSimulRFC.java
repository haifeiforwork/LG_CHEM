/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ������                                               */
/*   2Depth Name  : ������ ��ȸ                                                 */
/*   Program Name : ������ ��ȸ - DC�����                                 */
/*   Program ID   : E03RetireDCSimulRFC                                         */
/*   Description  : ������ ��ȸ - DC�����                            */
/*   Note         : [���� RFC] : ZSOLRP_RFC_GET_DEDUCTION_WHOLE                                                  */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire.rfc;

import hris.E.E03Retire.E03RetireDCSimulData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


public class E03RetireDCSimulRFC extends SAPWrap{
	
	private String functionName = "ZSOLRP_RFC_GET_DEDUCTION_WHOLE"; //DC ����� ������

	public Vector setRetireList(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);
            setInput(function, empNo);
            excute(mConnection, function);
            Vector v = (Vector)getOutput(function, new E03RetireDCSimulData());
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
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        
        setField( function, fieldName1, empNo);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
   
    private Vector getOutput(JCO.Function function, E03RetireDCSimulData data) throws GeneralException {
    	Vector v_table = new Vector();

    	v_table = getTable("hris.E.E03Retire.E03RetireDCSimulData", function, "DED_ITAB" );
    	
    	E03RetireDCSimulData d_field = (E03RetireDCSimulData)getFields(data, function);
    	
    	Vector ret = new Vector();
    	ret.addElement(v_table);
    	ret.addElement(d_field);
        return ret ;
 
    }    

}	

