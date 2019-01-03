/********************************************************************************/
/*   System Name  : MSS                                                  	 */
/*   1Depth Name  :                           	 */
/*   2Depth Name  :                                  	 */
/*   Program Name :                         	 */
/*   Program ID   : BukrsCodeByOrgehRFCEurp                  	 */
/*   Description  : 부서코드으로 법인코드 조회를 위한 servlet[유럽용] */
/*   Note         : 없음                                                        			 	 */
/*   Creation     : 2010-07-30 yji                                             */
/********************************************************************************/
package hris.common.rfc;

import java.util.*;

import com.sap.mw.jco.*;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.DataUtil;

/**
 * BukrsCodeByOrgehRFCEurp.java
 * 부서코드로 법인코드를 조회하는 RFC를 호출한다.[유럽]
 *
 * @author yji
 * @version 1.0, 2010/07/30
 */
public class BukrsCodeByOrgehRFCEurp extends SAPWrap {

    private String functionName = "ZHR_GET_BUKRS_OF_ORGEH";

    /**
     * 부서코드으로 법인코드를 가져오는 RFC를 호출하는 Method
     *
     * @param java.lang.String 사원이름
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getBukrsCode( String i_orgCd) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgCd);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            Logger.warn.println("BukrsCodeByOrgehRFCEurp Result:: " + ret.toString());

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
    private void setInput(JCO.Function function, String i_orgeh) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);

        String fieldName1 = "I_DATUM";
        setField( function, fieldName1, DataUtil.getCurrentDate() );
    }


    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	String E_RETURN  = getField("E_RETURN", function );
    	String E_BUKRS  = getField("E_BUKRS", function );
        String E_BUTXT  = getField("E_BUTXT", function );
        Vector vt = new Vector(2);
        vt.addElement(E_RETURN);
        vt.addElement(E_BUKRS);
        vt.addElement(E_BUTXT);
        return vt;
    }
}
