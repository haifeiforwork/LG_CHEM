/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : �μ��� ä�� �з���
*   Program ID   : F28DeptCreditSeizorRFC
*   Description  : �μ��� ä�� �з��� ��ȸ�� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F.rfc;

import hris.F.F28DeptCreditSeizorData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F28DeptCreditSeizorRFC
 * �μ��� ���� ��ü �μ����� ä�� �з��� ������ �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F28DeptCreditSeizorRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_GET_ORGEH_BOND";

    /**
     * �μ��ڵ忡 ���� ��ü �μ����� ä�� �з��� ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, �����μ���ȸ ����.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptLegalAssignment(String I_ORGEH, String I_LOWERYN) throws GeneralException {

        JCO.Client mConnection = null;
        Vector resultList = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);

            excute(mConnection, function);
			resultList.addElement(getTable(F28DeptCreditSeizorData.class,  function, "T_EXPORT"));
        } catch(Exception ex){
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}