/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : �μ��� �������� ����
*   Program ID   : F25DeptLegalAssignmentRFC
*   Description  : �μ��� �������� ���� ��ȸ�� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F.rfc;

import hris.F.F25DeptLegalAssignmentData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F25DeptLegalAssignmentRFC
 * �μ��� ���� ��ü �μ����� �������� ���� ������ �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F25DeptLegalAssignmentRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_ORG_LAWLICN_INFO";

    /**
     * �μ��ڵ忡 ���� ��ü �μ����� �������� ���� ������ �������� RFC�� ȣ���ϴ� Method
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

        	// Table ��� ��ȸ
        	resultList.addElement(getTable(F25DeptLegalAssignmentData.class,  function, "T_EXPORTA"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


