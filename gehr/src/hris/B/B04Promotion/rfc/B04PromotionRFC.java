package hris.B.B04Promotion.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.B.B04Promotion.B04PromotionAData;
import hris.B.B04Promotion.B04PromotionBData;
import hris.B.B04Promotion.B04PromotionCData;

/**
 * B04PromotionRFC.java
 * ���޿�ǿ� ���� ������ ��ȸ�ϴ� RFC �� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2002/12/23
 */
public class B04PromotionRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_JINGUP_SIMUL";

    /**
     * ���޿�ǿ� ���� ���� ��ȸ RFC ȣ���ϴ� Method
     * @param I_PERNR java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public B04PromotionCData getPromotionList( String I_PERNR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);

            excute(mConnection, function);

            B04PromotionCData resultData = getFields((new B04PromotionCData()), function);// (B04PromotionCData)getOutput(function, ( new B04PromotionCData() ));

            resultData.PYUNGA_TAB = getTable(B04PromotionAData.class, function, "ET_PYUNGA");
            resultData.EDU_TAB = getTable(B04PromotionAData.class, function, "ET_EDU");
            resultData.PYUNGGA_SCORE_TAB = getTable(B04PromotionBData.class, function, "ET_PYUNGA_SCORE");
            resultData.LANG_TAB = getTable(B04PromotionBData.class, function, "ET_LANG");
            resultData.LANG_GIJUN_TAB = getTable(B04PromotionCData.class, function, "ET_LANG_GIJUN");

            return resultData;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}

