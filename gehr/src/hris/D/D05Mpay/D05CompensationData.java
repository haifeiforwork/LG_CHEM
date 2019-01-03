package	hris.D.D05Mpay;

/**
 * D05CompensationData.java
 * export 정보를 담아오는 데이터
 *   [관련 RFC] : ZGHR_GET_TOTAL_COMPENSATION
 * 
 * @author lsa    
 * @version 1.0, 2012/07/27
 *                     2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
 */
public class D05CompensationData  extends com.sns.jdf.EntityData {
 
    public String BET01 ;   //연급여(급여)                       
    public String BET02 ;   //복리후생 총합                
    public String BET03 ;   //건강                         
    public String BET04 ;   //고용                         
    public String BET05 ;   //국민                         
    public String BET06 ;   //산재                         
    public String BET07 ;   //법정복리후생 총합            
    public String BET08 ;   //경조금                       
    public String BET09 ;   //의료비                       
    public String BET10 ;   //학자금                       
    public String BET11 ;   //장학금                       
    public String BET12 ;   //포상비                       
    public String BET13 ;   //선택적 복리후생 Point        
    public String BET14 ;   //주택자금 이자지원            
    public String BET15 ;   //장기근속상                   
    public String BET16 ;   //법정외 복리후생 총합         
    public String BET17 ;   //종합검진                   
    public String BET18 ;   //단체정기보
    public String BET19 ;   //연급여(상여)     

}