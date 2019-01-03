/********************************************************************************/
/*																											*/
/*   System Name	: MSS																		*/
/*   1Depth Name		: 부서근태																	*/
/*   2Depth Name		: 근태그룹정의 - 인원지정                                   						*/
/*   Program Name	: 근태그룹정의 - 인원지정                                 						*/
/*   Program ID		: D40TmGroupPersRFC.java											*/
/*   Description		: 근태그룹정의 - 인원지정													*/
/*   Note				: 없음																			*/
/*   Creation  			: 2017-12-08 정준현														*/
/*   Update   			: 2017-12-08 정준현														*/
/*																											*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40TmGroupPersRFC.java
 * 근태그룹정의 - 인원지정 RFC
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40TmGroupPersRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_TIME_GRUP_PERS";
    /**
     * 근태그룹관리 조회조건 조회
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getTmGroupPersList(String empNo, String I_GTYPE, String I_PABRJ, String I_PABRP, String I_SEQNO) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", empNo);
            setField(function, "I_GTYPE", I_GTYPE);
            setField(function, "I_PABRJ", I_PABRJ);
            setField(function, "I_PABRP", I_PABRP);
            setField(function, "I_SEQNO", I_SEQNO);
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
     * 근태그룹정의 - 인원지정 저장
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector saveTmGroupPersList(String empNo, String I_GTYPE, String I_PABRJ, String I_PABRP, String I_SEQNO, Vector save_vt) throws GeneralException {
		JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, save_vt, "T_IMLIST", empNo, I_GTYPE, I_PABRJ, I_PABRP, I_SEQNO  );

            excute( mConnection, function );
        	Vector ret = new Vector();

        	String E_RETURN   = getReturn().MSGTY;
        	String E_MESSAGE   = getReturn().MSGTX;

        	ret.addElement(E_RETURN);
        	ret.addElement(E_MESSAGE);
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	private void setInput(JCO.Function function, Vector entityVector, String tableName
			, String I_PERNR, String I_GTYPE, String I_PABRJ, String I_PABRP, String I_SEQNO ) throws GeneralException {
        setTable(function, tableName, entityVector);
        String fieldName = "I_PERNR";
        setField( function, fieldName, I_PERNR );
        String fieldName1 = "I_GTYPE";
        setField( function, fieldName1, I_GTYPE );
        String fieldName2 = "I_PABRJ";
        setField( function, fieldName2, I_PABRJ );
        String fieldName3 = "I_PABRP";
        setField( function, fieldName3, I_PABRP );
        String fieldName4 = "I_SEQNO";
        setField( function, fieldName4, I_SEQNO );
    }

	/**
	 * 근태그룹관리 조회조건 조회
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getTmGroupPers(String empNo, String I_GTYPE, String I_PABRJ, String I_PABRP, String I_SEQNO, Vector get_vt) throws GeneralException {
		JCO.Client mConnection = null;
		try{
			mConnection = getClient();
			JCO.Function function = createFunction( functionName ) ;

			setField(function, "I_PERNR", empNo);
			setField(function, "I_GTYPE", I_GTYPE);
			setField(function, "I_PABRJ", I_PABRJ);
			setField(function, "I_PABRP", I_PABRP);
			setField(function, "I_SEQNO", I_SEQNO);

			setTable(function, "T_IMLIST", get_vt);

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
        String entityName = "hris.D.D40TmGroup.D40TmGroupPersData";
        String tableName  = "T_EXLIST";

    	Vector OBJPS_OUT  = getTable(entityName, function, tableName);

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(OBJPS_OUT);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
        return ret;
    }

}


