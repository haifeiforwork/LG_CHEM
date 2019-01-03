package hris.E.Global.E22Expense.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;

import com.sap.mw.jco.*;



/**
 * E22ExpenseListRFC.java
 * 입학축하금/학자금/장학금 조회 RFC 를 호출하는 Class
 *
 * @author 최영호
 * @version 1.0, 2002/01/04
 */
public class E22ExpenseListRFC extends SAPWrap {

   // private String functionName = "ZHRW_RFC_SCHOLARSHIP_DISPLAY";

    //private String functionName = "ZHRW_RFC_REIMBURSE_DISPLAY";
    private String functionName = "ZGHR_RFC_REIMBURSE_DISPLAY";

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

            setInput(function, empNo);
            excute(mConnection, function);

            Vector ret = new Vector();

            Vector T_EXPORT = getTable(hris.E.Global.E22Expense.E22ExpenseListData.class, function, "T_ITAB");//getOutput(function);

            String E_RETURN   = getReturn().MSGTY;
        	String E_MESSAGE   = getReturn().MSGTX;

        	ret.addElement(E_RETURN);
        	ret.addElement(E_MESSAGE);
        	ret.addElement(T_EXPORT);

/*
            for ( int i = 0 ; i < ret.size() ; i++ ) {
                E22ExpenseListData data = (E22ExpenseListData)ret.get(i);

//              신청액 = 申请额
                if( data.WAERS.equals("KRW") ) {
                    if(data.PROP_AMNT.equals("")){ data.PROP_AMNT=""; }else{ data.PROP_AMNT=Double.toString(Double.parseDouble(data.PROP_AMNT) * 100.0 ) ; }
                }

//              회사지급액 = 公司支付額
                if( data.WAERS1.equals("KRW") ) {
                    if(data.PAID_AMNT.equals("")){ data.PAID_AMNT=""; }else{ data.PAID_AMNT=Double.toString(Double.parseDouble(data.PAID_AMNT) * 100.0 ) ; }
                }

//              연말정산반영액 - 항상 KRW  年末細算反射額 - 經常
                    if(data.YTAX_WONX.equals("")){ data.YTAX_WONX=""; }else{ data.YTAX_WONX=Double.toString(Double.parseDouble(data.YTAX_WONX) * 100.0 ) ; }

//              반납액 - 통화키는 회사지급액과 같다.  返還額 - 貨幣(通話)做與公司支付額同樣
                if( data.WAERS1.equals("KRW") ) {
                    if(data.RFUN_AMNT.equals("")){ data.RFUN_AMNT=""; }else{ data.RFUN_AMNT=Double.toString(Double.parseDouble(data.RFUN_AMNT) * 100.0 ) ; }
                }
*/

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        //String entityName = "hris.E.E22Expense.E22ExpenseListData";
        //String tableName = "T_ITAB";
        return getTable(hris.E.Global.E22Expense.E22ExpenseListData.class, function, "T_ITAB");
    }
}


