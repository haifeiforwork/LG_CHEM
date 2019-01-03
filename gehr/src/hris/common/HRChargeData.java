package	hris.common;

/**
 * HRChargeData.java
 * 사업장별 인사담당자 연락처를 담는 데이터 구조
 * [관련 RFC] : ZHRA_RFC_GET_HR_CHARGE
 * 
 * @author 김도신
 * @version 1.0, 2002/09/24
 */
public class HRChargeData extends com.sns.jdf.EntityData {

    public String GRUP_NUMB ;    //사업장
    public String GRUP_NAME ;    //사업장명
    public String UPMU_CODE ;    //업무분야
    public String UPMU_NAME ;    //업무분야명
    public String PERNR     ;    //사원번호 
    public String ENAME     ;    //사원 또는 지원자의 포맷이름 
    public String ORGTX     ;    //조직단위텍스트  
    public String TITEL     ;    //직책
    public String E_MAIL    ;    //인터넷메일 (SMTP) 주소
    public String TELNUMBER ;    //담당자의 전화번호
    public String UPMU_DESC ;    //담당업무 설명

}
