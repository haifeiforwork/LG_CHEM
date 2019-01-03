package	hris.common;

/**
 * AppLineKey.java
 * 하나의 Row의 결재정보에 가져오기 위한 Key
 *   [관련 RFC] :  ZHRA_RFC_FIND_DECISIONER  
 *
 * @author 김성일  
 * @version 1.0, 2001/12/13
 */
public class AppLineKey extends com.sns.jdf.EntityData {

    public String APPR_TYPE;    //결재형태
    public String I_DATE   ;    //신청일자(어플리케이션일자)
    public String I_PERNR  ;    //사원번호
    public String UPMU_FLAG;    //업무구분지시자
	public String UPMU_TYPE;    //업무구분
    public String from_date;    //신청일 From
    public String to_date  ;    //신청일 To
    public String APPR_STAT;    //결재상태
    public String ANZHL;    //결재상태
    public String E_ABRTG;    //결재상태
    public String DAYS;    //결재상태
    public String AWART;    //결재상태
}
