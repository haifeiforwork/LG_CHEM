/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : �ҼӺ�/������ �ο���Ȳ
*   Program ID   : F02DeptPositionDutyGlobalRFC
*   Description  : �ҼӺ�/������ �ο���Ȳ ��ȸ�� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F.rfc;

import hris.F.F02DeptPositionDutyNoteGlobalData;
import hris.F.F02DeptPositionDutyTitleGlobalData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F02DeptPositionDutyGlobalRFC
 * �μ��� ���� �ҼӺ�/������ �ο���Ȳ ������ �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F02DeptPositionDutyGlobalRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_OPJ_STATE";

    /**
     * �μ��ڵ忡 ���� �ҼӺ�/������ �ο���Ȳ ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, ��������.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptPositionDuty(String I_ORGEH, String I_LOWERYN, String I_MOLGA) throws GeneralException {

        JCO.Client mConnection = null;
        Vector resultList = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            setField(function, "I_MOLGA", I_MOLGA);

            excute(mConnection, function);

        	String E_RETURN    = getField("E_RETURN", function) ;
        	String E_MESSAGE  = getField("E_MESSAGE", function) ;

            // Table ��� ��ȸ
        	Vector T_EXPORTA = getTable(F02DeptPositionDutyTitleGlobalData.class,  function, "T_EXPORTA");
        	Vector T_EXPORTB = getTable(F02DeptPositionDutyNoteGlobalData.class,  function, "T_EXPORTB");

        	resultList.addElement(T_EXPORTA);
        	resultList.addElement(T_EXPORTB);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


