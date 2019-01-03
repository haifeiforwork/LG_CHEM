/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근무 계획표 												*/
/*   Program Name	:   근무 계획표 												*/
/*   Program ID		: D40TmSchkzPlanningChartData.java				*/
/*   Description		: 근무 계획표 												*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup;

/**
 * D40TmSchkzPlanningChartData
 *  부서별 근무 계획표 타이틀 내용을 담는 데이터
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40TmSchkzPlanningChartData extends com.sns.jdf.EntityData {
    public String DD     ;  //버젼번호 구성요소
	public String KURZT  ;  //달력(일) 내역
	public String HOLIDAY;  //공휴일 클래스
}
