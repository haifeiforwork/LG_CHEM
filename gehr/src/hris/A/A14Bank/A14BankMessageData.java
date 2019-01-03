/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 급여계좌정보                                                */
/*   Program Name : 급여계좌 신청                                               */
/*   Program ID   : A14BankStockFeeData                                         */
/*   Description  : 급여계좌 신청 정보를 담아오는 데이터                        */
/*   Note         : [관련 RFC] : ZHRH_RFC_BANK_STOCK_FEE_LIST                   */
/*   Creation     : 2002-01-08  김도신                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package hris.A.A14Bank;

public class A14BankMessageData extends com.sns.jdf.EntityData {

    public String TYPE      ;      //메시지 유형: S 성공, E 오류, W 경고, I 정보, A 중단         
    public String CODE      ;      //메시지 코드                                                 
    public String MESSAGE   ;      //메시지 텍스트                                               
    public String LOG_NO    ;      //어플리케이션 로그: 로그 번호                                
    public String LOG_MSG_NO;      //어플리케이션 로그: 내부 메시지 일련 번호                    
    public String MESSAGE_V1;                                                                  
    public String MESSAGE_V2;                                                                  
    public String MESSAGE_V3;                                                                  
    public String MESSAGE_V4;                 

}
