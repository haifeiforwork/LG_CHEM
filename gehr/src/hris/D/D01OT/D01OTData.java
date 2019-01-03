/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 초과근무                                                    */
/*   Program Name : 초과근무                                                    */
/*   Program ID   : D01OTData                                                   */
/*   Description  : 초과 근무수당의 입력 수정 삭제를 담는 데이터                */
/*   Note         : [관련 RFC] : ZHRP_RFC_OVERTIME_WORK                         */
/*   Creation     : 2002-01-21  박영락                                          */
/*   Update       : 2005-03-02  윤정현                                          */
/*                  2015-06-18  [CSR ID:2803878] 초과근무 신청 Process 변경 요청 */
/*                  2017-12-06  이지은                                          */
/*                              [CSR ID:3544114] [LGCTW]Request of Global HR Portal system Compensatory Leave(補休假) function increasing  */
/*                  2018-06-14  [WorkTime52] I_NTM 변수 추가                    */
/********************************************************************************/

package hris.D.D01OT;

@SuppressWarnings("serial")
public class D01OTData extends com.sns.jdf.EntityData {

	public String PERNR;      //사원번호
    public String AINF_SEQN;  //결재정보 일련번호

    public String BEGDA;      //신청일
    public String WORK_DATE;  //시작일
    public String VTKEN;      //전일지시자
    
    public String BEGUZ;      //시작시간
    public String ENDUZ;      //종료시간
    public String STDAZ;      //초과근무시간

    public String PBEG1;      //휴식시작1
    public String PEND1;      //휴식종료1
    public String PUNB1;      //무급휴식시간1
    public String PBEZ1;      //유급휴식시간1

    public String PBEG2;      //휴식시작2
    public String PEND2;      //휴식종료2
    public String PUNB2;      //무급휴식시간2
    public String PBEZ2;      //유급휴식시간2
    
    public String PBEG3;      //휴식시작3
    public String PEND3;      //휴식종료3
    public String PUNB3;      //무급휴식시간3
    public String PBEZ3;      //유급휴식시간3

    public String PBEG4;      //휴식시작4
    public String PEND4;      //휴식종료4
    public String PUNB4;      //무급휴식시간4
    public String PBEZ4;      //유급휴식시간4

    public String OVTM_CODE;   //사유코드 CSR ID:1546748
    public String OVTM_NAME;   //원근무자,대근자   CSR ID:1546748
    public String REASON;      //신청이유
    public String ZPERNR;      //대리신청자사번
    public String ZUNAME;      //부서서무 이름
    public String AEDTM;       //변경일
    public String UNAME;       //사용자이름
    public String OVTM_DESC1;  //[CSR ID:2803878] 초과근무 화면 항목 추가 상세 일정
    public String OVTM_DESC2;  //[CSR ID:2803878] 초과근무 화면 항목 추가 상세 일정
    public String OVTM_DESC3;  //[CSR ID:2803878] 초과근무 화면 항목 추가 상세 일정
    public String OVTM_DESC4;  //[CSR ID:2803878] 초과근무 화면 항목 추가 상세 일정
    public String OVTM12YN;    //[CSR ID:2803878] 12시간 초과이나 그래도 난 신청할거야! N
    public String YN_FLAG;     //[CSR ID:2803878] 'Y'는 신청 가능한 경우, 'N'은 신청은 가능하나 초과근무범위를 넘어섬. (생산직 : 주당 22시간, 사무직 : 월당 36시간)
    public String SUM;         //[CSR ID:2803878] 신청하고 있는 순간의 시간도 포함하여 생산직의 경우 주당(월~일) 초과근무 시간, 사무직의 경우 월당(전달 21부터 이번 달 20일 기준) 초과근무 시간 신청한 총 값을 계산
    public String PERSON_FLAG; //[CSR ID:2803878]  신청자가 사무직인지 생산직인지 구분하는 flag(생산직 : P, 사무직 : O)
    public String VERSL;       //[CSR ID:3544114] 초과근무 보상 값 선택(G220법인만) [대체휴가 : 3, 금액보상 : 0]  
    public String I_NTM;       //[WorkTime52]
    public String ZOVTYP;      //[WorkTime52]

    //Global
    public String ZREASON;
    public String ZRCODE;
    public String PERNR_D;

    public String getPERNR() {
        return PERNR;
    }
    public void setPERNR(String pERNR) {
        PERNR = pERNR;
    }
    public String getAINF_SEQN() {
        return AINF_SEQN;
    }
    public void setAINF_SEQN(String aINF_SEQN) {
        AINF_SEQN = aINF_SEQN;
    }
    public String getBEGDA() {
        return BEGDA;
    }
    public void setBEGDA(String bEGDA) {
        BEGDA = bEGDA;
    }
    public String getWORK_DATE() {
        return WORK_DATE;
    }
    public void setWORK_DATE(String wORK_DATE) {
        WORK_DATE = wORK_DATE;
    }
    public String getVTKEN() {
        return VTKEN;
    }
    public void setVTKEN(String vTKEN) {
        VTKEN = vTKEN;
    }
    public String getBEGUZ() {
        return BEGUZ;
    }
    public void setBEGUZ(String bEGUZ) {
        BEGUZ = bEGUZ;
    }
    public String getENDUZ() {
        return ENDUZ;
    }
    public void setENDUZ(String eNDUZ) {
        ENDUZ = eNDUZ;
    }
    public String getSTDAZ() {
        return STDAZ;
    }
    public void setSTDAZ(String sTDAZ) {
        STDAZ = sTDAZ;
    }
    public String getPBEG1() {
        return PBEG1;
    }
    public void setPBEG1(String pBEG1) {
        PBEG1 = pBEG1;
    }
    public String getPEND1() {
        return PEND1;
    }
    public void setPEND1(String pEND1) {
        PEND1 = pEND1;
    }
    public String getPUNB1() {
        return PUNB1;
    }
    public void setPUNB1(String pUNB1) {
        PUNB1 = pUNB1;
    }
    public String getPBEZ1() {
        return PBEZ1;
    }
    public void setPBEZ1(String pBEZ1) {
        PBEZ1 = pBEZ1;
    }
    public String getPBEG2() {
        return PBEG2;
    }
    public void setPBEG2(String pBEG2) {
        PBEG2 = pBEG2;
    }
    public String getPEND2() {
        return PEND2;
    }
    public void setPEND2(String pEND2) {
        PEND2 = pEND2;
    }
    public String getPUNB2() {
        return PUNB2;
    }
    public void setPUNB2(String pUNB2) {
        PUNB2 = pUNB2;
    }
    public String getPBEZ2() {
        return PBEZ2;
    }
    public void setPBEZ2(String pBEZ2) {
        PBEZ2 = pBEZ2;
    }
    public String getPBEG3() {
        return PBEG3;
    }
    public void setPBEG3(String pBEG3) {
        PBEG3 = pBEG3;
    }
    public String getPEND3() {
        return PEND3;
    }
    public void setPEND3(String pEND3) {
        PEND3 = pEND3;
    }
    public String getPUNB3() {
        return PUNB3;
    }
    public void setPUNB3(String pUNB3) {
        PUNB3 = pUNB3;
    }
    public String getPBEZ3() {
        return PBEZ3;
    }
    public void setPBEZ3(String pBEZ3) {
        PBEZ3 = pBEZ3;
    }
    public String getPBEG4() {
        return PBEG4;
    }
    public void setPBEG4(String pBEG4) {
        PBEG4 = pBEG4;
    }
    public String getPEND4() {
        return PEND4;
    }
    public void setPEND4(String pEND4) {
        PEND4 = pEND4;
    }
    public String getPUNB4() {
        return PUNB4;
    }
    public void setPUNB4(String pUNB4) {
        PUNB4 = pUNB4;
    }
    public String getPBEZ4() {
        return PBEZ4;
    }
    public void setPBEZ4(String pBEZ4) {
        PBEZ4 = pBEZ4;
    }
    public String getREASON() {
        return REASON;
    }
    public void setREASON(String rEASON) {
        REASON = rEASON;
    }
    public String getZPERNR() {
        return ZPERNR;
    }
    public void setZPERNR(String zPERNR) {
        ZPERNR = zPERNR;
    }
    public String getZUNAME() {
        return ZUNAME;
    }
    public void setZUNAME(String zUNAME) {
        ZUNAME = zUNAME;
    }
    public String getAEDTM() {
        return AEDTM;
    }
    public void setAEDTM(String aEDTM) {
        AEDTM = aEDTM;
    }
    public String getUNAME() {
        return UNAME;
    }
    public void setUNAME(String uNAME) {
        UNAME = uNAME;
    }
    public String getOVTM_CODE() {
        return OVTM_CODE;
    }
    public void setOVTM_CODE(String oVTM_CODE) {
        OVTM_CODE = oVTM_CODE;
    }
    public String getOVTM_NAME() {
        return OVTM_NAME;
    }
    public void setOVTM_NAME(String oVTM_NAME) {
        OVTM_NAME = oVTM_NAME;
    }
    public String getOVTM_DESC1() {
        return OVTM_DESC1;
    }
    public void setOVTM_DESC1(String oVTM_DESC1) {
        OVTM_DESC1 = oVTM_DESC1;
    }
    public String getOVTM_DESC2() {
        return OVTM_DESC2;
    }
    public void setOVTM_DESC2(String oVTM_DESC2) {
        OVTM_DESC2 = oVTM_DESC2;
    }
    public String getOVTM_DESC3() {
        return OVTM_DESC3;
    }
    public void setOVTM_DESC3(String oVTM_DESC3) {
        OVTM_DESC3 = oVTM_DESC3;
    }
    public String getOVTM_DESC4() {
        return OVTM_DESC4;
    }
    public void setOVTM_DESC4(String oVTM_DESC4) {
        OVTM_DESC4 = oVTM_DESC4;
    }
    public String getOVTM12YN() {
        return OVTM12YN;
    }
    public void setOVTM12YN(String oVTM12YN) {
        OVTM12YN = oVTM12YN;
    }
    public String getYN_FLAG() {
        return YN_FLAG;
    }
    public void setYN_FLAG(String yN_FLAG) {
        YN_FLAG = yN_FLAG;
    }
    public String getSUM() {
        return SUM;
    }
    public void setSUM(String sUM) {
        SUM = sUM;
    }
    public String getPERSON_FLAG() {
        return PERSON_FLAG;
    }
    public void setPERSON_FLAG(String pERSON_FLAG) {
        PERSON_FLAG = pERSON_FLAG;
    }
    public String getVERSL() {
        return VERSL;
    }
    public void setVERSL(String vERSL) {
        VERSL = vERSL;
    }
    public String getI_NTM() {
        return I_NTM;
    }
    public void setI_NTM(String i_NTM) {
        I_NTM = i_NTM;
    }
    public String getZOVTYP() {
        return ZOVTYP;
    }
    public void setZOVTYP(String zOVTYP) {
        ZOVTYP = zOVTYP;
    }
    public String getZREASON() {
        return ZREASON;
    }
    public void setZREASON(String zREASON) {
        ZREASON = zREASON;
    }
    public String getZRCODE() {
        return ZRCODE;
    }
    public void setZRCODE(String zRCODE) {
        ZRCODE = zRCODE;
    }
    public String getPERNR_D() {
        return PERNR_D;
    }
    public void setPERNR_D(String pERNR_D) {
        PERNR_D = pERNR_D;
    }
    
}