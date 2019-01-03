package hris.D.D01OT.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D01OTCheckAddRFC.java
 * �ʰ��ٹ� �ش翩�θ� ýũ�ϴ� RFC �� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2018/05/23
 *          2018/06/11 rdcamel [CSR ID:3701161] ����� �ʰ��ٹ� ��û/���� ���� ���� ��û ��
 *          2018/06/19 [WorkTime52] ���� ���ν� I_APPR=X import parameter �߰�
 */
@SuppressWarnings("rawtypes")
public class D01OTCheckAddRFC extends SAPWrap {

    private final String functionName = "ZGHR_RFC_NTM_OT_AVAL_CHK_ADD";

    /**
     * �ʰ��ٹ� ��ȸ RFC ȣ���ϴ� Method
     * 
     * @param java.util.createVector
     * @return java.util.Vector
     * @throws com.sns.jdf.GeneralException
     */
    public Vector check(Vector createVector) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setTable(function, "T_RESULT", createVector);

            excute(mConnection, function);

            return getOutput(function);

        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);

        } finally {
            close(mConnection);

        }
    }

    /**
     * �ʰ��ٹ� ��ȸ RFC ȣ���ϴ� Method
     * 
     * @param java.lang.String
     * @param java.util.createVector
     * @return java.util.Vector
     * @throws com.sns.jdf.GeneralException
     */
    public Vector check(String I_APPR, Vector createVector) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setField(function, "I_APPR", I_APPR);
            setTable(function, "T_RESULT", createVector);

            excute(mConnection, function);

            return getOutput(function);

        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);

        } finally {
            close(mConnection);

        }
    }

    /**
     * @param function com.sap.mw.jco.JCO.Function
     * @throws com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {

        Vector ret = new Vector();
        ret.addElement(getReturn().MSGTY);
        ret.addElement(getReturn().MSGTX);
        return ret;
    }

}