/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 근태                                                       		 	*/
/*   Program Name : 부서별 휴가사유리포트                                      			*/
/*   Program ID   : F45DeptVacationReasonData                                   */
/*   Description  : 부서별 휴가 사용 현황 조회를 위한 DATA 파일                 		*/
/*   Note         : 없음                                                                 */
/*   Creation     : 2010-03-16 lsa                                           	*/
/*   Update       : 2018-07-31 성환희 [Worktime52] 경로,미확정사유 추가 			*/
/*                                                                              */
/********************************************************************************/

package hris.F;  

/**
 * F41DeptVacationData
 *  부서별 휴가사유리포트 내용을 담는 데이터
 * 
 * @author lsa
 * @version 1.0, 
 */ 
public class F45DeptVacationReasonData extends com.sns.jdf.EntityData {
    public String PERNR         ;    //사원 번호                         
    public String ENAME         ;    //사원 또는 지원자의 포맷된 이름
    public String AWART         ;    //근무/휴무 유형                
    public String ATEXT         ;    //근무/휴무 유형 텍스트         
    public String BEGDA         ;    //시작일                        
    public String ENDDA         ;    //종료일                        
    public String BEGUZ         ;    //시작 시간                     
    public String ENDUZ         ;    //종료 시간                     
    public String PBEG1         ;    //휴식 시작                     
    public String PEND1         ;    //휴식 종료                     
    public String STDAZ         ;    //초과근무시간                  
    public String REQU_DATE     ;    //신청일                
    public String APPR_DATE     ;    //승인일                
    public String APPU_NUMB     ;    //결재자 사번           
    public String CONG_NAME     ;    //경조내역코드명        
    public String REASON        ;    //신청사유                      
    public String ORGEH         ;    //조직 단위                     
    public String ORGTX         ;    //오브젝트 이름      
    public String PERSG         ;    //사원 그룹                                                                                             
    public String PTEXT         ;    //사원 그룹 이름                                                                                        
    public String PERSK         ;    //사원 하위 그룹                                                                                        
    public String PTEXT1        ;    //사원 하위 그룹 이름                                                                                   
    public String AINF_SEQN     ;    //결재정보 일련번호                                                                             
    public String OVTM_CODE     ;    //사유코드                                                                                      
    public String OVTM_CD_NAME  ;    //사유명                                                                                        
    public String OVTM_NAME     ;    //대근자           
    public String INPUT_PASS    ;    //경로           
    public String UNCONFIRM_RESN;    //미확정사유           
}
