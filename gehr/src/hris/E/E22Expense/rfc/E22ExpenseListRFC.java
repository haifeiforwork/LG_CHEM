package hris.E.E22Expense.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E22Expense.E22ExpenseListData;

/**
 * E22ExpenseListRFC.java
 * �������ϱ�/���ڱ�/���б� ��ȸ RFC �� ȣ���ϴ� Class
 *
 * @author �ֿ�ȣ
 * @version 1.0, 2002/01/04
 */
public class E22ExpenseListRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_SCHOLARSHIP_DISPLAY";
    private String functionName = "ZGHR_RFC_SCHOLARSHIP_DISPLAY";

    /**
     * �������ϱ�/���ڱ�/���б� ��ȸ RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
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

//              ��û��
                if( data.WAERS.equals("KRW") ) {
                    if(data.PROP_AMNT.equals("")){ data.PROP_AMNT=""; }else{ data.PROP_AMNT=Double.toString(Double.parseDouble(data.PROP_AMNT) * 100.0 ) ; }
                }

//              ȸ�����޾�
                if( data.WAERS1.equals("KRW") ) {
                    if(data.PAID_AMNT.equals("")){ data.PAID_AMNT=""; }else{ data.PAID_AMNT=Double.toString(Double.parseDouble(data.PAID_AMNT) * 100.0 ) ; }
                }

//              ��������ݿ��� - �׻� KRW
                    if(data.YTAX_WONX.equals("")){ data.YTAX_WONX=""; }else{ data.YTAX_WONX=Double.toString(Double.parseDouble(data.YTAX_WONX) * 100.0 ) ; }

//              �ݳ��� - ��ȭŰ�� ȸ�����޾װ� ����.
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

//              ��û��
                if( data.WAERS.equals("KRW") ) {
                    if(data.PROP_AMNT.equals("")){ data.PROP_AMNT=""; }else{ data.PROP_AMNT=Double.toString(Double.parseDouble(data.PROP_AMNT) * 100.0 ) ; }
                }

//              ȸ�����޾�
                if( data.WAERS1.equals("KRW") ) {
                    if(data.PAID_AMNT.equals("")){ data.PAID_AMNT=""; }else{ data.PAID_AMNT=Double.toString(Double.parseDouble(data.PAID_AMNT) * 100.0 ) ; }
                }

//              ��������ݿ��� - �׻� KRW
                    if(data.YTAX_WONX.equals("")){ data.YTAX_WONX=""; }else{ data.YTAX_WONX=Double.toString(Double.parseDouble(data.YTAX_WONX) * 100.0 ) ; }

//              �ݳ��� - ��ȭŰ�� ȸ�����޾װ� ����.
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


