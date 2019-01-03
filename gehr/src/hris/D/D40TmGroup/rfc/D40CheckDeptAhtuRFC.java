/********************************************************************************/
/*																											*/
/*   System Name	: MSS																		*/
/*   1Depth Name		: �μ�����																	*/
/*   2Depth Name		: ����                                                           							*/
/*   Program Name	: �����HR������üũ RFC                                 				*/
/*   Program ID		: D40CheckDeptAhtuRFC.java.java									*/
/*   Description		: �����HR������üũ RFC												*/
/*   Note				: ����																			*/
/*   Creation  			: 2017-12-08 ������														*/
/*   Update   			: 2017-12-08 ������														*/
/*																											*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40OrganInsertData;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40CheckDeptAhtuRFC.java
 * �����HR������üũ RFC
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40CheckDeptAhtuRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_CHECK_DEPT_AHTU";
	//private String functionName = "ZGHR_RFC_GET_ORGEH_LIST";
    /**
     * �����HR������üũ RFC
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Object checkDeptAhtuRFC(String user, String I_DATUM) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", user);
            setField(function, "I_DATUM", I_DATUM);

            excute(mConnection, function);
            Object ret = getOutput(function, ( new D40OrganInsertData() ));
            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        return getFields( data, function);
    }

}


