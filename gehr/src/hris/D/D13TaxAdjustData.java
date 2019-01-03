package hris.D ;

/**
 * D13TaxAdjustData.java
 * 연말정산 시뮬레이션 Data
 * 
 * @author 김성일 
 * @version 1.0, 2002/01/31
 */
public class D13TaxAdjustData extends com.sns.jdf.EntityData {


    public double _총급여                   ;  //  당해연도 총급여 . 초기에 세팅되어야함.                                             
    public double _과세대상근로소득         ;  // 과세대상 근로소득 . 초기에 세팅되어야함.                                            
    public double _근로소득금액             ;  // 근로소득금액 . 초기에 세팅되어야함.                                                 
                                                                                                    
    //public double _당해과세연도종합소득금액 ; // equal _근로소득금액. 당해 과세연도 종합소득금액                                  
 
    public double _국외원천근로소득금액     ;  //  국외원천근로소득금액 . 초기에 세팅되어야함.                                        
                                                                                                    
    public double _근로세액공제             ;  //  근로세액공제 .                                                                         
    public double _과세표준                 ;  //  과세표준 .                                                                         
    public double _산출세액                 ;  //  산출세액 .                                                                         
    public double _기본세율                 ;  //  기본세율                                                                           
    public double _결정세액                 ;  //  결정세액 .                                                                         
    public double _기납부세액               ;  //  기납부세액 .                                                                       
    public double _납부환급액               ;  //  납부환급액 .                                                                       

    public double _인적공제총액             ;     // 인적공제  
    
    public double _의료보험료               ;     //                               
    public double _고용보험료               ;     //                               
    public double _보험료일반               ;     //                               
    public double _보험료장애자             ;     //                               
    public double _의료비일반               ;     //                               
    public double _의료비경로장애           ;     //                               
    public double _주택자금저축금액         ;     //                               
    public double _주택자금차입원리금       ;     //                               
    public double _주택자금차입이자상환     ;     //                               
    public double _기부금법정               ;     //                               
    public double _기부금지정               ;     //             
                                                                 
    public double _교육비본인               ;     // 교육비 관련                              
    public double _교육비영유아             ;     //                               
    public double _교육비초중고             ;     //             
    public double _교육비대학               ;     //             
                                                                 
    public double _개인연금I                ;     //                               
    public double _개인연금II               ;     //                               
    public double _국민연금                 ;     //                               
    public double _투자조합공제I            ;     //                               
    public double _투자조합공제II           ;     //                               
    public double _신용카드공제             ;     //                               
                                                                 
    public double _주택자금이자상환         ;     //                               
    public double _근로자주식저축           ;     //                               
    public double _장기증권저축             ;     //                               
    public double _외국납부세당년           ;     //                               
    public double _외국납부세이월분         ;     //                               

}
