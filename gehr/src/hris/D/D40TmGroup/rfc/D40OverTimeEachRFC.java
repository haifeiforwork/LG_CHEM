/********************************************************************************/
/*																				*/
/*   System Name	: MSS														*/
/*   1Depth Name	: 부서근태													*/
/*   2Depth Name	: 초과근무                                                         	*/
/*   Program Name	: 초과근무(개별)                                  			*/
/*   Program ID		: D40OverTimeEachRFC.java									*/
/*   Description	: 초과근무(개별)												*/
/*   Note			: 없음														*/
/*   Creation  		: 2017-12-08 정준현											*/
/*   Update   		: 2017-12-08 정준현											*/
/*   		   		: 2018-06-18 성환희 [WorkTime52]								*/
/*																				*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D40TmGroup.D40OverTime50OverWeekData;
import hris.D.D40TmGroup.D40OverTimeFrameData;
import hris.D.D40TmGroup.D40TmSchkzFrameData;


/**
 * D40OverTimeEachRFC.java
 * 현장직근태-초과근무(개별) 조회/저장/Excel
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40OverTimeEachRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_OVERTIME";
	/**
     * 초과근무(개별) 조회
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getDailScheEach(String empNo, String I_ACTTY, String I_BEGDA, String I_ENDDA, String I_SCHKZ, Vector T_IMPERS, String I_SELTAB, Vector OBJID) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);		//사원 번호
            setField(function, "I_BEGDA", I_BEGDA);	//조회시작일
            setField(function, "I_ENDDA", I_ENDDA);	//조회종료일
            setField(function, "I_ACTTY", I_ACTTY);	//실행모드
            setField(function, "I_SCHKZ", I_SCHKZ);	//계획근무Key
            setField(function, "I_NTM", "X");		//WorkTime52

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

    	Vector OBJPS_OUT1  = getTable(D40OverTimeFrameData.class, function, "T_SCHKZ");		//계획근무 코드-텍스트
    	Vector OBJPS_OUT2  = getTable(D40OverTimeFrameData.class, function, "T_EXLIST");	//조회된 정보
    	Vector OBJPS_OUT3  = getTable(D40OverTimeFrameData.class, function, "T_REASON");	//근태사유 코드-텍스트
    	Vector OBJPS_OUT4  = getTable(D40OverTimeFrameData.class, function, "T_REASON_F");	//근태사유 코드-텍스트
    	Vector OBJPS_OUT5  = getTable(D40OverTimeFrameData.class, function, "T_EXCEP");	//사유 기타

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName1 = "E_INFO";     // 안내문구
    	String fieldName2 = "E_BEGDA";	//조회시작일
    	String fieldName3 = "E_ENDDA";	//조회종료일

    	String E_INFO  = getField(fieldName1, function);
    	String E_BEGDA  = getField(fieldName2, function);
    	String E_ENDDA  = getField(fieldName3, function);


    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(E_INFO);			//안내문구
    	ret.addElement(E_BEGDA);			//조회시작일
    	ret.addElement(E_ENDDA);			//조회종료일
    	ret.addElement(OBJPS_OUT1);	//계획근무
    	ret.addElement(OBJPS_OUT2);	//조회된 정보
    	ret.addElement(OBJPS_OUT3);	//근태사유 코드-텍스트
    	ret.addElement(OBJPS_OUT4);	//근태사유 코드-텍스트
    	ret.addElement(OBJPS_OUT5);	//근태사유 코드-텍스트
        return ret;
    }

	/**
     * 초과근무(개별) 엑셀 템플릿
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getTmSchkzExcelDown(String empNo, String I_ACTTY, String I_SELTAB, Vector OBJID) throws GeneralException {

		JCO.Client mConnection = null;
        try{

        	mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            //setField(function, "I_YYYYMM", I_SELTAB);
            setField(function, "I_NTM", "X");		//WorkTime52

//            setTable(function, "T_IMPORTA", OBJID);
            if("B".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTB", OBJID);
            }else if("C".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTC", OBJID);
            }else if("A".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTA", OBJID);
            }

            excute(mConnection, function);
            Vector ret = getOutputExcel(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	private Vector getOutputExcel(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();
        String entityName = "hris.D.D40TmGroup.D40TmSchkzFrameData";
        String tableName  = "T_SHEET1";
    	Vector OBJPS_OUT  = getTable(entityName, function, tableName);
    	String tableName2  = "T_SHEET2";
    	Vector OBJPS_OUT2  = getTable(entityName, function, tableName2);

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(OBJPS_OUT);
    	ret.addElement(OBJPS_OUT2);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);

        return ret;
    }

	/**
     * 초과근무(개별) 엑셀 업로드 저장
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector saveRow(String empNo, String I_ACTTY,	Vector<D40TmSchkzFrameData> excelResultList) throws GeneralException {
		JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            setField(function, "I_NTM", "X");		//WorkTime52

            setTable(function, "T_IMLIST", excelResultList); // 문제Row만 회신됨.

            excute(mConnection, function);
            Vector ret = new Vector();
            Vector T_EXLIST = getTable(D40TmSchkzFrameData.class, function, "T_EXLIST");
            String E_RETURN   = getReturn().MSGTY;
        	String E_MESSAGE   = getReturn().MSGTX;
        	String E_SAVE_CNT   = getField("E_SAVE_CNT", function) ;

        	ret.addElement(E_RETURN);
        	ret.addElement(E_MESSAGE);
        	ret.addElement(T_EXLIST);
        	ret.addElement(E_SAVE_CNT);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	/**
     * 초과근무(개별) 화면 저장
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector saveTable(String empNo, String I_ACTTY,	Vector<D40OverTimeFrameData> dataList,String I_BEGDA, String I_ENDDA) throws GeneralException {

		JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            setField(function, "I_BEGDA", I_BEGDA);
            setField(function, "I_ENDDA", I_ENDDA);
            setField(function, "I_NTM", "X");		//WorkTime52

            setTable(function, "T_IMLIST", dataList); // 화면에서 수정된 리스트
//            setTable(function, "T_TEMP", dataList2); // 원본리스트

            excute(mConnection, function);

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

    	Vector OBJPS_OUT1  = getTable(D40OverTimeFrameData.class, function, "T_SCHKZ");	//계획근무
    	Vector OBJPS_OUT2  = getTable(D40OverTimeFrameData.class, function, "T_EXLIST");	//조회된 정보
    	Vector OBJPS_OUT3  = getTable(D40OverTimeFrameData.class, function, "T_REASON");	//근태사유
    	Vector OBJPS_OUT4  = getTable(D40OverTimeFrameData.class, function, "T_REASON_F");	//근태사유
    	Vector OBJPS_OUT5  = getTable(D40OverTimeFrameData.class, function, "T_EXCEP");	//사유 기타
    	Vector OBJPS_OUT6  = getTable(D40OverTime50OverWeekData.class, function, "T_50HOVER");	//주 50시간 초과자

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName1 = "E_INFO";     // 안내문구
    	String fieldName2 = "E_BEGDA";	//조회시작일
    	String fieldName3 = "E_ENDDA";	//조회종료일
    	String fieldName4 = "E_SAVE_CNT";	//조회종료일

    	String E_INFO  = getField(fieldName1, function);
    	String E_BEGDA  = getField(fieldName2, function);
    	String E_ENDDA  = getField(fieldName3, function);
    	String E_SAVE_CNT  = getField(fieldName4, function);

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(E_INFO);			//안내문구
    	ret.addElement(E_BEGDA);			//조회시작일
    	ret.addElement(E_ENDDA);			//조회종료일
    	ret.addElement(E_SAVE_CNT);	//저장시 건수 카운트 안내문구
    	ret.addElement(OBJPS_OUT1);	//계획근무
    	ret.addElement(OBJPS_OUT2);	//조회된 정보
    	ret.addElement(OBJPS_OUT3);	//일일근무
    	ret.addElement(OBJPS_OUT4);	//일일근무
    	ret.addElement(OBJPS_OUT5);	//기타
    	ret.addElement(OBJPS_OUT6);	//주 50시간 초과자

        return ret;

    }

	/**
     * 초과근무(개별) 행 조회
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getOverTimeEachOne(String empNo, String I_ACTTY,	Vector T_IMLIST) throws GeneralException {

		JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            setField(function, "I_NTM", "X");		//WorkTime52

            setTable(function, "T_IMLIST", T_IMLIST); // 문제Row만 회신됨.

            excute(mConnection, function);

            Vector ret = getOutput3( function );

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	private Vector getOutput3(JCO.Function function) throws GeneralException {

		Vector ret = new Vector();

    	Vector OBJPS_OUT1  = getTable(D40OverTimeFrameData.class, function, "T_EXLIST");	//조회된 정보

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(OBJPS_OUT1);	//조회된 정보

    	return ret;
	}

}


