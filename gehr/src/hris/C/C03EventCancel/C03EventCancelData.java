/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육과정  신청   취소                                    */
/*   Program Name : 교육과정 Data                                               */
/*   Program ID   : C03EventCancelData                                            */
/*   Description  : 교육과정 결제를 담당하는 Data                               */
/*   Note         : [관련 RFC] : ZHRD_RFC_EVENT_CANCLE_APPROVAL                            */
/*   Creation     : 2013-06-11  lsa                                          */
/*   Update       :                                            */
/*                                                                              */
/********************************************************************************/

package hris.C.C03EventCancel;

public class C03EventCancelData extends com.sns.jdf.EntityData {

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
    public String EDU_CANC ;  //  취소 승인 상태
    public String CANC_NUM ;  // 취소 신청 횟수                
    public String CHPERNR  ;  // 사원 번호                     
    public String CHENAME  ;  // 사원 또는 지원자의 포맷된 이름
    public String CHORGTX  ;  // 조직 단위 내역                
    public String CHTITEL  ;  // 제목                          
    public String CHPHONE  ;  // 통신 ID/번호                  
    public String CHEMAIL  ;  // 통신: 긴 ID/번호              
    public String ZPERNR   ;  // 대리신청자 사번               
 
}
