package hris.E.E05House.rfc;

import java.util.*;

import com.sap.mw.jco.*;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E05House.*;

/**
 * E05LoanMoneyRFC.java
 * 주택융자한도금액에 관한 일반정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 * -----------------------------------------------------
 * @version 1.1, 2014/05/16
 * @author 이지은
 * @CSRID : 2545905
 * @note : 시간선택제 인원 주택자금 신청 금액 조정을 위한 import값 추가
 * -----------------------------------------------------
 */
public class E05LoanMoneyRFC extends SAPWrap {

    //private String functionName ="ZHRW_RFC_HOUSE_LOAN_MONEY";
    private String functionName ="ZGHR_RFC_HOUSE_LOAN_MONEY";

    /**
     * 주택융자한도금액에 관한 일반정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getLoanMoney( ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            Vector ret = getTable(E05LoanMoneyData.class, function, "T_LOAN_MONEY"); //getOutput(function);

            for ( int i = 0 ; i < ret.size() ; i++ ) {
                E05LoanMoneyData data = (E05LoanMoneyData)ret.get(i);
                data.LOAN_MONY = Double.toString( Double.parseDouble(data.LOAN_MONY) * 100.0 ) ;
            }

            return ret;
        }catch(Exception ex){
            //Logger.sap.println(this," SAPException : " +ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * 주택융자한도금액에 관한 일반정보를 가져오는 RFC를 호출하는 Method(version 1.1)
     * @param persk : 시간선택제여부를 알기 위한 구분 항목 조건으로 추가
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * @CSRID : 2545905
     * @note : 시간선택제 인원 주택자금 신청 금액 조정을 위한 import값 추가
     */
    public Vector getLoanMoney( String persk ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput( function, persk );//@version 1.1

            excute(mConnection, function);
            Vector ret = getTable(E05LoanMoneyData.class, function, "T_LOAN_MONEY");//getOutput(function);

            for ( int i = 0 ; i < ret.size() ; i++ ) {
                E05LoanMoneyData data = (E05LoanMoneyData)ret.get(i);
                data.LOAN_MONY = Double.toString( Double.parseDouble(data.LOAN_MONY) * 100.0 ) ;
            }

            return ret;
        }catch(Exception ex){
            //Logger.sap.println(this," SAPException : " +ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * @version 1.1
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String persk) throws GeneralException {
        String fieldName = "I_PERSK";
        setField( function, fieldName, persk );
    }


}
