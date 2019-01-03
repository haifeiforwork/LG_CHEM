/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : �ҼӺ�/���޺� �ο���Ȳ
*   Program ID   : F01DeptPositionClassRFC
*   Description  : �ҼӺ�/���޺� �ο���Ȳ ��ȸ�� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F.rfc;

import hris.F.F01DeptPositionClassNoteData;
import hris.F.F01DeptPositionClassTitleData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F01DeptPositionClassRFC
 * �μ��� ���� �ҼӺ�/���޺� �ο���Ȳ ������ �������� RFC�� ȣ���ϴ� Class
 * @author  ������
 * @version 1.0, 2016/10/20
 */
public class F01DeptPositionClassRFC extends SAPWrap {

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

            excute(mConnection, function);

            resultList.addElement(getTable(F01DeptPositionClassTitleData.class, function, "T_EXPORTA"));
            resultList.addElement(getTable(F01DeptPositionClassNoteData.class, function, "T_EXPORTB"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


