package hris.D.D01OT;

/**
 * D01OTHolidayCheckData.java
 *  한계결정한 시간 정보를 담아오는 데이터 구조
 *   [관련 RFC] : ZHRW_RFC_IS_AVAIL_OVERTIME
 * 
 * @author 김도신
 * @version 1.0, 2014-05-13  C20140515_40601
 */
public class D01OTHolidayCheckData extends com.sns.jdf.EntityData {
    public String DATE      ;      //공휴일과 공장달력에 대한 일자             
    public String FREEDAY   ;      //공장달력 표시                             
    public String HOLIDAY   ;      //공장달력 표시                             
    public String HOLIDAY_ID;      //공휴일 키                                 
    public String TXT_SHORT ;      //공휴일, 내역                              
    public String TXT_LONG  ;      //설명                                      
    public String WEEKDAY   ;      //달력: 일수                                
    public String WEEKDAY_S ;      //달력: 일자내역                            
    public String WEEKDAY_L ;      //일                                        
    public String DAY_STRING;      //포맷된 일일속성                           

}
