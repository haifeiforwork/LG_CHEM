/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 휴가현황                                                    */
/*   Program ID   : ViewEmpVacationRFC                                          */
/*   Description  : 초기화면에서 사원 휴가 현황을 보는 RFC 파일                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-03 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common.rfc;

import hris.common.ViewEmpVacationData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

 
/**
 * ViewEmpVacationRFC
 * 초기화면에서 사원 휴가 현황을 위해 RFC를 호출하는 Class
 *
 * @author 유용원   
 * @version 1.0, 2005/03/03
 */
public class ViewEmpVacationRFC extends SAPWrap {

    private String functionName = "ZHRP_GET_NO_OF_WORKDAY";

    /**
     * 사번으로 휴가정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사번
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Object getEmpVacation( String i_empId ) throws GeneralException {
        
        JCO.Client mConnection = null; 
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_empId);
            excute(mConnection, function);
            Object ret = getOutput(function);
             
            return ret;
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
    private void setInput(JCO.Function function, String i_empId) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName,  i_empId);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Object getOutput(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
 
    	// Table 결과 조회
    	ViewEmpVacationData vacation = new ViewEmpVacationData();
    	Object E_WORK  = getStructor(vacation,  function, "E_WORK"); 
    	
    	return E_WORK;
    }
}


