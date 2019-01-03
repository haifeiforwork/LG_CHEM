/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 월간 근태 집계표                                            		*/
/*   Program ID   : F42DeptMonthWorkConditionData                               */
/*   Description  : 부서별 월간 근태 집계표 조회를 위한 DATA 파일               		*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2005-02-17 유용원                                           		*/
/*   Update       : 2018-07-19 성환희 [Worktime52] 잔여보상휴가, 보상휴가 필드 추가	*/
/*                                                                              */
/********************************************************************************/

package hris.F;  

/**
 * F42DeptMonthWorkConditionData
 *  부서별 월간 근태 집계표 내용을 담는 데이터
 *  
 * @author 유용원
 * @version 1.0, 
 */
public class F42DeptMonthWorkConditionData extends com.sns.jdf.EntityData {
    public String ORGEH      ;  //부서코드     
    public String STEXT      ;  //부서명       
    public String ENAME      ;  //성명         
    public String PERNR      ;  //사번  (Total 일 경우는 0000000)       
    public String REMA_HUGA  ;	//잔여휴가
    public String REMA_RWHUGA;	//잔여보상휴가
    public String HUGA       ;  //휴가         
    public String RWHUGA     ;  //보상휴가         
    public String KHUGA      ;  //경조휴가     
    public String HHUGA      ;  //하계휴가     
    public String BHUG       ;  //보건휴가       
    public String MHUG       ;  //모성보호휴가 추가 ※CSR ID:C20111025_86242    
    public String GONGA      ;  //공가         
    public String KYULKN     ;  //결근         
    public String JIGAK      ;  //지각         
    public String JOTAE      ;  //조퇴         
    public String WECHUL     ;  //외출         
    public String MUNO       ;  //무노동 무임금
    public String GOYUK      ;  //교육         
    public String CHULJANG   ;  //출장         
    public String HTKGUN     ;  //휴일특근     
    public String TTKGUN     ;  //토요특근     
    public String MTKGUN     ;  //명절특근     
    public String MTKGUN_T   ;  //명정특근(토) 
    public String HYUNJANG   ;  //휴일연장     
    public String YUNJANG    ;  //연장근로     
    public String YAGAN      ;  //야간근로     
    public String DANGJIC    ;  //당직         
    public String HYANGUN    ;  //향군(근무외) 
    public String KOYUK      ;  //교육(근무외) 
    public String KONGSU     ;  //공수         
    public String KONGSU_HOUR;  //공수(시간)    
}
