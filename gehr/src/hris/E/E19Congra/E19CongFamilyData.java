package hris.E.E19Congra;

/**
 * A04FamilyDetailData.java
 *  가족사항(본인포함) 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRA_RFC_FAMILY
 *
 * @author ebksong
 * @version 1.0, 2006/06/14
 */
public class E19CongFamilyData extends com.sns.jdf.EntityData {

    public String SUBTY ;   // subtype
    public String STEXT ;   // 관계
    public String OBJPS ;   // 오브젝트식별
    public String LNMHG ;   // 성씨
    public String FNMHG ;   // 이름
    public String REGNO ;   // 주민등록번호
    public String FGBDT ;   // 생년월일
    public String FASAR ;   // 학력코드
    public String STEXT1;   // 학력
    public String FASIN ;   // 교육기관
    public String FAJOB ;   // 직업
    public String KDSVH ;   // 관계코드
    public String ATEXT ;   // 관계명
    public String FASEX ;   // 성별
    public String FGBOT ;   // 출생지
    public String FGBLD ;   // 출생국코드
    public String LANDX ;   // 출생국명
    public String FANAT ;   // 국적코드
    public String NATIO ;   // 국적명
    public String DPTID ;   // 부양가족여부
    public String HNDID ;   // 장애여부
    public String LIVID ;   // 동거여부
    public String HELID ;   // 의료보험여부
    public String FAMID ;   // 가족수당여부
    public String CHDID ;   // 자녀보호비용을 위한 면제지시자
    //[CSR ID:3189675] 경조금 회갑 예외신청 개선
    public String EXCEP ;   // 경조금 회갑 신청 시 예외처리 여부, x면 예외처리 대상자임.

}
