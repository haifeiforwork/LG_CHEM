/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서휴가현황                                                */
/*   Program ID   : ViewDeptVacationRFC                                         */
/*   Description  : 초기화면에서 부서 휴가 현황을 보는 RFC 파일                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-17 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

 
/**
 * ViewDeptVacationRFC
 * 초기화면에서 부서 휴가 현황을 위해 RFC를 호출하는 Class
 *
 * @author 유용원   
 * @version 1.0, 2005/03/17
 */
public class ViewDeptVacationRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_ORGEH_HOLI_RATE";

    /**
     * 부서코드으로 휴가정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Object getDeptVacation( String i_deptid, String i_lower ) throws GeneralException {
        
        JCO.Client mConnection = null; 
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_deptid, i_lower);
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
    private void setInput(JCO.Function function, String i_deptid, String i_lower) throws GeneralException {
        String fieldName1  = "I_ORGEH";
        setField(function, fieldName1,  i_deptid);
        String fieldName2  = "I_LOWERYN";
        setField(function, fieldName2,  i_lower);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	// Table 결과 조회
        String entityName = "hris.common.ViewDeptVacationData";
        String tableName = "T_EXPORT";
        return getTable(entityName, function, tableName);
    }
}


