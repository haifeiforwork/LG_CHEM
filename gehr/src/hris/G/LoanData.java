/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 주택자금 신규신청 부서장 결재                               */
/*   Program Name : 주택자금 신규신청 부서장 결재                               */
/*   Program ID   : LoanData                                                    */
/*   Description  : 결재시 대출상세내역 가져오는 데이타                         */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_LOAN_DETAIL                       */
/*   Creation     : 2005-03-10  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.G;

import com.sns.jdf.EntityData;

public class LoanData extends EntityData {
    public String ZZRPAY_MNTH  ;  // 서식 YYYYMM에서의 기간(상환기간)
    public String TILBT        ;  // 분할상환(월상환원금)
    public String REFN_BEGDA   ;  // 시작일(월상환시작)
    public String REFN_ENDDA   ;  // 종료일(월상환종료)
    public String MNTH_INTEREST;  // 월상환이자
}
