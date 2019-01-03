package hris.D.D09ContractExtension.rfc;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D09ContractExtensionPeriodCheckRFC.java
 * Contract Extension Period Check하는 RFC를 호출하는 Class
 *
 * @author jungin
 * @version 1.0, 2010/10/12
 */
public class D09ContractExtensionPeriodCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_CONTRACT_PERIOD_CHECK";

    /**
     * Pay Date Raage 유형을 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    
    public RFCReturnEntity getPeriodCheck(String I_PERNR, String I_CTTYP, String I_BEGDA, String I_ENDDA) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);//		 NUMC 	 8 	대상자 사번
            setField(function, "I_CTTYP", I_CTTYP);//		CHAR	 2 	계약유형
            setField(function, "I_BEGDA", I_BEGDA);//		 DATS 	 8 	시작일
            setField(function, "I_ENDDA", I_ENDDA);//		 DATS 	 8 	종료일

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
