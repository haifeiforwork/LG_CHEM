/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 학력조회
*   Program ID   : F22DeptScholarshipData.java
*   Description  : 부서별 학력 검색을 위한 DATA 파일
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F;

/**
 * F22DeptScholarshipData.java
 *  부서별 학력 내용을 담는 데이터
 * @author
 * @version 1.0,
 */
public class F22DeptScholarshipGlobalData extends com.sns.jdf.EntityData {
	public String NAME1	    ;    //회사
    public String PERNR	    ;    //사원번호
    public String ENAME	    ;    //사원 또는 지원자의 포맷된 이름
    public String ORGTX	    ;    //소속명
    public String JIKKT	    ;    //직책명
    public String JIKWT	    ;    //직위명
    public String VGLST	    ;    //직급/연차
    public String DAT01	    ;    //입사일자
    public String PERIOD    ;    //기간
    public String SCHTX     ;   //학교명
    public String SLATX	    ;    //전공
    public String SLTP1X ;    //전공
    public String SOJAE	    ;    //소재지
    public String EMARK	    ;    //졸업구분텍스트
}
