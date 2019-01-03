package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.common.*;

/**
 * AccountInfoRFC.java
 * 계좌정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/01/22
 */
public class AccountInfoRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_GET_ACCOUNT_INFO";
    private String functionName = "ZGHR_RFC_GET_ACCOUNT_INFO";

    // FLAG('1':부서, '2':개인, '3':전부)
    /**
     * 부서 계좌정보가 있는지 여부를 가리는 Method
     */
    public boolean hasDepartAccount( String empNo ) throws GeneralException {
        Vector account_vt = getDepartAccountInfo( empNo );
        // ?? 계좌번호가 두개 나올수도 있을까?
        if( account_vt.size() > 0 ){
            AccountData accountData = (AccountData)account_vt.get(0);
            // 계좌번호와 은행명이 있으면 true
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
     * 개인 계좌정보가 있는지 여부를 가리는 Method
     */
    public boolean hasPersAccount( String empNo ) throws GeneralException {
        Vector account_vt = getPersAccountInfo( empNo );
        // ?? 계좌번호가 두개 나올수도 있을까?
        if( account_vt.size() > 0 ){
            AccountData accountData = (AccountData)account_vt.get(0);
            // 계좌번호와 은행명이 있으면 true
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
     * 부서 계좌정보를 가져오는 RFC를 호출하는 Method
     */
    public Vector getDepartAccountInfo( String empNo ) throws GeneralException {
        return getAccountInfo( empNo, "1" );
    }

    /**
     * 개인 계좌정보를 가져오는 RFC를 호출하는 Method, 모든 신청시에 호출되어야한다.
     */
    public Vector getPersAccountInfo( String empNo ) throws GeneralException {
        return getAccountInfo( empNo, "2" );
    }

    /**
     * 계좌정보를 가져오는 RFC를 호출하는 Method
     */
    public Vector getAllAccountInfo( String empNo ) throws GeneralException {
        return getAccountInfo( empNo, "3" );
    }

    /**
     * 결재정보를 가져오는 RFC를 호출하는 Method
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
                Logger.debug.println(this, "데이터 형식이 올바르지 않습니다. LIFNR : "+LIFNR );
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String flag) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_FLAG";               // FLAG('01':부서, '02':개인, '03':전부)
        setField( function, fieldName2, flag );
    }

}


