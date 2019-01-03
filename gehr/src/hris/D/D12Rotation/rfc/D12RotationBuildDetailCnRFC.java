package hris.D.D12Rotation.rfc;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;

import hris.D.D12Rotation.D12RotationBuildCnData;
import hris.D.D12Rotation.D12RotationBuildCnExcelData;
import hris.common.approval.ApprovalSAPWrap;

import javax.servlet.http.HttpServletRequest;
import java.util.Vector;


/**
 * D12RoataionBuildCnRFC.java
 * 초과근무등록 RFC 를 호출하는 Class
 *
 * @author
 * @version
 */
public class D12RotationBuildDetailCnRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_OT_REQUEST_NJ";

    /**
     * 초과근무등록 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector<D12RotationBuildCnData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(D12RotationBuildCnData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * 초과근무등록 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector<D12RotationBuildCnData> getDetail(String I_ORGEH, String I_LOWERYN, String I_BEGDA, String I_ENDDA) throws GeneralException {

    	JCO.Client mConnection = null;

    	try{
    		mConnection = getClient();
    		JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            setField(function, "I_BEGDA", I_BEGDA);
            setField(function, "I_ENDDA", I_ENDDA);
            setField(function, "I_GTYPE", "1");

            excute(mConnection, function);

    		return getTable(D12RotationBuildCnData.class, function, "T_RESULT");

    	} catch(Exception ex){
    		Logger.error(ex);
    		throw new GeneralException(ex);
    	} finally {
    		close(mConnection);
    	}
    }

    /**
     * 초과근무 INSERT or UPDATE
     */
    public Vector setRotationBuild(String I_PERNR, String I_ORGEH, String I_LOWERYN, Vector<D12RotationBuildCnData> T_RESULT) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_GTYPE", "3");
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);

            setTable(function, "T_RESULT", T_RESULT);

            excute( mConnection, function );
            return  getTable(D12RotationBuildCnData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 초과근무 삭제 RFC 호출하는 Method
     */
    public Vector delete(String I_ORGEH, String I_LOWERYN, Vector d12RotationBuildDetatil_vt) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_GTYPE", "4");
            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);

            setTable(function, "T_RESULT", d12RotationBuildDetatil_vt);

            excute( mConnection, function );
            return  getTable(D12RotationBuildCnData.class, function, "T_RESULT");


        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


