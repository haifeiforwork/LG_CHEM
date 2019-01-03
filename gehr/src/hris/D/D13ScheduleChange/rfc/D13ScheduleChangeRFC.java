package hris.D.D13ScheduleChange.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.D.D13ScheduleChange.D13ScheduleChangeData;

import java.util.Vector;

public class D13ScheduleChangeRFC extends SAPWrap {
	private String functionName = "ZGHR_RFC_MOD_DWS" ;//ZHRW_RFC_MOD_DWS //국내
	
	/**
	 * 조회일자, 조회부서코드로 일일근무일정 데이터를 가져옴
	 * @return
	 * @throws GeneralException
	 */
	
	public D13ScheduleChangeRFC() {
		super();
		if (!g.getSapType().isLocal()){
			functionName="ZGHR_MOD_DWS";//해외
		}
	}
	public Vector getScheduleForOrgeh(String i_orgeh, String i_loweryn, String i_begda, String i_endda ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInputForOrgeh( function, i_begda, i_endda, i_orgeh, "1" , i_loweryn);//SEE
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
	
	/**
	 * 조회일자, 조회부서코드로 일일근무일정 데이터를 가져옴
	 * @param i_datum
	 * @return
	 * @throws GeneralException
	 */
	public Vector getScheduleForPernr( String i_datum, String i_pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInputForPernr( function, i_datum, i_pernr, "1" );//SEE
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
	
	public Vector setScheduleForOrgeh( String i_datum, String i_orgeh, String i_pernr, Vector scheduleChangeData_vt, String i_loweryn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;
            if (g.getSapType().isLocal()){
            	setInputDataForOrgeh( function, i_datum, i_orgeh, i_pernr, scheduleChangeData_vt, "2",  i_loweryn );//국내는 2로 추가,수정
            }else{
            	setInputDataForOrgeh( function, i_datum, i_orgeh, i_pernr, scheduleChangeData_vt, "3",  i_loweryn );//1': 조회, '2':insert, '3' update , '4':삭제, '7':엑셀업로드 체크
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
	
	public Vector setScheduleForPernr( String i_datum, String i_pernr, Vector scheduleChangeData_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInputDataForPernr( function, i_datum, i_pernr, scheduleChangeData_vt, "2" );//INS
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
	
	/**
	 * 조회일자, 부서코드, I_COMMAND 입력한다
	 * @param function
	 * @param i_orgeh
	 * @param i_command
	 * @throws GeneralException
	 */
	private void setInputForOrgeh(JCO.Function function, String i_begda, String i_endda, String i_orgeh, String i_command, String i_loweryn) throws GeneralException {
		if(g.getSapType().isLocal()){
			setField( function, "I_DATUM", i_begda );
		}else{
	        setField( function, "I_BEGDA", i_begda );
	        setField( function, "I_ENDDA", i_endda );
		}
		setField( function, "I_ORGEH", i_orgeh );
        setField( function, "I_GTYPE", i_command ); //I_COMMAND
        setField( function, "I_LOWERYN", i_loweryn); //I_COMMAND
    }
	
	/**
	 * 조회일자, 사원번호, I_COMMAND 입력한다
	 * @param function
	 * @param i_datum
	 * @param i_command
	 * @throws GeneralException
	 */
	private void setInputForPernr(JCO.Function function, String i_datum, String i_pernr, String i_command) throws GeneralException {
        setField( function, "I_DATUM", i_datum );
        setField( function, "I_PERNR", i_pernr );
        setField( function, "I_GTYPE", i_command );//I_COMMAND
        setField( function, "I_LOWERYN", "N"); //I_COMMAND
    }
	
	/**
	 * 변경된 일일근무유형 저장
	 * @param function
	 * @param i_datum
	 * @param i_orgeh
	 * @param scheduleChangeData_vt
	 * @param i_command
	 * @throws GeneralException
	 */
	private void setInputDataForOrgeh(JCO.Function function, String i_datum, String i_orgeh, String i_pernr, Vector scheduleChangeData_vt, String i_command, String i_loweryn) throws GeneralException {
        setField( function, "I_DATUM", i_datum );
        setField( function, "I_ORGEH", i_orgeh );
        setField( function, "I_PERNR", i_pernr );
        setTable( function, "T_RESULT", scheduleChangeData_vt);//P_RESULT
        setField( function, "I_GTYPE", i_command );//I_COMMAND
        setField( function, "I_LOWERYN", i_loweryn); //I_COMMAND
    }
	
	/**
	 * 변경된 일일근무유형 저장
	 * @param function
	 * @param i_datum
	 * @param i_pernr
	 * @param scheduleChangeData_vt
	 * @param i_command
	 * @throws GeneralException
	 */
	private void setInputDataForPernr(JCO.Function function, String i_datum, String i_pernr, Vector scheduleChangeData_vt, String i_command) throws GeneralException {
        setField( function, "I_DATUM", i_datum );
        setField( function, "I_PERNR", i_pernr );
        setTable( function, "T_RESULT", scheduleChangeData_vt); //P_RESULT
        setField( function, "I_GTYPE", i_command );//I_COMMAND
    }
	
	/**
	 * 일일근무일정 정보
	 * @param function
	 * @return
	 * @throws GeneralException
	 */
	private Vector getOutput(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();
        
        Vector T_RESULT  = getTable("hris.D.D13ScheduleChange.D13ScheduleChangeData", function, "T_RESULT");//P_RESULT
    	   	
    	ret.addElement(T_RESULT);
    	
        return ret;
    }

    public Vector delete(String i_orgeh, String I_PERNR, String i_loweryn, Vector d13ScheduleChangeData_vt) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_GTYPE", "4");//1': 조회, '2':insert, '3' update , '4':삭제, '7':엑셀업로드 체크
            setField( function, "I_ORGEH", i_orgeh );
            setField(function, "I_PERNR", I_PERNR);
            setTable(function, "T_RESULT", d13ScheduleChangeData_vt);
            setField( function, "I_LOWERYN", i_loweryn); //I_COMMAND

            excute( mConnection, function );
            return  getTable(D13ScheduleChangeData.class, function, "T_RESULT");


        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
	
/*
    public Vector<D13ScheduleChangeData> validateRow(String I_PERNR, String I_ORGEH, Vector<D13ScheduleChangeData> T_RESULT) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_GTYPE", "7"); // EXCEL UPLOAD

            setTable(function, "T_RESULT", T_RESULT);

            excute(mConnection, function);

            return getTable(D13ScheduleChangeData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
*/
    public Vector<D13ScheduleChangeData> saveRow(String I_PERNR, String I_ORGEH, Vector<D13ScheduleChangeData> T_RESULT) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_GTYPE", "2"); // 1': 조회, '2':저장, '4':삭제, '7':엑셀업로드 체크


            setTable(function, "T_RESULT", T_RESULT); // 문제Row만 회신됨.

            excute(mConnection, function);

            return getTable(D13ScheduleChangeData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
}
