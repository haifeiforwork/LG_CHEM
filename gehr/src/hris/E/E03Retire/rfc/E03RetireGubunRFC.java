/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금                                                 */
/*   Program Name : 퇴직연금 가입구분                                   */
/*   Program ID   : E03RetireGubunRFC                                         */
/*   Description  : 퇴직연금 가입구분                           */
/*   Note         : [관련 RFC] : ZSOLRP_GET_REPEGUBN                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
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
            setInput(function, "D", empNo, begda, edda);	//퇴직연금 가입구분 D
            excute(mConnection, function);
           
            E03RetireGubunData data = (E03RetireGubunData)getOutput(function, (new E03RetireGubunData()));

            String retireType = data.E_REPE_GUBN;
            
            if(retireType.equals("1"))
            	return "DB";
            else if(retireType.equals("2"))
            	return "DC";
            else
            	return "";	//설정 안된 사람은 아무것도 안되게..
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
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
    private Object getOutput(JCO.Function function, E03RetireGubunData data) throws GeneralException {
    	return getFields(data, function);
    }

}
