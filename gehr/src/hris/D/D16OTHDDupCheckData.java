package hris.D;

/**
 * D16OTHDDupCheckData.java
 *  초과근무와 휴가 신청시 중복 체크를 위해 ZHRA022T 정보를 담아오는 데이터 구조
 *   [관련 RFC] : ZHRW_RFC_OTHD_DUP_CHECK
 *
 * @author 배민규
 * @version 1.0, 2003/10/17
 */
public class D16OTHDDupCheckData extends com.sns.jdf.EntityData {
    public String AINF_SEQN;    //결재정보 일련번호
    public String BEGDA    ;    //신청일
    public String WORK_DATE;    //초과근무일(upmu_type 17)
    public String BEGUZ    ;    //시작시간
    public String ENDUZ    ;    //종료시간
    public String APPR_STAT;    //승인상태

    public void setAINF_SEQN(String value){  	    this.AINF_SEQN = value;	}
    public String getAINF_SEQN(){ 	        			return AINF_SEQN;				}
    public void setBEGDA(String value)			{  	    this.BEGDA = value;	}
    public String getBEGDA(){ 	        				return BEGDA;				}
    public void setWORK_DATE(String value)	{  	    this.WORK_DATE = value;	}
    public String getWORK_DATE(){ 	        		return WORK_DATE;				}
    public void setBEGUZ(String value)			{  	    this.BEGUZ = value;	}
    public String getBEGUZ(){ 	        				return BEGUZ;				}
    public void setENDUZ(String value)		{  	    this.ENDUZ = value;	}
    public String getENDUZ(){ 	        				return ENDUZ;				}
    public void setAPPR_STAT(String value){  	    this.APPR_STAT = value;	}
    public String getAPPR_STAT(){ 	        			return APPR_STAT;				}

}
