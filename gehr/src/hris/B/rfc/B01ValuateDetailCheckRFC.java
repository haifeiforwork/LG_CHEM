/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 사원평가                                                    */
/*   Program Name : 평가사항 조회                                               */
/*   Program ID   : B01ValuateDetailCheckRFC                                         */
/*   Description  : 사원의 평가 사항을 가져와도 되는지 확인하는  RFC를 호출하는 Class            */
/*   Note         : [관련 RFC] : ZHRD_RFC_APPRAISAL_LIST  , ZHRW_RFC_CHECK_APPRAISAL                      */
/*   Creation     : 20141125 이지은D   [CSR ID:2651528] 인사권한 추가 및 메뉴조회 기능 변경                                      */
/*   Update       :  20150210  이지은D [CSR ID:2703351] 징계 관련 추가 수정  : 추가 평가 권한 체크일떄는 'A', 징계 조회 권한 체크일때는 'B' 임폴트                                    */
/*                                                                              */
/********************************************************************************/

package hris.B.rfc ;

import com.common.constant.Area;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import org.apache.commons.lang.StringUtils;

public class B01ValuateDetailCheckRFC extends SAPWrap {

    private  static String functionName = "ZGHR_RFC_TABS_CHECK" ;

    /**
     * check tab
     * @param I_LOGPER
     * @param I_PERNR
     * @param I_TABGB
     * @param I_EMGUB
     * @param area
     * @return
     * @throws GeneralException
     */
    public String getValuateDetailCheck(String I_LOGPER, String I_PERNR, String I_TABGB, String I_EMGUB, Area area) throws GeneralException {
        if(!getSapType().isLocal()) {
            if(StringUtils.startsWith(I_TABGB, "A")) return "Y";
            else return "N";
        }
        return getValuateDetailCheck(I_LOGPER, I_PERNR, I_TABGB, I_EMGUB);
    }

    /**
     * 사원의 평가 사항을 가져와도 되는지 확인하는 RFC를 호출하는 Method CSR ID:2703351
     * @param I_LOGPER  로그인 사번
     * @param I_PERNR  조회 사번
     * @param I_TABGB 탭 구분
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */ 
    public String getValuateDetailCheck( String I_LOGPER, String I_PERNR, String I_TABGB, String I_EMGUB) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;
            /*
            I_TABGB		 NUMC 	 8 	탭 구분자
I_PERNR		 NUMC 	 8 	사원번호
I_LOGPER		NUMC	 8 	로그인 사원번호
I_DATUM		 DATS 	 8 	기준일자
I_SPRSL		 LANG 	 1 	언어

A01	평가
A02	징계
A03	임원연봉계약서

B01	교육출장
B02	종합검진(이월)
B03	의료비

             */
            setField(function, "I_TABGB", I_TABGB);
            setField(function, "I_LOGPER", I_LOGPER);
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_EMGUB", I_EMGUB);

            excute( mConnection, function ) ;

            return getField("E_FLAG", function);

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
}
