package	hris.E.E15General;

/**
 * E15GeneralDayData.java
 * 종합검진 신청 기간에 대한 데이터
 *   [관련 RFC] : ZHRW_RFC_MEDIC_APPLY
 * 
 * @author LSA
 * @version 1.0, 2012/01/02
 */
public class E15GeneralDayData extends com.sns.jdf.EntityData {
	
    public String MANDT		;  //클라이언트                         
    public String GRUP_NUMB	;  //사업장             
    public String GRUP_NAME	;  //사업장명           
    public String DATE_FROM	;  //신청기간 FROM      
    public String DATE_TO	;  //신청기간 TO                
    public String BEFORE_MSG	;  //신청기간 전 MESSAGE
    public String AFTER_MSG	;  //신청기간 후 MESSAGE
    public String MAIL_MONTH	;  //CHECKBOX TYPE      
    public String MAIL_WEEK	;  //CHECKBOX TYPE      
    public String MAIL_DAY	;  //CHECKBOX TYPE      

}
