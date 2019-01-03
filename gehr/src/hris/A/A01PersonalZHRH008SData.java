/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH008SData                                     */
/*   Description  : 교육이력 정보를 담아오는 데이터                             */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A; 

public class A01PersonalZHRH008SData extends com.sns.jdf.EntityData {

    public String MC_STEXT1;  // 이름(교육분야)
    public String OBJID_D  ;  // 원가추정번호
    public String OBJID    ;  // 원가추정번호
    public String TTEXT    ;  // 오브젝트이름(과정명칭)
    public String BEGDA    ;  // 시작일
    public String ENDDA    ;  // 종료일
    public String PERIOD   ;  // 기간(교육연수기간)
    public String ILSU     ;  // 일별 유효기간(일수)
    public String MC_STEXT ;  // 이름(교육기관)
    public String PYONGGA  ;  // 평가
    public String FLAG     ;  // FLAG(기표=SPACE,역기표='X')(진급필수여부)
    public String DEL_FLAG ;  // 일반플래그
}