package	hris.A;

import com.sns.jdf.util.WebUtil;
import hris.common.util.AppUtil;
import org.apache.commons.lang.StringUtils;

/**
 * A04FamilyDetailData.java
 *  °¡Á·»çÇ× Á¤º¸¸¦ ´ã¾Æ¿À´Â µ¥ÀÌÅÍ
 *   [°ü·Ã RFC] : ZHRA_RFC_FAMILY
 * 
 * @author ±èµµ½Å    
 * @version 1.0, 2001/12/17
 * 2018/01/05 rdcamel [CSR ID:3569665] 2017³â ¿¬¸»Á¤»ê À¥È­¸é ¼öÁ¤ ¿äÃ»ÀÇ °Ç
 */
public class A04FamilyDetailData extends com.sns.jdf.EntityData {

    public String PERNR ;   // »ç¹ø

    public String SUBTY ;   // subtype
    public String STEXT ;   // °ü°è
    public String OBJPS ;   // ¿ÀºêÁ§Æ®½Äº°
    public String LNMHG ;   // ¼º¾¾
    public String FNMHG ;   // ÀÌ¸§
    public String REGNO ;   // ÁÖ¹Îµî·Ï¹øÈ£
    public String FGBDT ;   // »ý³â¿ùÀÏ
    public String FASAR ;   // ÇÐ·ÂÄÚµå
    public String STEXT1;   // ÇÐ·Â
    public String FASIN ;   // ±³À°±â°ü
    public String FAJOB ;   // Á÷¾÷
    public String KDSVH ;   // °ü°èÄÚµå
    public String ATEXT ;   // °ü°è¸í
    public String FASEX ;   // ¼ºº°
    public String FGBOT ;   // Ãâ»ýÁö
    public String FGBLD ;   // Ãâ»ý±¹ÄÚµå
    public String LANDX ;   // Ãâ»ý±¹¸í
    public String FANAT ;   // ±¹ÀûÄÚµå
    public String NATIO ;   // ±¹Àû¸í
    public String DPTID ;   // ºÎ¾ç°¡Á·¿©ºÎ
    public String HNDID ;   // Àå¾Ö¿©ºÎ
    public String LIVID ;   // µ¿°Å¿©ºÎ
    public String HELID ;   // ÀÇ·áº¸Çè¿©ºÎ
    public String FAMID ;   // °¡Á·¼ö´ç¿©ºÎ
    public String CHDID ;   // ÀÚ³àº¸È£ºñ¿ëÀ» À§ÇÑ ¸éÁ¦Áö½ÃÀÚ
    public String BALID ;   // ±âÃÊ ¼ö±ÞÀÚ ºÎ¾ç°¡Á· Áö½ÃÀÚ
    public String KDBSL;   // [CSR ID:3569665] ÀÚ³àÀ¯Çü Ã¹Â°, µÑÂ°, ¼ÂÂ° ÀÌ»ó
    public String KDBSL_TEXT;   // [CSR ID:3569665] ÀÚ³àÀ¯Çü Ã¹Â°, µÑÂ°, ¼ÂÂ° ÀÌ»ó_TEXT

    /* ÇØ¿Ü */
    public String FAMSA ;
    public String BEGDA ;
    public String ENDDA ;
    public String FAVOR ;
    public String FANAM ;
    public String ENAME ;
    public String FGBNA ;
    public String ERNAM ;
    public String OCCUP ;
    public String OCCTX ;
    public String PSTAT ;
    public String PSTXT ;
    public String CNNAM ;
    public String IDNUM ;
    public String FINIT ;
    public String GBDEP ;
    public String FAMST ;
    public String ADDAT ;
    public String SAMER ;
    public String FANA2 ;
    public String FANA3 ;

    public String ERNAM2 ;
    public String FKNZN ;
    public String ANREX ;
    public String GBJHR ;
    public String GBMON ;
    public String GBTAG ;
    public String NHIFA ;
    public String NHIST ;
    public String NHISR ;
    public String ENTDT ;    //ôÕÊ¥ÖõÊ«??ÛÉÌºò¢ìíÑ¢îÜí®Ó«£ºENTDT 2011-08-12 liukuo   @v1.1 [C20110728_35671]
    public String TELNR;		  //ôÕÊ¥familyîÜ??ãáãÓ--?Í§ïÃùë       2012-07-11 lixinxin @v1.2 [C20120710_44214]
    //  public String NUMMAIL;  //ôÕÊ¥familyîÜ??ãáãÓ--?ßÕ NUMMAIL         2012-07-11 lixinxin @v1.2 [C20120710_44214]
    public String FAMIADDR ;    //Family ôð???ãáãÓ ?êúßÕ?à÷?ËÜñ¬ò¢ò£   2012-07-17 lixinxin@v1.3 [C20120716_47583 ]
    private String allnam;


    public String getBDay() {
        if(StringUtils.isNotEmpty(FGBDT) && FGBDT.length() >= 10)
            return FGBDT.substring(0, 4) + " ³â " + FGBDT.substring(5, 7) + " ¿ù " + FGBDT.substring(8, 10) + " ÀÏ";
        return "";
    }
    public String getSUBTY() {
        return SUBTY;
    }

    public void setSUBTY(String SUBTY) {
        this.SUBTY = SUBTY;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getOBJPS() {
        return OBJPS;
    }

    public void setOBJPS(String OBJPS) {
        this.OBJPS = OBJPS;
    }

    public String getLNMHG() {
        return LNMHG;
    }

    public void setLNMHG(String LNMHG) {
        this.LNMHG = LNMHG;
    }

    public String getFNMHG() {
        return FNMHG;
    }

    public void setFNMHG(String FNMHG) {
        this.FNMHG = FNMHG;
    }

    public String getREGNO() {
        return REGNO;
    }

    public void setREGNO(String REGNO) {
        this.REGNO = REGNO;
    }

    public String getFGBDT() {
        return WebUtil.printDate(FGBDT);
    }

    public void setFGBDT(String FGBDT) {
        this.FGBDT = FGBDT;
    }

    public String getFASAR() {
        return FASAR;
    }

    public void setFASAR(String FASAR) {
        this.FASAR = FASAR;
    }

    public String getSTEXT1() {
        return STEXT1;
    }

    public void setSTEXT1(String STEXT1) {
        this.STEXT1 = STEXT1;
    }

    public String getFASIN() {
        return FASIN;
    }

    public void setFASIN(String FASIN) {
        this.FASIN = FASIN;
    }

    public String getFAJOB() {
        return FAJOB;
    }

    public void setFAJOB(String FAJOB) {
        this.FAJOB = FAJOB;
    }

    public String getKDSVH() {
        return KDSVH;
    }

    public void setKDSVH(String KDSVH) {
        this.KDSVH = KDSVH;
    }

    public String getATEXT() {
        return ATEXT;
    }

    public void setATEXT(String ATEXT) {
        this.ATEXT = ATEXT;
    }

    public String getFASEX() {
        return FASEX;
    }

    public void setFASEX(String FASEX) {
        this.FASEX = FASEX;
    }

    public String getFGBOT() {
        return FGBOT;
    }

    public void setFGBOT(String FGBOT) {
        this.FGBOT = FGBOT;
    }

    public String getFGBLD() {
        return FGBLD;
    }

    public void setFGBLD(String FGBLD) {
        this.FGBLD = FGBLD;
    }

    public String getLANDX() {
        return LANDX;
    }

    public void setLANDX(String LANDX) {
        this.LANDX = LANDX;
    }

    public String getFANAT() {
        return FANAT;
    }

    public void setFANAT(String FANAT) {
        this.FANAT = FANAT;
    }

    public String getNATIO() {
        return NATIO;
    }

    public void setNATIO(String NATIO) {
        this.NATIO = NATIO;
    }

    public String getDPTID() {
        return DPTID;
    }

    public void setDPTID(String DPTID) {
        this.DPTID = DPTID;
    }

    public String getHNDID() {
        return HNDID;
    }

    public void setHNDID(String HNDID) {
        this.HNDID = HNDID;
    }

    public String getLIVID() {
        return LIVID;
    }

    public void setLIVID(String LIVID) {
        this.LIVID = LIVID;
    }

    public String getHELID() {
        return HELID;
    }

    public void setHELID(String HELID) {
        this.HELID = HELID;
    }

    public String getFAMID() {
        return FAMID;
    }

    public void setFAMID(String FAMID) {
        this.FAMID = FAMID;
    }

    public String getCHDID() {
        return CHDID;
    }

    public void setCHDID(String CHDID) {
        this.CHDID = CHDID;
    }

    public String getBALID() {
        return BALID;
    }

    public void setBALID(String BALID) {
        this.BALID = BALID;
    }

    public String getFAMSA() {
        return FAMSA;
    }

    public void setFAMSA(String FAMSA) {
        this.FAMSA = FAMSA;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getENDDA() {
        return ENDDA;
    }

    public void setENDDA(String ENDDA) {
        this.ENDDA = ENDDA;
    }

    public String getFAVOR() {
        return FAVOR;
    }

    public void setFAVOR(String FAVOR) {
        this.FAVOR = FAVOR;
    }

    public String getFANAM() {
        return FANAM;
    }

    public void setFANAM(String FANAM) {
        this.FANAM = FANAM;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getFGBNA() {
        return FGBNA;
    }

    public void setFGBNA(String FGBNA) {
        this.FGBNA = FGBNA;
    }

    public String getERNAM() {
        return ERNAM;
    }

    public void setERNAM(String ERNAM) {
        this.ERNAM = ERNAM;
    }

    public String getOCCUP() {
        return OCCUP;
    }

    public void setOCCUP(String OCCUP) {
        this.OCCUP = OCCUP;
    }

    public String getOCCTX() {
        return OCCTX;
    }

    public void setOCCTX(String OCCTX) {
        this.OCCTX = OCCTX;
    }

    public String getPSTAT() {
        return PSTAT;
    }

    public void setPSTAT(String PSTAT) {
        this.PSTAT = PSTAT;
    }

    public String getPSTXT() {
        return PSTXT;
    }

    public void setPSTXT(String PSTXT) {
        this.PSTXT = PSTXT;
    }

    public String getCNNAM() {
        return CNNAM;
    }

    public void setCNNAM(String CNNAM) {
        this.CNNAM = CNNAM;
    }

    public String getIDNUM() {
        return IDNUM;
    }

    public void setIDNUM(String IDNUM) {
        this.IDNUM = IDNUM;
    }

    public String getFINIT() {
        return FINIT;
    }

    public void setFINIT(String FINIT) {
        this.FINIT = FINIT;
    }

    public String getGBDEP() {
        return GBDEP;
    }

    public void setGBDEP(String GBDEP) {
        this.GBDEP = GBDEP;
    }

    public String getFAMST() {
        return FAMST;
    }

    public void setFAMST(String FAMST) {
        this.FAMST = FAMST;
    }

    public String getADDAT() {
        return ADDAT;
    }

    public void setADDAT(String ADDAT) {
        this.ADDAT = ADDAT;
    }

    public String getSAMER() {
        return SAMER;
    }

    public void setSAMER(String SAMER) {
        this.SAMER = SAMER;
    }

    public String getFANA2() {
        return FANA2;
    }

    public void setFANA2(String FANA2) {
        this.FANA2 = FANA2;
    }

    public String getFANA3() {
        return FANA3;
    }

    public void setFANA3(String FANA3) {
        this.FANA3 = FANA3;
    }

    public String getERNAM2() {
        return ERNAM2;
    }

    public void setERNAM2(String ERNAM2) {
        this.ERNAM2 = ERNAM2;
    }

    public String getFKNZN() {
        return FKNZN;
    }

    public void setFKNZN(String FKNZN) {
        this.FKNZN = FKNZN;
    }

    public String getANREX() {
        return ANREX;
    }

    public void setANREX(String ANREX) {
        this.ANREX = ANREX;
    }

    public String getGBJHR() {
        return GBJHR;
    }

    public void setGBJHR(String GBJHR) {
        this.GBJHR = GBJHR;
    }

    public String getGBMON() {
        return GBMON;
    }

    public void setGBMON(String GBMON) {
        this.GBMON = GBMON;
    }

    public String getGBTAG() {
        return GBTAG;
    }

    public void setGBTAG(String GBTAG) {
        this.GBTAG = GBTAG;
    }

    public String getNHIFA() {
        return NHIFA;
    }

    public void setNHIFA(String NHIFA) {
        this.NHIFA = NHIFA;
    }

    public String getNHIST() {
        return NHIST;
    }

    public void setNHIST(String NHIST) {
        this.NHIST = NHIST;
    }

    public String getNHISR() {
        return NHISR;
    }

    public void setNHISR(String NHISR) {
        this.NHISR = NHISR;
    }

    public String getENTDT() {
        return "0000-00-00".equals(ENTDT)?"": WebUtil.printDate(ENTDT);
    }

    public void setENTDT(String ENTDT) {
        this.ENTDT = ENTDT;
    }

    public String getTELNR() {
        return TELNR;
    }

    public void setTELNR(String TELNR) {
        this.TELNR = TELNR;
    }

    public String getFAMIADDR() {
        return FAMIADDR;
    }

    public void setFAMIADDR(String FAMIADDR) {
        this.FAMIADDR = FAMIADDR;
    }

    public String getALLNAM() {
        return allnam;
    }

    public String getALLNAM_EU() {
        return (AppUtil.checkEnglish(FAVOR)&&AppUtil.checkEnglish(FANAM))?(FAVOR + " " + FANAM):(FANAM + " " + FAVOR);
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }
    
    public String getKDBSL() {
        return KDBSL;
    }
    
    public String getKDBSL_TEXT() {
        return KDBSL_TEXT;
    }
}
