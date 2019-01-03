/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   공통														*/
/*   2Depth Name		:   기본값설정												*/
/*   Program Name	:   기본값설정												*/
/*   Program ID		: D40RemeInfoEachRFCV.java							*/
/*   Description		: 기본값설정													*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40DefaultSettingData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40DefaultSettingRFC.java
 * 기본값설정
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40DefaultSettingRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_SELECT_OPTION";
    /**
     * 기본값 설정 조회
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getDefaultSetting(String empNo, String I_SCREEN) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);			//사원 번호
            setField(function, "I_SCREEN", I_SCREEN);	//사용될 스크린(화면)

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

    	Vector T_WTMCODE  = getTable(D40DefaultSettingData.class, function, "T_WTMCODE");	//유형
    	Vector T_REASON  = getTable(D40DefaultSettingData.class, function, "T_REASON");	//사유
    	Vector T_YN_DATA  = getTable(D40DefaultSettingData.class, function, "T_YN_DATA");	//입력여부Y/N
    	Vector T_EXCEP  = getTable(D40DefaultSettingData.class, function, "T_EXCEP");	//입력여부Y/N

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(T_WTMCODE);	//유형
    	ret.addElement(T_REASON);		//사유
    	ret.addElement(T_YN_DATA);		//입력여부Y/N
    	ret.addElement(T_EXCEP);			//기타

    	return ret;
    }



}


