package hris.common.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.common.EmpGubunData;

/**
 * GetEmpGubunRFC.java
 * [WorkTime52] 사원 (근무)구분 산출 RFC
 *
 * @author 성환희
 * @version 1.0, 2018/05/16
 */
public class GetEmpGubunRFC extends SAPWrap {
	
	private String functionName = "ZGHR_RFC_NTM_TPGUP_GET";
	
	/**
     *  사원 (근무)구분을 가져오는 RFC를 호출하는 Method
     *  @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<EmpGubunData> getEmpGubunData(String I_PERNR) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);

            excute(mConnection, function);

            return getTable(EmpGubunData.class, function, "T_TPINFO");
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}
