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
 * 진급요건에 대한 조건을 조회하는 RFC 를 호출하는 Class
 *
 * @author 이형석
 * @version 1.0, 2002/12/23
 */
public class B04PromotionRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_JINGUP_SIMUL";

    /**
     * 진급요건에 대한 조건 조회 RFC 호출하는 Method
     * @param I_PERNR java.lang.String 사원번호
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

