/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   조직관리													*/
/*   2Depth Name		:   조직/인원현황 - 근태현황								*/
/*   Program Name	:   부서근태담당자											*/
/*   Program ID		: D40TmPersInAuthRFC.java							*/
/*   Description		: 부서근태담당자											*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40TmPersInAuthData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40TmPersInAuthRFC.java
 * 부서근태담당자
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40TmPersInAuthRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_PERS_IN_AUTH_LIST";
    /**
     * 현장직근태-부서근태담당자 조회
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getTmPersInAuth(String deptId, String I_DATUM) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_ORGEH", deptId);		//선택된 조직 코드
            setField(function, "I_DATUM", I_DATUM);	//선택된 일자

            excute( mConnection, function );

            Vector ret = getOutput( function );

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}


	private Vector getOutput(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();

    	Vector T_EXLIST  = getTable(D40TmPersInAuthData.class, function, "T_EXLIST");	//입력현황조회

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(T_EXLIST);		//입력현황조회
        return ret;
    }



}


