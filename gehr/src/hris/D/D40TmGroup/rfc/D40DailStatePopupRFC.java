/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표												*/
/*   Program Name	:   일일근태 입력 현황 팝업								*/
/*   Program ID		: D40DailStatePopupRFC.java							*/
/*   Description		: 일일근태 입력 현황 팝업									*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40DailStatePopupData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40DailStatePopupRFC.java
 * 현장직근태-개인 일일근태 입력 현황
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40DailStatePopupRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_DAY_DETAIL";
    /**
     * 일일근태 입력 현황 조회
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getDailState(String I_PERNR, String I_BEGDA, String I_ENDDA) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", I_PERNR);	//사원 번호
            setField(function, "I_BEGDA", I_BEGDA);	//조회시작일
            setField(function, "I_ENDDA", I_ENDDA);	//조회종료일

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

    	Vector T_EXLIST  = getTable(D40DailStatePopupData.class, function, "T_EXLIST");		//입력현황조회

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName1 = "E_ENAME";	//성명

    	String E_ENAME  = getField(fieldName1, function);

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(E_ENAME);			//이름
    	ret.addElement(T_EXLIST);		//입력현황조회

        return ret;
    }



}


