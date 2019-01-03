/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 부서별 휴가 사용 현황                                       		*/
/*   Program ID   : F41DeptVacationData                                         */
/*   Description  : 부서별 휴가 사용 현황 조회를 위한 DATA 파일                 		*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2005-02-21 유용원                                           		*/
/*   Update       : 2018-05-18 성환희 [WorkTime52] 보상휴가 추가 건			 	*/
/*                                                                              */
/********************************************************************************/

package hris.F;  

/**
 * F41DeptVacationData
 *  부서별 휴가 사용 현황 내용을 담는 데이터
 * 
 * @author 유용원
 * @version 1.0, 
 */ 
public class F41DeptVacationData extends com.sns.jdf.EntityData {
    public String PERNR;    	//사원번호              
    public String KNAME;    	//한글이름              
    public String ORGTX;    	//조직단위텍스트        
    public String TITL2;    	//직책                  
    public String TITEL;    	//직위                  
    public String TRFGR;    	//급여그룹(직급)        
    public String TRFST;    	//급여레벨(호봉)        
    public String VGLST;    	//비교급여범위레벨(연차)
    public String DAT01;    	//입사일자              
    public String OCCUR1;    	//연차휴가-발생일수              
    public String ABWTG1;    	//연차휴가-사용일수   
    public String ZKVRB1;    	//연차휴가-잔여일수    
    public String CONSUMRATE1;	//연차휴가-휴가사용율
    public String OCCUR2;    	//보상휴가-발생일수              
    public String ABWTG2;    	//보상휴가-사용일수   
    public String ZKVRB2;    	//보상휴가-잔여일수    
    public String CONSUMRATE2;	//보상휴가-휴가사용율
}
