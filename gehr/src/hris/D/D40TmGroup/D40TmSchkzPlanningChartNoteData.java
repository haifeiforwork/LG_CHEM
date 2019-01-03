/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근무 계획표 												*/
/*   Program Name	:   근무 계획표 												*/
/*   Program ID		: D40TmSchkzPlanningChartNoteData.java		*/
/*   Description		: 근무 계획표 												*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/


package hris.D.D40TmGroup;


/**
 * D40TmSchkzPlanningChartNoteData.java
 *  근무 계획표 내용을 담는 데이터
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40TmSchkzPlanningChartNoteData extends com.sns.jdf.EntityData {
    public String ORGEH;    //부서코드
    public String STEXT;    //부서명
    public String ENAME;    //성명
    public String PERNR;    //사번
    public String SCHKZ;	//근무 일정 규칙
    public String SCHKZ_TX;	//근무 일정 규칙 텍스트
    public String DATUM;	//일자
    public String MSGTX;	//오류내용

    public String T1   ;    //D1에 해당하는 근무일정
    public String T2   ;    //D2에 해당하는 근무일정
    public String T3   ;    //D3에 해당하는 근무일정
    public String T4   ;    //D4에 해당하는 근무일정
    public String T5   ;    //D5에 해당하는 근무일정
    public String T6   ;    //D6에 해당하는 근무일정
    public String T7   ;    //D7에 해당하는 근무일정
    public String T8   ;    //D8에 해당하는 근무일정
    public String T9   ;    //D9에 해당하는 근무일정
    public String T10  ;    //D10에 해당하는 근무일정
    public String T11  ;    //D11에 해당하는 근무일정
    public String T12  ;    //D12에 해당하는 근무일정
    public String T13  ;    //D13에 해당하는 근무일정
    public String T14  ;    //D14에 해당하는 근무일정
    public String T15  ;    //D15에 해당하는 근무일정
    public String T16  ;    //D16에 해당하는 근무일정
    public String T17  ;    //D17에 해당하는 근무일정
    public String T18  ;    //D18에 해당하는 근무일정
    public String T19  ;    //D19에 해당하는 근무일정
    public String T20  ;    //D20에 해당하는 근무일정
    public String T21  ;    //D21에 해당하는 근무일정
    public String T22  ;    //D22에 해당하는 근무일정
    public String T23  ;    //D23에 해당하는 근무일정
    public String T24  ;    //D24에 해당하는 근무일정
    public String T25  ;    //D25에 해당하는 근무일정
    public String T26  ;    //D26에 해당하는 근무일정
    public String T27  ;    //D27에 해당하는 근무일정
    public String T28  ;    //D28에 해당하는 근무일정
    public String T29  ;    //D29에 해당하는 근무일정
    public String T30  ;    //D30에 해당하는 근무일정
    public String T31  ;    //D31에 해당하는 근무일정

    public String D1   ;    //D1에 해당하는 일자
    public String D2   ;    //D2에 해당하는 일자
    public String D3   ;    //D3에 해당하는 일자
    public String D4   ;    //D4에 해당하는 일자
    public String D5   ;    //D5에 해당하는 일자
    public String D6   ;    //D6에 해당하는 일자
    public String D7   ;    //D7에 해당하는 일자
    public String D8   ;    //D8에 해당하는 일자
    public String D9   ;    //D9에 해당하는 일자
    public String D10  ;    //D10에 해당하는 일자
    public String D11  ;    //D11에 해당하는 일자
    public String D12  ;    //D12에 해당하는 일자
    public String D13  ;    //D13에 해당하는 일자
    public String D14  ;    //D14에 해당하는 일자
    public String D15  ;    //D15에 해당하는 일자
    public String D16  ;    //D16에 해당하는 일자
    public String D17  ;    //D17에 해당하는 일자
    public String D18  ;    //D18에 해당하는 일자
    public String D19  ;    //D19에 해당하는 일자
    public String D20  ;    //D20에 해당하는 일자
    public String D21  ;    //D21에 해당하는 일자
    public String D22  ;    //D22에 해당하는 일자
    public String D23  ;    //D23에 해당하는 일자
    public String D24  ;    //D24에 해당하는 일자
    public String D25  ;    //D25에 해당하는 일자
    public String D26  ;    //D26에 해당하는 일자
    public String D27  ;    //D27에 해당하는 일자
    public String D28  ;    //D28에 해당하는 일자
    public String D29  ;    //D29에 해당하는 일자
    public String D30  ;    //D30에 해당하는 일자
    public String D31  ;    //D31에 해당하는 일자

    public String I1   ;    //D1에 해당하는 근무일정
    public String I2   ;    //D2에 해당하는 근무일정
    public String I3   ;    //D3에 해당하는 근무일정
    public String I4   ;    //D4에 해당하는 근무일정
    public String I5   ;    //D5에 해당하는 근무일정
    public String I6   ;    //D6에 해당하는 근무일정
    public String I7   ;    //D7에 해당하는 근무일정
    public String I8   ;    //D8에 해당하는 근무일정
    public String I9   ;    //D9에 해당하는 근무일정
    public String I10  ;    //D10에 해당하는 근무일정
    public String I11  ;    //D11에 해당하는 근무일정
    public String I12  ;    //D12에 해당하는 근무일정
    public String I13  ;    //D13에 해당하는 근무일정
    public String I14  ;    //D14에 해당하는 근무일정
    public String I15  ;    //D15에 해당하는 근무일정
    public String I16  ;    //D16에 해당하는 근무일정
    public String I17  ;    //D17에 해당하는 근무일정
    public String I18  ;    //D18에 해당하는 근무일정
    public String I19  ;    //D19에 해당하는 근무일정
    public String I20  ;    //D20에 해당하는 근무일정
    public String I21  ;    //D21에 해당하는 근무일정
    public String I22  ;    //D22에 해당하는 근무일정
    public String I23  ;    //D23에 해당하는 근무일정
    public String I24  ;    //D24에 해당하는 근무일정
    public String I25  ;    //D25에 해당하는 근무일정
    public String I26  ;    //D26에 해당하는 근무일정
    public String I27  ;    //D27에 해당하는 근무일정
    public String I28  ;    //D28에 해당하는 근무일정
    public String I29  ;    //D29에 해당하는 근무일정
    public String I30  ;    //D30에 해당하는 근무일정
    public String I31  ;    //D31에 해당하는 근무일정
}
