package hris.D.D11TaxAdjust.rfc ;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * D11TaxAdjustCardUseYearComboRFC.java
 * �ſ�ī�� �Է� �� ������ ���� ���� �������� RFC�� ȣ���ϴ� Class(@2014 �������� �ҵ�����Ű��� �߰��� �׸�)
 * ex)2014��߾/2014����/2013��
 *
 * @author ������
 * @version 1.0, 2014/12/18
 * @version 1.1, 2016/01/11
 */
public class D11TaxAdjustCardUseYearComboRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_ETC_CREDIT_PE";

    /**
     * �ſ�ī�� ���⵵�� �Է��� �� �ִ� �޺� ���� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String ���
     * @param java.lang.String �������� �⵵
     * @return java.lang.String �μ����й�ȣ
     * @exception com.sns.jdf.GeneralException
     *
     */
    public Vector getCardUseYearCombo() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            return getOutput(function);

        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * �ſ�ī�� ���⵵�� �Է��� �� �ִ� �޺� ���� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String ���
     * @param java.lang.String �������� �⵵
     * @return java.lang.String �μ����й�ȣ
     * @exception com.sns.jdf.GeneralException
     * @2015 �������� �߰�(parameter�� targetYear �߰�)
     */
    public Vector getCardUseYearCombo(String targetYear) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, targetYear);

            excute(mConnection, function);
            return getOutput(function);

        } catch(Exception ex) {
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

    private void setInput(JCO.Function function, String targetYear) throws GeneralException {

        String fieldName = "I_YEAR";

        setField( function, fieldName, targetYear );

    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	String tableName = "RESULT";
        return getCodeVector(function, tableName);
    }
}

