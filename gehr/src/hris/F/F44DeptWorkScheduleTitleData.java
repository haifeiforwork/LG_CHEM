/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근무 계획표                                                 */
/*   Program ID   : F44DeptWorkScheduleTitleData                                */
/*   Description  : 부서별 근무 계획표 타이틀 조회를 위한 DATA 파일             */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-18 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F;  

/**
 * F44DeptWorkScheduleTitleData
 *  부서별 근무 계획표 타이틀 내용을 담는 데이터
 *  
 * @author 유용원
 * @version 1.0, 
 */
public class F44DeptWorkScheduleTitleData extends com.sns.jdf.EntityData {
    public String DD     ;  //버젼번호 구성요소
	public String KURZT  ;  //달력(일) 내역    
	public String HOLIDAY;  //공휴일 클래스 
}
