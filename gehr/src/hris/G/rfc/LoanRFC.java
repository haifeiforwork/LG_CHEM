/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : �����ڱ� �űԽ�û �μ��� ����                               */
/*   Program Name : �����ڱ� �űԽ�û �μ��� ����                               */
/*   Program ID   : LoanRFC                                                     */
/*   Description  : ����� ����󼼳��� ��������                                */
/*   Note         : [���� RFC] : ZHRA_RFC_GET_LOAN_DETAIL                       */
/*   Creation     : 2005-03-10  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
package hris.G.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.G.*;

public class LoanRFC extends SAPWrap
{
    //private String functionName = "ZHRA_RFC_GET_LOAN_DETAIL";
    private String functionName = "ZGHR_RFC_GET_LOAN_DETAIL";

    /**
     * ����󼼳��� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector returnDetail( String pernr, String dlart, String darbt, String zahld ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, pernr, dlart, darbt, zahld);
            excute(mConnection, function);

            Vector ret = null;

            ret = getOutput(function);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * ����󼼳��� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Object getLoanDetail( String pernr, String dlart, String darbt, String zahld ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, pernr, dlart, darbt, zahld);
            excute(mConnection, function);

            Object ret = null;
            ret = getStructor( new LoanData(), function, "S_EXPORT"); //.getOutput2(function,( new LoanData() ));
            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String �����ȣ
     * @param value java.lang.String ��������
     * @param value java.lang.String ���ε� ����ݾ�
     * @param value java.lang.String ������
     * @param value java.lang.String ��ȯ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String pernr, String dlart, String darbt, String zahld) throws GeneralException {
        String fieldName1  = "I_PERNR";
        setField(function, fieldName1, pernr);
        String fieldName2  = "I_DLART";
        setField(function, fieldName2, dlart);
        String fieldName3  = "I_DARBT";
        setField(function, fieldName3, darbt);
        String fieldName4  = "I_ZAHLD";
        setField(function, fieldName4, zahld);
        String fieldName5  = "I_ZZRPAY_CONT";
        setField(function, fieldName5, "");
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

        // Export ���� ��ȸ
        String fieldName1 = "E_RETURN";      // �����ڵ�
        String E_RETURN   = getField(fieldName1, function) ;

        String fieldName2 = "E_MESSAGE";     // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
        String E_MESSAGE  = getField(fieldName2, function) ;

        ret.addElement(E_RETURN);
        ret.addElement(E_MESSAGE);

        return ret;
    }

    
}

