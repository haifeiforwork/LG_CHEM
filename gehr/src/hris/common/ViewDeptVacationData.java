/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서휴가현황                                                */
/*   Program ID   : ViewDeptVacationData                                        */
/*   Description  : 초기화면에서 부서 휴가 현황을 보기위한 DATA 파일            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-03 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common; 

/**
 * ViewDeptVacationData
 * 초기화면에서 부서 휴가 현황 정보에 관한 데이터
 *  
 * @author 유용원  
 * @version 1.0, 
 */ 
public class ViewDeptVacationData extends com.sns.jdf.EntityData {
    public String OCCUR ;    //근무/휴무일수            
    public String ABWTG ;    //근무/휴무일수            
    public String ZKVRB ;    //근무/휴무일수            
    public String CONSUMRATE ;    //휴가사용율(%)            
}



