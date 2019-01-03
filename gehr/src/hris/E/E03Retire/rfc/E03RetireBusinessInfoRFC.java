/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 연금사업자변경                                                 */
/*   Program Name : 연금사업자조회                                   */
/*   Program ID   : E03RetireBusinessInfoRFC                                         */
/*   Description  : 개인별 연금사업자                                    */
/*   Note         : [관련 RFC] : ZSOLRP_GET_REPEGUBN                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire.rfc;

import hris.E.E03Retire.E03RetireBusinessInfoData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.DateTime;

public class E03RetireBusinessInfoRFC extends SAPWrap {

    private String functionName = "ZSOLRP_GET_REPEGUBN";   

    /**
     * 개일별 연금사업자 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public E03RetireBusinessInfoData getRetireBusinessInfo( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            String begda = DateTime.getShortDateString();
            String edda = "99991231";
            setInput(function, empNo, begda, edda);
            excute(mConnection, function);
            
            E03RetireBusinessInfoData data = (E03RetireBusinessInfoData)getOutput(function, (new E03RetireBusinessInfoData()));

            return data;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String begda, String edda) throws GeneralException {
        String fieldName1  = "I_CODE";
        setField( function, fieldName1, "C" );
        String fieldName2 = "I_PERNR";
        setField( function, fieldName2, empNo );
        String fieldName3 = "I_BEGDA";
        setField( function, fieldName3, begda );
        String fieldName4 = "I_ENDDA";
        setField( function, fieldName4, edda );               
    }

    // Import Parameter 가 Vector(Table) 인 경우
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

   
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
    private Object getOutput(JCO.Function function, E03RetireBusinessInfoData data) throws GeneralException {
    	return getFields(data, function);
    }
    
}
