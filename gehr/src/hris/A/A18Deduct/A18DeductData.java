package hris.A.A18Deduct;

/**
 * A18DeductData.java
 * 근로소득 원천징수 영수증, 갑근세 원천징수 증명서를 신청/수정/삭제하는 정보를 가지는 Data
 * [관련 RFC] : ZHRH_RFC_DEDUCT_TAXES_DOC
 * 
 * @author  김도신
 * @version 1.0, 2002/10/22
 * 수정(20050223:유용원)
 */
public class A18DeductData extends com.sns.jdf.EntityData {
	public String MANDT       ;    //클라이언트(회사코드)
	
    public String PERNR       ;    //사원번호                                          
    public String BEGDA       ;    //신청일                                            
    public String AINF_SEQN   ;    //결재정보 일련번호                                 
    public String GUEN_TYPE   ;    //근로소득및 갑근세 원천징수 구분                   
    public String PRINT_NUM   ;    //발행부수                                          
    public String ADDRESS1    ;    //현주소                                            
    public String ADDRESS2    ;    //현주소                                            
    public String PHONE_NUM   ;    //전화번호                                          
    public String SUBMIT_PLACE;    //제출처                                            
    public String USE_PLACE   ;    //용도                                              
    public String SPEC_ENTRY1 ;    //특기사항                                          
    public String SPEC_ENTRY2 ;    //특기사항                                          
    public String SPEC_ENTRY3 ;    //특기사항                                          
    public String SPEC_ENTRY4 ;    //특기사항                                          
    public String SPEC_ENTRY5 ;    //특기사항                                          
    public String ENTR_DATE   ;    //입사일자                                          
    public String TITEL       ;    //직위                                              
    public String STELL       ;    //직무                                              
    public String ORGEH       ;    //소속부서                                          
    public String TITEL_FLAG  ;    //직책출력여부( 'X' -> 직책출력 ' '-> 직책출력 안함)
    public String PUBLIC_NUM  ;    //발행번호                                          
    public String PUBLIC_DTE  ;    //발행일                                            
    public String PUBLIC_MAN  ;    //발행인                                            
    public String JUSO_CODE   ;    //주소코드                                          
    public String ORGTX_E     ;    //오브젝트이름                                      
    public String STELLTX     ;    //직무명                                            
    public String ZPERNR      ;    //대리신청자 사번                                   
    public String ZUNAME      ;    //부서서무 이름                                     
    public String AEDTM       ;    //변경일                                            
    public String EBEGDA      ;    //기타기간 시작                                     
    public String EENDDA      ;    //기타기간 종료일                                   
    public String UNAME       ;    //사용자이름 
    public String PRINT_CHK   ;        //발행방법:본인발행(1), 담당부서 요청발행(2)
    public String PRINT_END   ;        //본인발행 완료시 'X'

    public String getMANDT() {
        return MANDT;
    }

    public void setMANDT(String MANDT) {
        this.MANDT = MANDT;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getGUEN_TYPE() {
        return GUEN_TYPE;
    }

    public void setGUEN_TYPE(String GUEN_TYPE) {
        this.GUEN_TYPE = GUEN_TYPE;
    }

    public String getPRINT_NUM() {
        return PRINT_NUM;
    }

    public void setPRINT_NUM(String PRINT_NUM) {
        this.PRINT_NUM = PRINT_NUM;
    }

    public String getADDRESS1() {
        return ADDRESS1;
    }

    public void setADDRESS1(String ADDRESS1) {
        this.ADDRESS1 = ADDRESS1;
    }

    public String getADDRESS2() {
        return ADDRESS2;
    }

    public void setADDRESS2(String ADDRESS2) {
        this.ADDRESS2 = ADDRESS2;
    }

    public String getPHONE_NUM() {
        return PHONE_NUM;
    }

    public void setPHONE_NUM(String PHONE_NUM) {
        this.PHONE_NUM = PHONE_NUM;
    }

    public String getSUBMIT_PLACE() {
        return SUBMIT_PLACE;
    }

    public void setSUBMIT_PLACE(String SUBMIT_PLACE) {
        this.SUBMIT_PLACE = SUBMIT_PLACE;
    }

    public String getUSE_PLACE() {
        return USE_PLACE;
    }

    public void setUSE_PLACE(String USE_PLACE) {
        this.USE_PLACE = USE_PLACE;
    }

    public String getSPEC_ENTRY1() {
        return SPEC_ENTRY1;
    }

    public void setSPEC_ENTRY1(String SPEC_ENTRY1) {
        this.SPEC_ENTRY1 = SPEC_ENTRY1;
    }

    public String getSPEC_ENTRY2() {
        return SPEC_ENTRY2;
    }

    public void setSPEC_ENTRY2(String SPEC_ENTRY2) {
        this.SPEC_ENTRY2 = SPEC_ENTRY2;
    }

    public String getSPEC_ENTRY3() {
        return SPEC_ENTRY3;
    }

    public void setSPEC_ENTRY3(String SPEC_ENTRY3) {
        this.SPEC_ENTRY3 = SPEC_ENTRY3;
    }

    public String getSPEC_ENTRY4() {
        return SPEC_ENTRY4;
    }

    public void setSPEC_ENTRY4(String SPEC_ENTRY4) {
        this.SPEC_ENTRY4 = SPEC_ENTRY4;
    }

    public String getSPEC_ENTRY5() {
        return SPEC_ENTRY5;
    }

    public void setSPEC_ENTRY5(String SPEC_ENTRY5) {
        this.SPEC_ENTRY5 = SPEC_ENTRY5;
    }

    public String getENTR_DATE() {
        return ENTR_DATE;
    }

    public void setENTR_DATE(String ENTR_DATE) {
        this.ENTR_DATE = ENTR_DATE;
    }

    public String getTITEL() {
        return TITEL;
    }

    public void setTITEL(String TITEL) {
        this.TITEL = TITEL;
    }

    public String getSTELL() {
        return STELL;
    }

    public void setSTELL(String STELL) {
        this.STELL = STELL;
    }

    public String getORGEH() {
        return ORGEH;
    }

    public void setORGEH(String ORGEH) {
        this.ORGEH = ORGEH;
    }

    public String getTITEL_FLAG() {
        return TITEL_FLAG;
    }

    public void setTITEL_FLAG(String TITEL_FLAG) {
        this.TITEL_FLAG = TITEL_FLAG;
    }

    public String getPUBLIC_NUM() {
        return PUBLIC_NUM;
    }

    public void setPUBLIC_NUM(String PUBLIC_NUM) {
        this.PUBLIC_NUM = PUBLIC_NUM;
    }

    public String getPUBLIC_DTE() {
        return PUBLIC_DTE;
    }

    public void setPUBLIC_DTE(String PUBLIC_DTE) {
        this.PUBLIC_DTE = PUBLIC_DTE;
    }

    public String getPUBLIC_MAN() {
        return PUBLIC_MAN;
    }

    public void setPUBLIC_MAN(String PUBLIC_MAN) {
        this.PUBLIC_MAN = PUBLIC_MAN;
    }

    public String getJUSO_CODE() {
        return JUSO_CODE;
    }

    public void setJUSO_CODE(String JUSO_CODE) {
        this.JUSO_CODE = JUSO_CODE;
    }

    public String getORGTX_E() {
        return ORGTX_E;
    }

    public void setORGTX_E(String ORGTX_E) {
        this.ORGTX_E = ORGTX_E;
    }

    public String getSTELLTX() {
        return STELLTX;
    }

    public void setSTELLTX(String STELLTX) {
        this.STELLTX = STELLTX;
    }

    public String getZPERNR() {
        return ZPERNR;
    }

    public void setZPERNR(String ZPERNR) {
        this.ZPERNR = ZPERNR;
    }

    public String getZUNAME() {
        return ZUNAME;
    }

    public void setZUNAME(String ZUNAME) {
        this.ZUNAME = ZUNAME;
    }

    public String getAEDTM() {
        return AEDTM;
    }

    public void setAEDTM(String AEDTM) {
        this.AEDTM = AEDTM;
    }

    public String getEBEGDA() {
        return EBEGDA;
    }

    public void setEBEGDA(String EBEGDA) {
        this.EBEGDA = EBEGDA;
    }

    public String getEENDDA() {
        return EENDDA;
    }

    public void setEENDDA(String EENDDA) {
        this.EENDDA = EENDDA;
    }

    public String getUNAME() {
        return UNAME;
    }

    public void setUNAME(String UNAME) {
        this.UNAME = UNAME;
    }

    public String getPRINT_CHK() {
        return PRINT_CHK;
    }

    public void setPRINT_CHK(String PRINT_CHK) {
        this.PRINT_CHK = PRINT_CHK;
    }

    public String getPRINT_END() {
        return PRINT_END;
    }

    public void setPRINT_END(String PRINT_END) {
        this.PRINT_END = PRINT_END;
    }
}