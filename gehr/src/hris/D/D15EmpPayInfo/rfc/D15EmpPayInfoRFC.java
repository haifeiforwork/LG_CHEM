package hris.D.D15EmpPayInfo.rfc;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.D.D15EmpPayInfo.D15EmpPayInfoData;

import java.util.Vector;

public class D15EmpPayInfoRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_DAY_2010" ;
	
	/**
	 * 조직코드로 사원임금정보 조회
	 * @param I_DATUM
	 * @param searchdata
	 * @return
	 * @throws GeneralException
	 */
	public Vector<D15EmpPayInfoData> getPayList( String I_DATUM, String searchdata, String searchType) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            /** '1':SEE, '6':SUM, '2':INS, '4':DEL */
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, I_DATUM, searchdata, "1", searchType);

            excute( mConnection, function );
            
            return getOutput( function );

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
	

	/**
	 * 조직코드로 사원임금정보 조회
	 * @param I_DATUM
	 * @param searchdata
	 * @return
	 * @throws GeneralException
	 */
	public Vector<D15EmpPayInfoData> getSaveList(String I_DATUM, String searchdata, String searchType) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, I_DATUM, searchdata, "6", searchType);

            excute( mConnection, function );
            
            return getOutput( function );

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

	/**
	 * 사원임금정보 데이터 입력(조직코드용)
	 * @param I_DATUM
	 * @param searchdata
	 * @param empPayInfoData_vt
	 * @return
	 * @throws GeneralException
	 */
	public RFCReturnEntity saveEmpPayInfo(String I_DATUM, String searchdata, Vector empPayInfoData_vt, String searchType) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, I_DATUM, searchdata, "2", searchType);
            setTable(function, "T_RESULT", empPayInfoData_vt);

            excute( mConnection, function );
            
            return getReturn();

        } catch(Exception e){
            Logger.error(e);
            throw new GeneralException(e);
        } finally {
            close(mConnection);
        }
    }
	

	public RFCReturnEntity deleteEmpPayInfo( Vector empPayInfoData_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_GTYPE", "4");
            setTable(function, "T_RESULT", empPayInfoData_vt);

            excute( mConnection, function );

            return getReturn();

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
	
	/**
	 * 조직코드로 넘겨받은 파라미터 입력
	 * @param function
	 * @param I_DATUM
	 * @param searchData
	 * @param I_GTYPE
	 * @throws GeneralException
	 */
	private void setInput(JCO.Function function, String I_DATUM, String searchData, String I_GTYPE, String searchType) throws GeneralException {
        setField( function, "I_DATUM", I_DATUM );

        if("ORGEH".equals(searchType))
            setField( function, "I_ORGEH", searchData );
        else if("PERNR".equals(searchType))
            setField( function, "I_PERNR", searchData );

        setField( function, "I_GTYPE", I_GTYPE );
    }

	
	/**
	 * 일일근무일정 정보
	 * @param function
	 * @return
	 * @throws GeneralException
	 */
	private Vector<D15EmpPayInfoData> getOutput(JCO.Function function) throws GeneralException {

        return getTable(D15EmpPayInfoData.class, function, "T_RESULT");
    }
}
