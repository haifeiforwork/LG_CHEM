/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 인원현황 각각의 상세화면
*   Program ID   : F00DeptDetailListData
*   Description  : 인원현황 각각의 상세화면 조회를 위한 DATA 파일
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F;

/**
 * F00DeptDetailListData
 *  인원현황 각각의 상세화면 내용을 담는 데이터
 * @author
 * @version 1.0,
 */
public class F00DeptDetailListData extends com.sns.jdf.EntityData {
    public String PERNR     ;    //사번
    public String ENAME     ;    //성명
    public String STEXT     ;    //소속텍스트
    public String ORGTX     ;    //소속약어
    public String PTEXT     ;    //신분텍스트
    public String TITEL     ;    //직위
    public String TITL2     ;    //직책
    public String TRFGR     ;    //직급
    public String TRFST     ;    //호봉
    public String VGLST     ;    //년차
    public String STELL_TEXT;    //직무텍스트
    public String DAT       ;    //입사일자
    public String GBDAT     ;    //생년월일
    public String BTEXT     ;    //근무지 텍스트
}
