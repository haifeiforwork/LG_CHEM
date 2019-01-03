package	hris.D.D20Flextime.rfc;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D20Flextime.D20FlextimeData;

/**
 * D20FlextimeCheckRFC.java
 * Flextime ��û�� ��û����Ÿ ��ȿ�� üũ�ϴ� RFC�� ȣ���ϴ� Class
 * 2017-08-01  eunha    [CSR ID:3438118] flexible time �ý��� ��û
 * 2017-11-08  eunha    [CSR ID:3525213] Flextime �ý��� ���� ��û
 * 2018-05-10  ��ȯ��   [WorkTime52] �κ�/�������� �ٹ��� ����
 */
public class D20FlextimeCheckRFC extends SAPWrap {

//    private String functionName = "ZGHR_RFC_FLEXTIME_CHECK";
    private String functionName = "ZGHR_RFC_NTM_FLEXTIME_CHECK";

    /**
     * Flextime ��û�� ��û����Ÿ ��ȿ�� üũ�ϴ� RFC�� ȣ���ϴ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public RFCReturnEntity check(D20FlextimeData d20FlextimeData, String I_GTYPE) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", d20FlextimeData.PERNR);
            setField(function, "I_BEGDA", d20FlextimeData.BEGDA);
            //[CSR ID:3525213] Flextime �ý��� ���� ��û start
            //setField(function, "I_FLEX_BEG", d20FlextimeData.FLEX_BEG);
            //setField(function, "I_FLEX_END", d20FlextimeData.FLEX_END);
            setField(function, "I_FLEX_BEGDA", d20FlextimeData.FLEX_BEGDA);
            setField(function, "I_FLEX_ENDDA", d20FlextimeData.FLEX_ENDDA);
            //[CSR ID:3525213] Flextime �ý��� ���� ��û end
            setField(function, "I_UPMU_TYPE", "42");
            setField(function, "I_GTYPE", I_GTYPE);
            setField(function, "I_AINF_SEQN", d20FlextimeData.AINF_SEQN);
            setField(function, "I_BEGTM", d20FlextimeData.FLEX_BEGTM);
            excute(mConnection, function);
            return getReturn();

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}