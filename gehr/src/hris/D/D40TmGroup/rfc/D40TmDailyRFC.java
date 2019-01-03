/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   일일근태 입력 현황										*/
/*   Program Name	:   일일근태 입력 현황										*/
/*   Program ID		: D40TmDailyRFC.java									*/
/*   Description		: 일일근태 입력 현황										*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40TmDailyData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40TmDailyRFC.java
 * 일일근태 입력 현황
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40TmDailyRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_DAILY";
    /**
     * 일일근태 입력 현황 조회
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getTmDaily(String empNo, String I_SCHKZ,String I_BEGDA, String I_ENDDA, String I_SELTAB, Vector OBJID, Vector T_IMPERS, Vector T_IMINFTY,Vector T_IMWTMCD) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);				//사원 번호
            setField(function, "I_SCHKZ", I_SCHKZ);			//선택된 계획근무
            setField(function, "I_BEGDA", I_BEGDA);			//조회시작일
            setField(function, "I_ENDDA", I_ENDDA);			//조회종료일

            setTable(function, "T_IMPERS", T_IMPERS);			//선택된 사원번호
            setTable(function, "T_IMINFTY", T_IMINFTY);		//선택된 인포타입
            setTable(function, "T_IMWTMCD", T_IMWTMCD);	//선택된 유형

            if("A".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTA", OBJID);
            }else if("B".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTB", OBJID);
            }else if("C".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTC", OBJID);
            }
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

    	Vector T_EXLIST  = getTable(D40TmDailyData.class, function, "T_EXLIST");				//입력현황조회
    	Vector T_SCHKZ  = getTable(D40TmDailyData.class, function, "T_SCHKZ");				//계획근무 코드-텍스트
//    	Vector T_WTMCODE  = getTable(D40TmDailyData.class, function, "T_WTMCODE");		//유형 코드-텍스트

    	Vector T_EXINFTY  = getTable(D40TmDailyData.class, function, "T_EXINFTY");			//선택된 인포타입
    	Vector T_EXWTMCD  = getTable(D40TmDailyData.class, function, "T_EXWTMCD");		//선택된 유형

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName1 = "E_BEGDA";	//조회시작일
    	String fieldName2 = "E_ENDDA";	//조회종료일

    	String E_BEGDA  = getField(fieldName1, function);
    	String E_ENDDA  = getField(fieldName2, function);

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(T_EXLIST);		//입력현황조회
    	ret.addElement(T_SCHKZ);			//계획근무
    	ret.addElement(T_EXINFTY);		//선택된 인포타입
    	ret.addElement(T_EXWTMCD);	//선택된 유형
    	ret.addElement(E_BEGDA);			//조회시작일
    	ret.addElement(E_ENDDA);			//조회종료일

    	return ret;
    }



}


