package hris.E.E22Expense.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E22Expense.E22ExpenseListData;

/**
 * E22ExpenseListRFC.java
 * 입학축하금/학자금/장학금 조회 RFC 를 호출하는 Class
 *
 * @author 최영호
 * @version 1.0, 2002/01/04
 */
public class E22ExpenseListRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_SCHOLARSHIP_DISPLAY";
    private String functionName = "ZGHR_RFC_SCHOLARSHIP_DISPLAY";

    /**
     * 입학축하금/학자금/장학금 조회 RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getExpenseList( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_PERNR", empNo );

            excute(mConnection, function);
            Vector ret = getTable(E22ExpenseListData.class, function, "T_RESULT");//getOutput(function);

            for ( int i = 0 ; i < ret.size() ; i++ ) {
                E22ExpenseListData data = (E22ExpenseListData)ret.get(i);

//              신청액
                if( data.WAERS.equals("KRW") ) {
                    if(data.PROP_AMNT.equals("")){ data.PROP_AMNT=""; }else{ data.PROP_AMNT=Double.toString(Double.parseDouble(data.PROP_AMNT) * 100.0 ) ; }
                }

//              회사지급액
                if( data.WAERS1.equals("KRW") ) {
                    if(data.PAID_AMNT.equals("")){ data.PAID_AMNT=""; }else{ data.PAID_AMNT=Double.toString(Double.parseDouble(data.PAID_AMNT) * 100.0 ) ; }
                }

//              연말정산반영액 - 항상 KRW
                    if(data.YTAX_WONX.equals("")){ data.YTAX_WONX=""; }else{ data.YTAX_WONX=Double.toString(Double.parseDouble(data.YTAX_WONX) * 100.0 ) ; }

//              반납액 - 통화키는 회사지급액과 같다.
                if( data.WAERS1.equals("KRW") ) {
                    if(data.RFUN_AMNT.equals("")){ data.RFUN_AMNT=""; }else{ data.RFUN_AMNT=Double.toString(Double.parseDouble(data.RFUN_AMNT) * 100.0 ) ; }
                }
            }

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector getExpenseList1( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_PERNR", empNo );

            excute(mConnection, function);
            Vector ret = getTable(E22ExpenseListData.class, function, "T_RESULT1");//getOutput1(function);

            for ( int i = 0 ; i < ret.size() ; i++ ) {
                E22ExpenseListData data = (E22ExpenseListData)ret.get(i);

//              신청액
                if( data.WAERS.equals("KRW") ) {
                    if(data.PROP_AMNT.equals("")){ data.PROP_AMNT=""; }else{ data.PROP_AMNT=Double.toString(Double.parseDouble(data.PROP_AMNT) * 100.0 ) ; }
                }

//              회사지급액
                if( data.WAERS1.equals("KRW") ) {
                    if(data.PAID_AMNT.equals("")){ data.PAID_AMNT=""; }else{ data.PAID_AMNT=Double.toString(Double.parseDouble(data.PAID_AMNT) * 100.0 ) ; }
                }

//              연말정산반영액 - 항상 KRW
                    if(data.YTAX_WONX.equals("")){ data.YTAX_WONX=""; }else{ data.YTAX_WONX=Double.toString(Double.parseDouble(data.YTAX_WONX) * 100.0 ) ; }

//              반납액 - 통화키는 회사지급액과 같다.
                if( data.WAERS1.equals("KRW") ) {
                    if(data.RFUN_AMNT.equals("")){ data.RFUN_AMNT=""; }else{ data.RFUN_AMNT=Double.toString(Double.parseDouble(data.RFUN_AMNT) * 100.0 ) ; }
                }
            }

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


