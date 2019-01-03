/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : �ٹ�����/���޺� �ο���Ȳ
*   Program ID   : F03DeptWorkareaClassRFC
*   Description  : �ٹ�����/���޺� �ο���Ȳ ��ȸ�� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F.rfc;

import hris.F.F03DeptWorkareaClassNoteData;
import hris.F.F03DeptWorkareaClassTitleData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F03DeptWorkareaClassRFC
 * �μ��� ���� �ٹ�����/���޺� �ο���Ȳ ������ �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F03DeptWorkareaClassRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_WBPT_STATE";

    /**
     * �μ��ڵ忡 ���� �ٹ�����/���޺� �ο���Ȳ ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, ��������.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptWorkareaClass(String I_ORGEH, String I_LOWERYN, String I_MOLGA) throws GeneralException {

        JCO.Client mConnection = null;
        Vector resultList = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            setField(function, "I_MOLGA", I_MOLGA);

            excute(mConnection, function);

            // Table ��� ��ȸ
        	resultList.addElement(getTable(F03DeptWorkareaClassTitleData.class,  function, "T_EXPORTA"));
        	resultList.addElement(getTable(F03DeptWorkareaClassNoteData.class,  function, "T_EXPORTB"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


