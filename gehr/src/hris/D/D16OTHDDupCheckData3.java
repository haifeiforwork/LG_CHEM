package hris.D;

/**
 * D16OTHDDupCheckData3.java
 * 개인연금 신청시 중복 체크를 위해 ZHRA005T 정보를 담아오는 데이터 구조
 * [관련 RFC] : ZHRW_RFC_OTHD_DUP_CHECK
 *
 * @author 윤정현
 * @version 1.0, 2004/09/07
 */
public class D16OTHDDupCheckData3 extends com.sns.jdf.EntityData {
	  public String AINF_SEQN	;		//결재정보 일련번호
    public String BEGDA     ;		//신청일
}
