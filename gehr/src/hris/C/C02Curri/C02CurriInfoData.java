package hris.C.C02Curri;

/**
 * C02CurriInfoData.java
 * 교육과정안내 내용을 가져오는 Data
 *   [관련 RFC] : ZHRE_RFC_EVENT_INFORMATION
 * 3개의 RFC모두 Data구조 동일
 * @author 박영락
 * @version 1.0, 2002/01/14
 */
public class C02CurriInfoData extends com.sns.jdf.EntityData {
    //INPUT
    public String I_BUSEO;          //부서오브젝트ID
    public String I_DESCRIPTION;    //오브젝트약어
    public String I_FDATE;          //시작일
    public String I_GROUP;          //그룹오브젝트ID
    public String I_LOCATE;         //위치오브젝트ID
    public String I_TDATE;          //종료일

    //OUTPUT
    public String GWAJUNG;//과정명
    public String GWAID;    //과정ID
    public String CHASU;    //차수명
    public String CHAID;     //차수ID
    public String SHORT;    //오브젝트약어
    public String BEGDA;    //시작일
    public String ENDDA;    //종료일
    public String EXTRN;    //구분
    public String KAPZ2;    //최적수용인원(정원)
    public String RESRV;    //참가자수
    public String LOCATE;   //장소
    public String BUSEO;    //주관부서
    public String SDATE;    //신청기간(시작일)
    public String EDATE;    //신청기간(종료일)
    public String DELET;    //삭제표시
    public String PELSU;    //필수과정표시
    public String GIGWAN; //사외교육기관명
    public String IKOST;    //사내비용

    //추가
    public String STATE;    //상태
    public String LERN_CODE;//E-LEARNING CODE
}