/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 휴가현황                                                    */
/*   Program ID   : ViewEmpVacationData                                         */
/*   Description  : 초기화면에서 사원 휴가 현황을 보기위한 DATA 파일            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-03 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common; 

/**
 * ViewEmpVacationData
 * 초기화면에서 사원 휴가 현황 정보에 관한 데이터
 *  
 * @author 유용원  
 * @version 1.0, 
 */ 
public class ViewEmpVacationData extends com.sns.jdf.EntityData {
    public String PERNR ;    //사원번호            
    public String KSOLL ;    //근무일수            
    public String OCCUR ;    //발생일수            
    public String ABWTG ;    //사용일수            
    public String ZKVRB ;    //잔여일수            
    public String OCCUR1;    //사전부여 발생일수   
    public String ABWTG1;    //사전부여 사용일수   
    public String ZKVRB1;    //사전부여 잔여일수   
    public String OCCUR2;    //선택적휴가 발생일수
    public String ABWTG2;    //선택적휴가 사용일수
    public String ZKVRB2;    //선택적휴가 잔여일수
}

