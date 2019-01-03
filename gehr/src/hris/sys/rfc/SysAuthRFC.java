/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 메뉴                                                        */
/*   Program Name : 메뉴                                                        */
/*   Program ID   : SysAuthGroupRFC.java                                        */
/*   Description  : 메뉴 목록 가져오기                                          */
/*   Note         : [관련 RFC] : ZHRC_RFC_GET_AUTHGROUP                         */
/*   Creation     : 2007-04-16  lsa                                             */
/*   Update       : CSR ID:C20140106_63914    */
/*                                                                              */
/********************************************************************************/

package hris.sys.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.sys.SysAuthInput;

public class SysAuthRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_CHECK_BELONG";

    /**
     * 로그인한 사번이 대상부서/사번을 조회할 권한이 잇는지 여부
     * 
     * @param inputData 입력값
     * @return
     * @throws GeneralException
     */
    public boolean isAuth(SysAuthInput inputData) throws GeneralException {

        JCO.Client mConnection = null;

        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

/*
I_CHKGB   CHAR 1  체크 구분자
                  1 : 사원 , 조직 체크 (순수 조직원)
                  2 : 부서장(접속자) 권한조직내 , 사원(퇴직자 포함) 체크
                  3 : 사원의 권한조직내 선택 조직(상위포함) 체크
I_DEPT    NUMC 8  관리자 사원번호
I_PERNR   NUMC 8  대상자 사원번호
I_ORGEH   NUMC 8  대상 조직
I_AUTHOR  CHAR 1  권한그룹
I_RETIR   CHAR 1  퇴직자 포함
I_GUBUN   CHAR 1  조직선택 구분자
I_DATUM   DATS 8  기준일자
I_SPRSL   LANG 1  언어
*/
            setFields(function, inputData);

            excute(mConnection, function);

            return "X".equals(getField("E_CHECK", function));

        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}