package hris.E.E05House.rfc;

import java.util.*;

import com.sap.mw.jco.*;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E05House.*;

/**
 * E05LoanMoneyRFC.java
 * ���������ѵ��ݾ׿� ���� �Ϲ������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2001/12/13
 * -----------------------------------------------------
 * @version 1.1, 2014/05/16
 * @author ������
 * @CSRID : 2545905
 * @note : �ð������� �ο� �����ڱ� ��û �ݾ� ������ ���� import�� �߰�
 * -----------------------------------------------------
 */
public class E05LoanMoneyRFC extends SAPWrap {

    //private String functionName ="ZHRW_RFC_HOUSE_LOAN_MONEY";
    private String functionName ="ZGHR_RFC_HOUSE_LOAN_MONEY";

    /**
     * ���������ѵ��ݾ׿� ���� �Ϲ������� �������� RFC�� ȣ���ϴ� Method
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
     * ���������ѵ��ݾ׿� ���� �Ϲ������� �������� RFC�� ȣ���ϴ� Method(version 1.1)
     * @param persk : �ð����������θ� �˱� ���� ���� �׸� �������� �߰�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * @CSRID : 2545905
     * @note : �ð������� �ο� �����ڱ� ��û �ݾ� ������ ���� import�� �߰�
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String persk) throws GeneralException {
        String fieldName = "I_PERSK";
        setField( function, fieldName, persk );
    }


}
