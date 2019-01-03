/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : �μ��� �����
*   Program ID   : F21DeptEntireEmpInfoRFC.java
*   Description  : �μ��� ����� �˻��� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F.rfc;

import hris.A.A01SelfDetailData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

/**
 * F21DeptEntireEmpInfoRFC.java
 * �μ��� ���� ��ü �μ����� ����θ� �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version
 */
public class F21DeptEntireEmpInfoRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_ORG_PERSON_INFO";

    /**
     * �μ��ڵ忡 ���� ��ü �μ����� ����θ� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, �����μ���ȸ ����.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptEntireEmpList(String I_ORGEH, String I_LOWERYN, boolean userArea) throws GeneralException {

        JCO.Client mConnection = null;
        Vector resultList = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);

            excute(mConnection, function);

            Class classPath = null;

            //if( userArea ) classPath = F21DeptEntireEmpInfoData.class;
            //else  classPath= F21DeptEntireEmpInfoGlobalData.class;
            // Table ��� ��ȸ
        	resultList.addElement(getTable(A01SelfDetailData.class,  function, "T_EXPORTA"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


