/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : �μ��� �з���ȸ
*   Program ID   : F22DeptScholarshipRFC.java
*   Description  : �μ��� �з� �˻��� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F.rfc;

import hris.F.F22DeptScholarshipData;
import hris.F.F22DeptScholarshipGlobalData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F22DeptScholarshipRFC.java
 * �μ��� ���� ��ü �μ����� �з������� �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F22DeptScholarshipRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_ORG_EDUCAT_INFO";

    /**
     * �μ��ڵ忡 ���� ��ü �μ����� �з������� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, �����μ���ȸ ����.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptScholarship(String I_ORGEH, String I_LOWERYN, boolean userArea) throws GeneralException {

        JCO.Client mConnection = null;
        Vector resultList = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);

            excute(mConnection, function);

            Class classPath = null;

            if( userArea ) classPath = F22DeptScholarshipData.class;
            else  classPath= F22DeptScholarshipGlobalData.class;

        	resultList.addElement(getTable(classPath,  function, "T_EXPORTA"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


