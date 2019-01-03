/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : �ҼӺ�/���޺� �ο���Ȳ (�ؿ�)
*   Program ID   : F01DeptPositionClassGlobalRFC
*   Description  : �ҼӺ�/���޺� �ο���Ȳ (�ؿ�)   ��ȸ�� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F.rfc;

import hris.F.F01DeptPositionClassTitleGlobalData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F01DeptPositionClassGlobalRFC
 * �μ��� ���� �ҼӺ�/���޺� �ο���Ȳ ������ �������� RFC�� ȣ���ϴ� Class
 * @author  ������
 * @version 1.0, 2016/10/20
 */
public class F01DeptPositionClassGlobalRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_OPT_STATE";

    /**
     * �μ��ڵ忡 ���� �ҼӺ�/���޺� �ο���Ȳ ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, ��������.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptPositionClass(String I_ORGEH, String I_LOWERYN, String I_MOLGA) throws GeneralException {

        JCO.Client mConnection = null;
        Vector resultList = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            setField(function, "I_MOLGA", I_MOLGA);

            excute(mConnection, function);

            resultList.addElement(getTable(F01DeptPositionClassTitleGlobalData.class, function, "T_EXPORTA"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


