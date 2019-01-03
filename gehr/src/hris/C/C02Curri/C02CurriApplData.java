/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육과정 안내/신청                                          */
/*   Program Name : 교육과정 Data                                               */
/*   Program ID   : C02CurriApplData                                            */
/*   Description  : 교육과정 결제를 담당하는 Data                               */
/*   Note         : [관련 RFC] : ZHRE_RFC_EVENT_LIST                            */
/*   Creation     : 2002-01-15  박영락                                          */
/*   Update       : 2005-03-08  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package hris.C.C02Curri;

public class C02CurriApplData extends com.sns.jdf.EntityData {

    public String P_AINF_SEQN;  // 결재정보 일련번호
    public String P_CHAID;      // 오브젝트ID
    public String P_CONF_TYPE;  // 기능정보
    public String P_FDATE;      // 시작일
    public String P_PERNR;      // 사원번호
    public String P_TDATE;      // 종료일

    public String MANDT    ;  // 클라이언트넘버
    public String PERNR    ;  // 사원번호 -
    public String BEGDA    ;  // 신청일
    public String AINF_SEQN;  // 결재정보 일련번호
    public String GWAID    ;  // 과정ID
    public String GWAJUNG  ;  // 과정명
    public String GBEGDA   ;  // 시작일
    public String GENDDA   ;  // 종료일
    public String CHASU    ;  // 차수
    public String CHAID    ;  // 차수ID
    public String ENAME    ;  // 이름
    public String ORGTX    ;  // 조직단위텍스트
    public String TITEL    ;  // 직책
    public String TRFGR    ;  // 급여그룹
    public String TRFST    ;  // 급여레벨
    public String VGLST    ;  // 비교급여범위레벨
    public String TEXT     ;  // 신청사유
    public String EDU_CANC ;  // 교육참가 취소 Flag( 'X' = 취소 )
    public String ZPERNR   ;  // 대리신청자 사번
    public String ZUNAME   ;  // 부서서무 이름
    public String AEDTM    ;  // 변경일
    public String UNAME    ;  // 사용자이름
}
