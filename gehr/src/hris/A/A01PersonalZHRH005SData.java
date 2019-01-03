/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH005SData                                     */
/*   Description  : 인사기록부(2) 정보를 담아오는 데이터                        */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A;
 
public class A01PersonalZHRH005SData extends com.sns.jdf.EntityData {

    public String MNTXT ;  // 발령유형이름(발령구분)
    public String BEGDA ;  // 시작일(발령일자)
    public String ORGTX ;  // 조직단위텍스트(소속)
    public String TRFGR ;  // 급여그룹(직급)
    public String TITEL ;  // 직위
    public String TITL2 ;  // 직책
    public String STLTX ;  // 직무명
    public String SBEGDA;  // 시작일(승급일자)
    public String GUEBHO;  // 급호
}