package hris.D.D01OT.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D01OTCheckAddRFC.java
 * 초과근무 해당여부를 첵크하는 RFC 를 호출하는 Class
 *
 * @author 강동민
 * @version 1.0, 2018/05/23
 *          2018/06/11 rdcamel [CSR ID:3701161] 모바일 초과근무 신청/결재 로직 수정 요청 건
 *          2018/06/19 [WorkTime52] 결재 승인시 I_APPR=X import parameter 추가
 */
@SuppressWarnings("rawtypes")
public class D01OTCheckAddRFC extends SAPWrap {

    private final String functionName = "ZGHR_RFC_NTM_OT_AVAL_CHK_ADD";

    /**
     * 초과근무 조회 RFC 호출하는 Method
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
     * 초과근무 조회 RFC 호출하는 Method
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