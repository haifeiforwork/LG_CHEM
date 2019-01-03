/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직금                                               */
/*   2Depth Name  : 퇴직금 조회                                                 */
/*   Program Name : 퇴직금 조회 - DC사용자                                 */
/*   Program ID   : E03RetireDCSimulRFC                                         */
/*   Description  : 퇴직금 조회 - DC사용자                            */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_GET_DEDUCTION_WHOLE                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
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
	
	private String functionName = "ZSOLRP_RFC_GET_DEDUCTION_WHOLE"; //DC 사용자 퇴직금

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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        
        setField( function, fieldName1, empNo);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
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

