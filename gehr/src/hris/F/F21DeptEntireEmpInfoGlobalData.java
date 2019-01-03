/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 연명부
*   Program ID   : F21DeptEntireEmpInfoGlobalData.java
*   Description  : 부서별 연명부 검색을 위한 DATA 파일
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F;

/**
 * F21DeptEntireEmpInfoGlobalData.java
 *  부서별 연명부 내용을 담는 데이터
 *   [관련 RFC] :
 * @author
 * @version 1.0
 */
public class F21DeptEntireEmpInfoGlobalData extends com.sns.jdf.EntityData {
	public String PERNR	;	//사번
	public String ORGTX	;	//소속명
	public String CNAME1;	//성명(조합)
	public String CNAME2;	//성명(조합)
	public String NAME1	;	//회사
	public String BTEXT	;	//근무지
	public String PGTXT	;	//신분그룹
	public String PKTXT	;	//신분
	public String STLTX	;	//직무명
	public String DAT01	;	//그룹입사일
	public String DAT02	;	//회사입사일
	public String DAT03	;	//현직위승진일
	public String DAT04	;	//근속기준일
	public String JIKWT	;	//직위명
	public String JIKKT	;	//직책명
	public String VGLST	;	//직급/년차
	public String MGTXT	;	//발령 사유 이름
	public String SLABS	;	//입사시학력
	public String NATIO	;	//국적
	public String LANDX	;	//국적명
	public String GBDAT	;	//생년월일
	public String AGECN	;	//연령
	public String TRFGR	;	//호봉 그룹
	public String TRFST	;	//호봉 단계
	public String VGLST2;	//비교급여범위레벨
	public String BUKRS	;	//회사코드
	public String PHOTO	;	//사진URL
}
