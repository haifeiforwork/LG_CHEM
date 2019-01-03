/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표												*/
/*   Program Name	:   근태집계표 일간, 월간									*/
/*   Program ID		: D40RemeInfoEachRFCV.java							*/
/*   Description		: 근태집계표 일간, 월간									*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40DailStateData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40DailStateRFC.java
 * 근태집계표
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40DailStateRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_GET_WORK_CONDUCT";
    /**
     * 근태집계표 조회
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getDailState(String empNo, String I_ACTTY, String I_DATUM, String I_BEGDA, String I_ENDDA, String I_SCHKZ, String I_GUBUN, Vector T_IMPERS, String I_SELTAB, Vector OBJID) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);		//사원 번호
            setField(function, "I_BEGDA", I_BEGDA);	//조회시작일
            setField(function, "I_ENDDA", I_ENDDA);	//조회종료일
            setField(function, "I_SCHKZ", I_SCHKZ);	//계획근무Key
            setField(function, "I_ACTTY", I_ACTTY);	//실행모드
            setField(function, "I_GUBUN", I_GUBUN);	//1:월간,2:일일

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

    	Vector T_EXPORTA  = getTable(D40DailStateData.class, function, "T_EXPORTA");	//일간집계표 TITLE
    	Vector T_EXPORTB  = getTable(D40DailStateData.class, function, "T_EXPORTB");	//일간집계표 DATA
    	Vector T_EXPORTC  = getTable(D40DailStateData.class, function, "T_EXPORTC");	//월간집계표 DATA
    	Vector T_EXPORTD  = getTable(D40DailStateData.class, function, "T_EXPORTD");	//일간집계표 날짜
    	Vector T_SCHKZ  = getTable(D40DailStateData.class, function, "T_SCHKZ");		//계획근무 코드-텍스트

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
    	ret.addElement(E_BEGDA);			//조회시작일
    	ret.addElement(E_ENDDA);			//조회종료일
    	ret.addElement(E_DAY_CNT);		//일자수
    	ret.addElement(E_INFO);			//안내문구
    	ret.addElement(T_EXPORTA);		//일간집계표 TITLE
    	ret.addElement(T_EXPORTB);		//일간집계표 DATA
    	ret.addElement(T_EXPORTC);		//월간집계표 DATA
    	ret.addElement(T_EXPORTD);		//일간집계표 날짜
    	ret.addElement(T_SCHKZ);			//계획근무 코드-텍스트
        return ret;
    }



}


