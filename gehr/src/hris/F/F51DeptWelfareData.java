/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 복리후생                                                    */
/*   Program Name : 부서별 복리후생 현황                                        */
/*   Program ID   : F51DeptWelfareData                                          */
/*   Description  : 부서별 복리후생 현황 조회를 위한 DATA 파일                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       :  2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
/*                                                                              */
/********************************************************************************/

package hris.F;

/**
 * F51DeptWelfareData
 *  부서별 복리후생 현황 내용을 담는 데이터
 *
 * @author 유용원
 * @version 1.0,
 */
public class F51DeptWelfareData extends com.sns.jdf.EntityData {
    public String STEXT;        //부서이름
    public String PERNR;        //사원번호
    public String KNAME;        //한글이름
    public String TITEL;        //직위
    public String GUBUN;        //업무구분
    public String DESCRIPTION;  //신청내역
    public String RELA_CODE;    //대상구분
    public String EREL_NAME;    //대상자성명
    public String WAERS;   		 //통화키
    public String PAID_AMNT;    //지원액
    public String APPL_DATE;    //신청일자
    public String APPR_DATE;    //승인일
    //2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start
    public String TITL2;        //직책
    public String TITEL_T;        //직위코드
  //2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end
}
