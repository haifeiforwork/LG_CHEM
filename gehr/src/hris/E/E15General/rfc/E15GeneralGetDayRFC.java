package	hris.E.E15General.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.E.E15General.*;

/**
 * E15GeneralGetDayRFC.java ZHRW047T
 * ���հ��� ��û �Ⱓ ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author LSA
 * @version 1.0, 2012/01/02
 */
public class E15GeneralGetDayRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_MEDIC_APPLY";
    private String functionName = "ZGHR_RFC_MEDIC_APPLY";

    /**
     * ������ �ް���û ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getMedicday(String pernr ) throws GeneralException {

        JCO.Client mConnection = null;

        Vector vcRet = new Vector();
        E15GeneralDayData DayData = new E15GeneralDayData();
        String E_HEALTH;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, pernr );
            excute(mConnection, function);

            getStructor(DayData ,function, "S_APPLY");
            E_HEALTH = getField("E_HEALTH" ,function);

            vcRet.add(DayData);
            vcRet.add(E_HEALTH);
            return vcRet;

        }catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String pernr ) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;
        setField(function, fieldName1, pernr);
    }

}
