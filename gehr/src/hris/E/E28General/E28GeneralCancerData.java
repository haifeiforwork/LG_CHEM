package hris.E.E28General;

/**
 * E28GeneralCancerData.java 
 *  7종암검진 실새내역 조회를 하는 데이터 
 *   [관련 RFC] : ZHRH_RFC_HOSP_DISPLAY_N
 * 
 * @author lsa C20130805_81825 
 * @version 1.0, 2013/08/05
 */
public class E28GeneralCancerData extends com.sns.jdf.EntityData {

    public String MANDT    ;      //클라이언트번호
    public String PERNR    ;      //사원번호
    public String BEGDA    ;      //신청일
    public String AINF_SEQN;      //결재정보 일련번호
    public String CONF_DATE;      //확정일자
    public String EZAM_DATE;      //검진날짜
    public String EXAM_YEAR;      //검진년도
    public String GUEN_CODE;      //구분
    public String AREA_CODE;      //지역코드
    public String HOSP_CODE;      //검진병원코드
    public String ZHOM_NUMB;      //전화(자택)
    public String COMP_NUMB;      //전화(회사)
    public String REAL_DATE;      //실검진일자
    public String ZUNAME   ;      //부서서무이름
    public String AEDTM    ;      //변경일
    public String UNAME    ;      //사용자이름
    public String GUEN_NAME;      //증권회사명
    public String HOSP_NAME;      //지부구분명
    public String AREA_NAME;      //지부구부명
    public String ZCONFIRM;	//동의서 확인 여부

}