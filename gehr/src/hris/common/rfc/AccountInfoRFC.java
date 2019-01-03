package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.common.*;

/**
 * AccountInfoRFC.java
 * ���������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/01/22
 */
public class AccountInfoRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_GET_ACCOUNT_INFO";
    private String functionName = "ZGHR_RFC_GET_ACCOUNT_INFO";

    // FLAG('1':�μ�, '2':����, '3':����)
    /**
     * �μ� ���������� �ִ��� ���θ� ������ Method
     */
    public boolean hasDepartAccount( String empNo ) throws GeneralException {
        Vector account_vt = getDepartAccountInfo( empNo );
        // ?? ���¹�ȣ�� �ΰ� ���ü��� ������?
        if( account_vt.size() > 0 ){
            AccountData accountData = (AccountData)account_vt.get(0);
            // ���¹�ȣ�� ������� ������ true
            if(accountData != null && accountData.BANKN != "" && accountData.BANKA != "" && accountData.BANKL != "" ){
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * ���� ���������� �ִ��� ���θ� ������ Method
     */
    public boolean hasPersAccount( String empNo ) throws GeneralException {
        Vector account_vt = getPersAccountInfo( empNo );
        // ?? ���¹�ȣ�� �ΰ� ���ü��� ������?
        if( account_vt.size() > 0 ){
            AccountData accountData = (AccountData)account_vt.get(0);
            // ���¹�ȣ�� ������� ������ true
            if(accountData != null && accountData.BANKN != "" && accountData.BANKA != "" && accountData.BANKL != "" ){
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * �μ� ���������� �������� RFC�� ȣ���ϴ� Method
     */
    public Vector getDepartAccountInfo( String empNo ) throws GeneralException {
        return getAccountInfo( empNo, "1" );
    }

    /**
     * ���� ���������� �������� RFC�� ȣ���ϴ� Method, ��� ��û�ÿ� ȣ��Ǿ���Ѵ�.
     */
    public Vector getPersAccountInfo( String empNo ) throws GeneralException {
        return getAccountInfo( empNo, "2" );
    }

    /**
     * ���������� �������� RFC�� ȣ���ϴ� Method
     */
    public Vector getAllAccountInfo( String empNo ) throws GeneralException {
        return getAccountInfo( empNo, "3" );
    }

    /**
     * ���������� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.Object hris.common.AppLineKey Object.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getAccountInfo( String empNo, String flag ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            String LIFNR = null;
            if( empNo.length() == 9 && empNo.substring(0,1).equals("E") ){
                LIFNR = empNo;
            } else if( empNo.length() < 9 ){
                LIFNR = "E" + com.sns.jdf.util.DataUtil.fixEndZero( empNo, 8 );
                Logger.debug.println(this, "LIFNR : "+LIFNR);
            } else {
                Logger.debug.println(this, "������ ������ �ùٸ��� �ʽ��ϴ�. LIFNR : "+LIFNR );
            }

            setInput(function, LIFNR, flag);
            excute(mConnection, function);
            Vector ret = getTable(AccountData.class, function, "T_RESULT");//getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String flag) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_FLAG";               // FLAG('01':�μ�, '02':����, '03':����)
        setField( function, fieldName2, flag );
    }

}


