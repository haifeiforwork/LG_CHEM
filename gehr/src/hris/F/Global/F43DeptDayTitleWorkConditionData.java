/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 일간 근태 집계표 타이틀                                     */
/*   Program ID   : F43DeptDayTitleWorkConditionData                            */
/*   Description  : 부서별 일간 근태 집계표 타이틀 조회를 위한 DATA 파일        */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-17 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.Global;

import java.util.HashMap;

/**
 * F43DeptDayTitleWorkConditionData 부서별 일간 근태 집계표 타이틀 내용을 담는 데이터
 *
 * @author 유용원
 * @version 1.0,
 */
public class F43DeptDayTitleWorkConditionData extends com.sns.jdf.EntityData {
	/*
	 * public String YYYYMM; //대상연월 public String BEGDA ; //시작일 public String
	 * ENDDA ; //종료일 public String D1 ; //날짜(01,02,03 …) public String D2 ;
	 * //날짜(01,02,03 …) public String D3 ; //날짜(01,02,03 …) public String D4 ;
	 * //날짜(01,02,03 …) public String D5 ; //날짜(01,02,03 …) public String D6 ;
	 * //날짜(01,02,03 …) public String D7 ; //날짜(01,02,03 …) public String D8 ;
	 * //날짜(01,02,03 …) public String D9 ; //날짜(01,02,03 …) public String D10 ;
	 * //날짜(01,02,03 …) public String D11 ; //날짜(01,02,03 …) public String D12 ;
	 * //날짜(01,02,03 …) public String D13 ; //날짜(01,02,03 …) public String D14 ;
	 * //날짜(01,02,03 …) public String D15 ; //날짜(01,02,03 …) public String D16 ;
	 * //날짜(01,02,03 …) public String D17 ; //날짜(01,02,03 …) public String D18 ;
	 * //날짜(01,02,03 …) public String D19 ; //날짜(01,02,03 …) public String D20 ;
	 * //날짜(01,02,03 …) public String D21 ; //날짜(01,02,03 …) public String D22 ;
	 * //날짜(01,02,03 …) public String D23 ; //날짜(01,02,03 …) public String D24 ;
	 * //날짜(01,02,03 …) public String D25 ; //날짜(01,02,03 …) public String D26 ;
	 * //날짜(01,02,03 …) public String D27 ; //날짜(01,02,03 …) public String D28 ;
	 * //날짜(01,02,03 …) public String D29 ; //날짜(01,02,03 …) public String D30 ;
	 * //날짜(01,02,03 …) public String D31 ; //날짜(01,02,03 …)
	 */
	public String ORGEH;

	public String STEXT;

	public String LEVEL;

	public String PERNR;

	public String ENAME;

	public String QU_BAL;

	public HashMap<String, String> MAP = new HashMap<String, String>();
}
