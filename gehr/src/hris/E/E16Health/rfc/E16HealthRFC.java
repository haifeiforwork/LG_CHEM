package hris.E.E16Health.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E16Health.*;

/**
 * E16HealthRFC.java
 * �������ǰ�����ī�忡  ���� �����͸� �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2010/05/31
 *  2017/08/28 eunha [CSR ID:3456352] ����ü�谳�� �� ����/��å ǥ�� ���� ���濡 ���� �ý��� ���� ��û ��
 */
public class E16HealthRFC extends SAPWrap {

 //  private String functionName = "ZHRW_RFC_HEALTH_CARD_DISPLAY";
    private String functionName = "ZGHR_RFC_HEALTH_CARD_DISPLAY";

    /**
     * �������ǰ�����ī�忡 ���� �����͸� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail(String empNo, String year, String userempNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput( function, empNo,  year,userempNo);
            excute(mConnection, function);
            Vector ret = getOutput(function);
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
    private void setInput(JCO.Function function, String empNo, String year, String userempNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_YEAR";
        setField(function, fieldName2, year);
        String fieldName3 = "I_SPERNR";
        setField(function, fieldName3, userempNo);
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

        Vector T_9416S = getTable( E16Health9416Data.class, function, "T_9416" ); // �����̷�
        Vector T_9419S = getTable( E16Health9419Data.class, function, "T_9419" ); // �ǰ��������
        Vector T_9420S = getTable( E16Health9420Data.class, function, "T_9420" ); // �ǰ����� ���
        Vector T_9421S = getTable( E16Health9421Data.class, function, "T_9421" ); // ������ ����



        ret.addElement(T_9416S);
        ret.addElement(T_9419S);
        ret.addElement(T_9420S);

        Logger.sap.println(this, "T_9416S : "+T_9416S.toString());
        Logger.sap.println(this, "T_9419S : "+T_9419S.toString());

        // Export ���� ��ȸ
        String E_ENAME = getField("E_ENAME",  function);  //�̸�
        String E_TITEL  = getField("E_TITEL",    function);  //����
        String E_REGNO = getField("E_REGNO",   function);  //�ֹε�Ϲ�ȣ
        String E_ORGEH = getField("E_ORGEH",   function);  //���� ����
        String E_STEXT = getField("E_STEXT",   function);  //������Ʈ �̸�
        String E_DARDT = getField("E_DARDT",   function);  //���������� ���� ����
        String E_PRINT = getField("E_PRINT",   function);  //��¿���
        String E_CENAME = getField("E_CENAME",   function);  //������ �̸�
        String E_HENAME = getField("E_HENAME",   function);  //���Ǵ���� �̸�
        //  [CSR ID:3456352] ����ü�谳�� �� ����/��å ǥ�� ���� ���濡 ���� �ý��� ���� ��û ��
        String E_TITL2 = getField("E_TITL2",   function);  //��å

        ret.addElement(E_ENAME);
        ret.addElement(E_TITEL);
        ret.addElement(E_REGNO);
        ret.addElement(E_ORGEH);
        ret.addElement(E_STEXT);
        ret.addElement(E_DARDT);
        ret.addElement(E_PRINT);
        ret.addElement(E_CENAME);
        ret.addElement(E_HENAME);
        ret.addElement(T_9421S);
        ret.addElement(E_TITL2);//  [CSR ID:3456352] ����ü�谳�� �� ����/��å ǥ�� ���� ���濡 ���� �ý��� ���� ��û ��

        return ret;
    }
}

