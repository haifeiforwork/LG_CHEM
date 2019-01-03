package hris.J.J01JobMatrix;

/**
 * J01ImageFileNameData.java
 * Eloffice의 Job Unit별 KSEA, Job Process Image FileName Data format
 * [관련 RFC] : ZHRH_RFC_GET_IMAGE_FILENAME
 * 
 * @author  김도신
 * @version 1.0, 2003/05/14
 */
public class J01ImageFileNameData extends com.sns.jdf.EntityData {

//  P_RESULT(ZHRH110T)
    public String TASK_CODE ;     // Task Code
    public String GUBN_CODE ;     // KSEA = '1', Process = '2'를 구분
    public String BEGDA     ;     // 시작일
    public String SEQN_NUMB ;     // 순번
    public String IMAG_NAME ;     // File 명

//  P_RESULT_P(ZHRH102S)
    public String SOBID     ;     // Position ID
    public String PERNR     ;     // 사번
    public String TITEL     ;     // 직급호칭(직위)
    public String ENAME     ;     // 성명
    
//  P_RESULT_D(ZHRH103S)
    public String OBJID     ;     // 직무 ID
    public String SUBTY     ;     // 상세내역 하부유형
    public String SEQNO     ;     // 상세내역 순번
    public String TLINE     ;     // 상세 DATA

    public String E_MATCH   ;     // 기존파일 매치여부
    
}   
    
    