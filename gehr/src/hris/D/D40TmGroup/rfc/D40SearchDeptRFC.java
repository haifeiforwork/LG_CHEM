/********************************************************************************/
/*																											*/
/*   System Name	: MSS																		*/
/*   1Depth Name		: 부서근태																	*/
/*   2Depth Name		: 공통                                                           							*/
/*   Program Name	: 조직도                                   											*/
/*   Program ID		: D40SearchDeptRFC.java												*/
/*   Description		: 조직도																		*/
/*   Note				: 없음																			*/
/*   Creation  			: 2017-12-08 정준현														*/
/*   Update   			: 2017-12-08 정준현														*/
/*																											*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40SearchDeptRFC
 * 조직도
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40SearchDeptRFC extends SAPWrap {

	 private String functionName = "ZGHR_RFC_TM_GET_ORGEH_LIST";

    /**
     * 조직도 조회
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptName(String i_pernr, String i_objtxt, String i_authora, String I_DATUM) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_pernr, i_objtxt, i_authora, I_DATUM);
            excute(mConnection, function);
            Vector ret = getOutput(function);

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
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_pernr, String i_objtxt, String i_authora, String I_DATUM) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName, i_pernr);
        String fieldName1 = "I_OBJTXT";
        setField(function, fieldName1, i_objtxt);
        String fieldName2 = "I_AUTHOR";
        setField(function, fieldName2, i_authora);
        String fieldName3 = "I_DATUM";
        setField(function, fieldName3, I_DATUM);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();

    	// Table 결과 조회
    	Vector T_EXPORTA   = getTable(hris.common.SearchDeptNameData.class,  function, "T_EXPORTA");

    	ret.addElement(getReturn().MSGTY);
    	ret.addElement(getReturn().MSGTX);
    	ret.addElement(T_EXPORTA);

    	return ret;
    }

}


