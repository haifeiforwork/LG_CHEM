package hris.common.rfc;

import java.util.*;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D03Vocation.*;
import hris.D.D20Flextime.D20FlextimeData;

/**
 * ZGHR_RFC_EXPCD_LIST
 * 각종 ESS 신청 시 예외 사번 여부 체크 Class
 * 입력 field 
 * 필드ID	    Key	Type
I_PERNR		NUMC
I_MOLGA		CHAR
I_DATUM		DATS
I_SPRSL		LANG
I_ZEXPCD		CHAR

 * 출력 field  
 * E_RETURN    : S:성공 E:오류 N:리스트 없음
 * 
 * except table
 * EXPCD		CHAR	 4 	예외사항
EXPCDT		CHAR	 40 	예외사항명
EXPTG		CHAR	 20 	예외유형
BEGDA		DATS	 8 	시작일
ENDDA		DATS	 8 	종료일

create date : 2017-12-01  [CSR ID:3546961] 경조화환 신청 관련의 건
author : 이지은D

 * 
 */
public class ESSExceptCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_EXPCD_LIST";

    /**
     * ESS 신청 시 예외 사번 여부 확인
     * @return E_RETURN(MSGTY : 1, MSGTX : 255)   : S:성공 E:오류 N:리스트 없음
     * @exception com.sns.jdf.GeneralException
     */

    public RFCReturnEntity essExceptcheck(String pernr, String zexpcd) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            String sysDate = WebUtil.printDate( DataUtil.getCurrentDate(), "-" );
            
            setField(function, "I_PERNR", pernr);
            setField(function, "I_BEGDA", sysDate);
            setField(function, "I_ZEXPCD", zexpcd);
            
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