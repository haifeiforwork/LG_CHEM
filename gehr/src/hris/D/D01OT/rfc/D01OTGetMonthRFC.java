package hris.D.D01OT.rfc;

import hris.common.approval.ApprovalSAPWrap;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;


/**
 * D01OTGetMonthRFC.java
 * 초과근무신청시 해당근태월 근태실적 조회시 조회년월에 대한 정보를 리턴하는 RFC 를 호출하는 Class
 *
 * @author 김은하
 * @version 1.0, 2017/08/24
 */
public class D01OTGetMonthRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_GET_TIME_MONTH";

    public String getMonth( String P_PERNR, String P_BEGDA ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setField( function, "I_PERNR", P_PERNR );
            setField( function, "I_BEGDA", P_BEGDA );
            excute(mConnection, function);
            String E_Month   = getField( "E_YYYY", function )+getField( "E_MONTH", function ) ;
            return E_Month;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


