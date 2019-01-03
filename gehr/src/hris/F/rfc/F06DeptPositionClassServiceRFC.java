/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : �ҼӺ�/���޺� ��ձټ�
*   Program ID   : F06DeptPositionClassServiceRFC
*   Description  : �ҼӺ�/���޺� ��ձټ� ��ȸ�� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F.rfc;

import hris.F.F06DeptPositionClassServiceNoteData;
import hris.F.F06DeptPositionClassServiceTitleData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F06DeptPositionClassServiceRFC
 * �μ��� ���� �ҼӺ�/���޺� ��ձټ� ������ �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F06DeptPositionClassServiceRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_OPTS_STATE";

    /**
     * �μ��ڵ忡 ���� �ҼӺ�/���޺� ��ձټ� ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, ��������.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptPositionClassService(String I_ORGEH, String I_LOWERYN, String I_MOLGA) throws GeneralException {

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
        	resultList.addElement(getTable(F06DeptPositionClassServiceTitleData.class,  function, "T_EXPORTA"));
        	resultList.addElement(getTable(F06DeptPositionClassServiceNoteData.class,  function, "T_EXPORTB"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


