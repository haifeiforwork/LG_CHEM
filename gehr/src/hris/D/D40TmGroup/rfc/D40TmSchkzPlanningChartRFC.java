/********************************************************************************/
/*																											*/
/*   System Name	: MSS																		*/
/*   1Depth Name		: 부서근태																	*/
/*   2Depth Name		: 계획근무일정 - 근무계획표                              						*/
/*   Program Name	: 계획근무일정 - 근무계획표                        							*/
/*   Program ID		: D40TmSchkzPlanningChartRFC.java								*/
/*   Description		: 계획근무일정 - 근무계획표												*/
/*   Note				: 없음																			*/
/*   Creation  			: 2017-12-08 정준현														*/
/*   Update   			: 2017-12-08 정준현														*/
/*																											*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40TmSchkzPlanningChartCodeData;
import hris.D.D40TmGroup.D40TmSchkzPlanningChartData;
import hris.D.D40TmGroup.D40TmSchkzPlanningChartNoteData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40TmSchkzPlanningChart.java
 * 계획근무일정 > 근무계획표 조회
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40TmSchkzPlanningChartRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_GET_WORK_SCHEDULE";
    /**
     * 근무계획표 조회
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getPlanningChart(String empNo, String I_SELTAB, Vector OBJID, String I_DATUM, String I_ENDDA, String I_SCHKZ, Vector T_IMPERS) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_DATUM", I_DATUM);
            setField(function, "I_ENDDA", I_ENDDA);
            setField(function, "I_SCHKZ", I_SCHKZ);
            setField(function, "I_RMODE", "C");

            setTable(function, "T_IMPERS", T_IMPERS);

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

    	Vector T_EXPORTA = getTable(D40TmSchkzPlanningChartData.class,  function, "T_EXPORTA");//근무계획표-TITLE
    	Vector T_EXPORTB = getTable(D40TmSchkzPlanningChartNoteData.class,  function, "T_EXPORTB"); // 근무계획표-데이타.
    	Vector T_TPROG = getTable(D40TmSchkzPlanningChartCodeData.class,  function, "T_TPROG"); //일일근무상세설명
    	Vector T_SCHKZ = getTable(D40TmSchkzPlanningChartCodeData.class,  function, "T_SCHKZ"); //계획근무

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String E_INFO  = getField("E_INFO", function) ;	// 안내문구

    	String E_BEGDA  = getField("E_BEGDA", function) ;	// 리턴 조회시작일
    	String E_ENDDA  = getField("E_ENDDA", function) ;	// 리턴 조회종료일

		ret.addElement(E_INFO);		//안내문구 0
    	ret.addElement(E_RETURN);	// 1
    	ret.addElement(E_MESSAGE);	//2
    	ret.addElement(T_SCHKZ);	//계획근무 3
    	ret.addElement(T_TPROG);	//일일근무상세설명 4
    	ret.addElement(T_EXPORTA);	//근무계획표-TITLE 5
    	ret.addElement(T_EXPORTB);	//근무계획표-DATA 6
    	ret.addElement(E_BEGDA);	//리턴 조회시작일 7
    	ret.addElement(E_ENDDA);	//리턴 조회종료일  8
        return ret;
    }


	public Vector savePlanningChart(String empNo, String I_ACTTY, Vector OBJID, String I_DATUM, String I_ENDDA) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            setField(function, "I_DATUM", I_DATUM);
            setField(function, "I_ENDDA", I_ENDDA);
            setField(function, "I_RMODE", "C");

            setTable(function, "T_IMPORT", OBJID);

            excute( mConnection, function );

            Vector ret = getOutput2( function );

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	private Vector getOutput2(JCO.Function function) throws GeneralException {

		Vector ret = new Vector();

    	Vector T_EXPORTA = getTable(D40TmSchkzPlanningChartData.class,  function, "T_EXPORTA");//근무계획표-TITLE
    	Vector T_EXPORTB = getTable(D40TmSchkzPlanningChartNoteData.class,  function, "T_EXPORTB"); // 근무계획표-데이타.
    	Vector T_TPROG = getTable(D40TmSchkzPlanningChartCodeData.class,  function, "T_TPROG"); //일일근무상세설명
    	Vector T_SCHKZ = getTable(D40TmSchkzPlanningChartCodeData.class,  function, "T_SCHKZ"); //계획근무
    	Vector T_EXERR = getTable(D40TmSchkzPlanningChartNoteData.class,  function, "T_EXERR"); //오류내역

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String E_INFO  = getField("E_INFO", function) ;	// 안내문구

    	String E_BEGDA  = getField("E_BEGDA", function) ;	// 조회시작일
    	String E_ENDDA  = getField("E_ENDDA", function) ;	// 조회종료일

		ret.addElement(E_INFO);		//안내문구
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_SCHKZ);	//계획근무
    	ret.addElement(T_TPROG);	//일일근무상세설명
    	ret.addElement(T_EXPORTA);	//근무계획표-TITLE
    	ret.addElement(T_EXPORTB);	//근무계획표-DATA
    	ret.addElement(T_EXERR);	//오류내역
    	ret.addElement(E_BEGDA);	// 조회시작일
    	ret.addElement(E_ENDDA);	// 조회종료일
        return ret;

    }



}


