/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A19OverseasCareerData                                       */
/*   Description  : 인사기록부 정보를 담아오는 데이터                           */
/*   Note         : [관련 RFC] : ZHRA_RFC_PERSONAL_CARD                         */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A;
 
public class A01PersonalZHRH001SData extends com.sns.jdf.EntityData {

    public String BEGDA1;  // 시작일
    public String PERNR ;  // 사원번호
    public String ORGTX ;  // 조직단위텍스트(소속)
    public String KNAME ;  // 한글이름
    public String YNAME ;  // 영어이름
    public String CNAME ;  // 한자이름
    public String TITEL ;  // 직위
    public String VGLST ;  // 국가이름
    public String MGTXT ;  // 발령사유명(입사구분)
    public String PERSK ;  // 사원서브그룹
    public String PTEXT ;  // 사원서브그룹이름(신분)
    public String BTEXT ;  // 인사하위영역 텍스트(근무지)
    public String DAT01 ;  // 일자유형에 대한 일자(근속기준일)
    public String STLTX ;  // 직무명
    public String LANDX ;  // 국가이름(국적)
    public String DAT02 ;  // 일자유형에 대한 일자(그룹입사일)
    public String TITL2 ;  // 직책
    public String SLABS ;  // 입사시학력
    public String BEGDA ;  // 시작일(현직위승진)
    public String DAT03 ;  // 일자유형에 대한 일자(자사입사일)
    public String REGNO ;  // 주민등록번호
    public String GBDAT ;  // 생년월일
    public String VGLST2;  // 비교급여범위레벨
    public String TRFGR ;  // 급여그룹
    public String TRFST ;  // 급여레벨
    public String ORGEH ;  // 소속부서
}