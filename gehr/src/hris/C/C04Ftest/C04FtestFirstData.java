/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 사내어학검정                                                */
/*   Program Name : 어학능력검정정보데이터                                      */
/*   Program ID   : C04FtestFirstData                                           */
/*   Description  : 어학능력검정정보데이터                                      */
/*   Note         : [관련 RFC] : ZHRE_RFC_LANGUAGE_FIRST                        */
/*   Creation     : 2002-01-04  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                                                                              */
/********************************************************************************/
package	hris.C.C04Ftest;

public class C04FtestFirstData extends com.sns.jdf.EntityData {

    public String BUKRS     ;   // 회사코드
    public String EXAM_DATE ;   // 검정일
    public String EXIM_DTIM ;   // 요일
    public String FROM_DATE ;   // 신청기간FROM
    public String FROM_TIME ;   // 시험시작
    public String LANG_CODE ;   // 검정구분
    public String LANG_NAME ;   // 시험 이름
    public String TOXX_DATE ;   // 신청기간TO
    public String TOXX_TIME ;   // 시험종료
    public String REQS_DATE ;   // 신청일
    public String AREA_CODE ;   // 신청검정지역코드
    public String AREA_DESC ;   // 신청검정지역명
    public String AREA_CODE2;   // 확정검정지역코드
    public String AREA_DESC2;   // 확정검정지역명
    public String REQS_FLAG ;   // 신청가능여부 --> 신청가능하면 "Y", 가능하지 않으면 "N"
    public String CONF_FLAG ;   // 확정여부     --> 신청완료 "X", 확정 "Y", 취소 "N"
    public String REQS_CONT ;   // 신청인원수 - 회사내
    public String CONF_CONT ;   // 확정인원수 - 회사내
    public String PERNR     ;   // 사번
}
