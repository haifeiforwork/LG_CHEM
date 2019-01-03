/******************************************************************************/
/*   System Name  	: g-HR
/*   1Depth Name  	: Organization & Staffing
/*   2Depth Name  	: Headcount
/*   Program Name 	: Org.Unit/Level (Staff Present State Detail)
/*   Program ID   		: F00DeptDetailListData.java
/*   Description  		: 인원현황 각각의 상세화면
/*   Note         		: 없음
/*   Creation     		: 2005-03-07  유용원
/*   Update				: 2009-04-24 jungin @v1.0 [C20090413_38006] Annual 필드 display.
/******************************************************************************/

package hris.F.Global;

/**
 * F00DeptDetailListData
 *  인원현황 각각의 상세화면 내용을 담는 데이터
 *
 * @author 유용원
 * @version 1.0,
 */
public class F00DeptDetailListData extends com.sns.jdf.EntityData {
    public String PERNR     			;    	//사번
    public String ENAME    			;    	//성명
    public String STEXT     		;    	//소속텍스트
    public String ORGTX    			;    	//소속약어
    public String PTEXT     		;    	//신분텍스트
    public String JIKWE     			;    	//직위
    public String JIKWT     			;    	//직위
    public String JIKCH     			;    	//직위
    public String JIKCT     			;    	//직위
    public String JIKKB     			;    	//직위
    public String JIKKT     			;    	//직위
    public String STELL_TEXT		;    	//직무텍스트
    public String DAT       			;    	//입사일자
    public String GBDAT     		;    	//생년월일
    public String BTEXT     		;    	//근무지 텍스트
    public String PBTXT     		;
    public String ANNUL				;		//년차

}
