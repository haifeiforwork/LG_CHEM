package hris.D.D01OT;

/**
 * D01OTSchduleData.java
 *  초과 근무수당의 근무스케줄을 담는 데이터
 *   [관련 RFC] : ZHRP_RFC_GET_WORK_SCHEDULE  
 * 
 * @author 박영락
 * @version 1.0, 2002/01/24
 */
public class D01OTSchduleData extends com.sns.jdf.EntityData {

    public String BEGDA;      //근무일
    public String BEGUZ;      //시작시간
    public String ENDUZ;      //종료시간
    public String FLAG;       //확인 1: 초과근무 2: 근무시간

}
