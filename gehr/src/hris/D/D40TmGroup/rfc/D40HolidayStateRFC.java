/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표												*/
/*   Program Name	:   근태집계표 휴가사용현황								*/
/*   Program ID		: D40HolidayStateRFC.java								*/
/*   Description		: 근태집계표 휴가사용현황									*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40HolidayStateData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40HolidayStateRFC.java
 * 근태집계표 휴가사용현황
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40HolidayStateRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_GET_HOLIDAY_LIST";
    /**
     * 근태집계표 휴가사용현황
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getHolidayState(String empNo, String I_ACTTY, String I_BEGDA, String I_ENDDA, String I_SCHKZ, String I_DATUM, Vector T_IMPERS, String I_SELTAB, Vector OBJID) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);		//사원 번호
            setField(function, "I_BEGDA", I_BEGDA);	//조회시작일
            setField(function, "I_ENDDA", I_ENDDA);	//조회종료일
            setField(function, "I_SCHKZ", I_SCHKZ);	//계획근무Key
//            setField(function, "I_ACTTY", I_ACTTY);	//실행모드
//            setField(function, "I_GUBUN", I_GUBUN);	//1:월간,2:일일

            setTable(function, "T_IMPERS", T_IMPERS);	//선택된 사원번호

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

    	Vector T_EXPORTA  = getTable(D40HolidayStateData.class, function, "T_EXPORTA");	//휴가사용현황
//    	Vector T_SCHKZ  = getTable(D40DailStateData.class, function, "T_SCHKZ");		//계획근무 코드-텍스트

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName1 = "E_BEGDA";	//조회시작일
    	String fieldName2 = "E_ENDDA";	//조회종료일
    	String fieldName3 = "E_DAY_CNT";	//일자수
    	String fieldName4 = "E_INFO";     // 안내문구

    	String E_BEGDA  = getField(fieldName1, function);
    	String E_ENDDA  = getField(fieldName2, function);
    	String E_DAY_CNT  = getField(fieldName3, function);
    	String E_INFO  = getField(fieldName4, function);

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(T_EXPORTA);		//휴가사용현황
//    	ret.addElement(T_SCHKZ);			//계획근무 코드-텍스트
        return ret;
    }



}


