/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청                                             */
/*   Program Name : 재직증명서 신청                                             */
/*   Program ID   : A15CertiData                                                */
/*   Description  : 재직 증명서를 신청 조회 수정 삭제 하는 정보를 가지는 Data   */
/*   Note         : [관련 RFC] : ZHRH_RFC_OFFICE_DOC                            */
/*   Creation     : 2002-01-03  박영락                                          */
/*   Update       : 2005-02-24  유용원                                          */
/*                  2005-03-04  윤정현                                          */
/*                   2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
/********************************************************************************/

package hris.A.A15Certi;

public class A15CertiData extends com.sns.jdf.EntityData {

    /* 해외 */
    public String	CERT_CODE	;//	CHAR	4	Certificate code
    public String	JIKWE	;//	CHAR	 4 	Title of Level
    public String	JIKCH	;//	CHAR	 4 	Level
    public String	USEFL	;//	CHAR	 40 	Use
    public String	ISSUE_CNT	;//	DEC	 3 	Issue Count
    public String	PERNR_D	;//	CHAR	 10 	Personnel Number
    public String	CHGJOB	;//	CHAR	 1 	Changing Job flag (1-解止, 2-終止)
    public String	PROVID1	;//	CHAR	 2 	legal provision id 1
    public String	PROVID2	;//	CHAR	 2 	legal provision id 2
    public String	USECD	;//	CHAR	 2 	Use code
    public String	INCTYP	;//	CHAR	 1 	IncomeType(1-?前月收入, 2-?后月收入)

    //input Field
    public String I_PERNR;      //사원번호
    public String I_AINF_SEQN;  //결재정보 일련번호
    public String I_COND_TYPE;  //동작 플래그 1:조회 2:입력 3:수정 4:삭제

    //수정 유용원(20050224)
    //table
    public String MANDT      ;  //클라이언트
    public String PERNR      ;  //사원번호
    public String BEGDA      ;  //신청일
    public String AINF_SEQN  ;  //결재정보 일련번호
    public String LANG_TYPE  ;  //증명서 출력유형(한글,영문)
    public String PRINT_NUM  ;  //발행부수
    public String ADDRESS1   ;  //현주소
    public String ADDRESS2   ;  //현주소
    public String PHONE_NUM  ;  //전화번호
    public String SUBMIT_PLACE; //제출처
    public String USE_PLACE  ;  //용도
    public String SPEC_ENTRY1;  //특기사항
    public String SPEC_ENTRY2;  //특기사항
    public String SPEC_ENTRY3;  //특기사항
    public String SPEC_ENTRY4;  //특기사항
    public String SPEC_ENTRY5;  //특기사항
    public String ENTR_DATE  ;  //입사일자
    public String TITEL      ;  //직위
    public String STELL      ;  //직무
    public String ORGEH      ;  //소속부서
    public String TITEL_FLAG ;  //직책출력여부( 'X' -> 직책출력 ' '-> 직책출력 안함)
    public String PUBLIC_NUM ;  //발행번호
    public String PUBLIC_DTE ;  //발행일
    public String PUBLIC_MAN ;  //발행인
    public String JUSO_CODE  ;  //주소코드
    public String ORGTX_E    ;  //소속명
    public String ORGTX_E2    ;  //소속명
    public String STELLTX    ;  //직무명
    public String ZPERNR     ;  //대리신청자 사번
    public String ZUNAME     ;  //부서서무 이름
    public String AEDTM      ;  //변경일
    public String UNAME      ;  //사용자이름
    public String REGNO      ;  //주민등록번호
    public String PRINT_CHK   ;        //발행방법:본인발행(1), 담당부서 요청발행(2)
    public String PRINT_END   ;        //본인발행 완료시 'X'

    //[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start
    public String TITL2          ;  //직책

	public String getTITL2() {
		return TITL2;
	}

	public void setTITL2(String tITL2) {
		TITL2 = tITL2;
	}
	//[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end

	public String getI_PERNR() {
        return I_PERNR;
    }

    public void setI_PERNR(String i_PERNR) {
        I_PERNR = i_PERNR;
    }

    public String getI_AINF_SEQN() {
        return I_AINF_SEQN;
    }

    public void setI_AINF_SEQN(String i_AINF_SEQN) {
        I_AINF_SEQN = i_AINF_SEQN;
    }

    public String getI_COND_TYPE() {
        return I_COND_TYPE;
    }

    public void setI_COND_TYPE(String i_COND_TYPE) {
        I_COND_TYPE = i_COND_TYPE;
    }

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

    public String getLANG_TYPE() {
        return LANG_TYPE;
    }

    public void setLANG_TYPE(String LANG_TYPE) {
        this.LANG_TYPE = LANG_TYPE;
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

    public String getORGTX_E2() {
        return ORGTX_E2;
    }

    public void setORGTX_E2(String ORGTX_E2) {
        this.ORGTX_E2 = ORGTX_E2;
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

    public String getUNAME() {
        return UNAME;
    }

    public void setUNAME(String UNAME) {
        this.UNAME = UNAME;
    }

    public String getREGNO() {
        return REGNO;
    }

    public void setREGNO(String REGNO) {
        this.REGNO = REGNO;
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

    public String getCERT_CODE() {
        return CERT_CODE;
    }

    public void setCERT_CODE(String CERT_CODE) {
        this.CERT_CODE = CERT_CODE;
    }

    public String getJIKWE() {
        return JIKWE;
    }

    public void setJIKWE(String JIKWE) {
        this.JIKWE = JIKWE;
    }

    public String getJIKCH() {
        return JIKCH;
    }

    public void setJIKCH(String JIKCH) {
        this.JIKCH = JIKCH;
    }

    public String getUSEFL() {
        return USEFL;
    }

    public void setUSEFL(String USEFL) {
        this.USEFL = USEFL;
    }

    public String getISSUE_CNT() {
        return ISSUE_CNT;
    }

    public void setISSUE_CNT(String ISSUE_CNT) {
        this.ISSUE_CNT = ISSUE_CNT;
    }

    public String getPERNR_D() {
        return PERNR_D;
    }

    public void setPERNR_D(String PERNR_D) {
        this.PERNR_D = PERNR_D;
    }

    public String getCHGJOB() {
        return CHGJOB;
    }

    public void setCHGJOB(String CHGJOB) {
        this.CHGJOB = CHGJOB;
    }

    public String getPROVID1() {
        return PROVID1;
    }

    public void setPROVID1(String PROVID1) {
        this.PROVID1 = PROVID1;
    }

    public String getPROVID2() {
        return PROVID2;
    }

    public void setPROVID2(String PROVID2) {
        this.PROVID2 = PROVID2;
    }

    public String getUSECD() {
        return USECD;
    }

    public void setUSECD(String USECD) {
        this.USECD = USECD;
    }

    public String getINCTYP() {
        return INCTYP;
    }

    public void setINCTYP(String INCTYP) {
        this.INCTYP = INCTYP;
    }
}
