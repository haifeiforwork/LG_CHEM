package hris.G.G20Outpt;

/**
 * G20EcmtPrintKey.java
 * 근로소득원천징수 영수서 출력 정보를 위한 key
 *   [관련 RFC] : ZHRP_RFC_READ_YEA_RESULT_PRIN
 * 
 * @author 
 * @version 
 */
public class G20EcmtPrintKey extends com.sns.jdf.EntityData {
	
    public String I_GUBUN;		 // 구분		1':한글, '2':영문
    public String I_PERNR;		 // 사번	
    public String I_AINF_SEQN;	 // 결재일련번호	
    public String I_PRINT;		 // 출력버튼 	(Y':출력클릭)
}