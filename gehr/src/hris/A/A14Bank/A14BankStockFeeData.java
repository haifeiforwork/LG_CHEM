/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 급여계좌정보                                                */
/*   Program Name : 급여계좌 신청                                               */
/*   Program ID   : A14BankStockFeeData                                         */
/*   Description  : 급여계좌 신청 정보를 담아오는 데이터                        */
/*   Note         : [관련 RFC] : ZHRH_RFC_BANK_STOCK_FEE_LIST                   */
/*   Creation     : 2002-01-08  김도신                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package hris.A.A14Bank;

public class A14BankStockFeeData extends com.sns.jdf.EntityData {
/* 국내*/
	public String AINF_SEQN;  // 결재정보 일련번호
	public String PERNR    ;  // 사원번호
	public String BEGDA    ;  // 신청일
	public String BANK_FLAG;  // 구분(은행/증권)
	public String BANK_CODE;  // 은행구분코드
	public String BANK_NAME;  // 이체은행명
	public String BANKN    ;  // 은행계좌번호
	public String ZPERNR   ;  // 은행계좌번호
	public String AEDTM ;
	public String UNAME ;
    

/*해외*/
	  public String BNKSA ;
	  public String ZBANKA ;
	  public String ZBANKS ;
	  public String ZBANKL ;
	  public String ZBANKN ;
	  public String ZBKREF ;
	  public String PERNR_D ;
	  public String ZUNAME ;
	  public String CERT_FLAG ;      
	  public String CERT_DATE ;  
	  public String STATE1;
	  public String BRANCH ;
	  //20151202 start
	  public String VORNA;//first name
	  public String NACHN;//last name
	  public String EMFTX;//full name
	  
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

	public String getZBANKA() {
		return ZBANKA;
	}

	public void setZBANKA(String zBANKA) {
		ZBANKA = zBANKA;
	}

	public String getZBANKS() {
		return ZBANKS;
	}

	public void setZBANKS(String zBANKS) {
		ZBANKS = zBANKS;
	}

	public String getZBANKL() {
		return ZBANKL;
	}

	public void setZBANKL(String zBANKL) {
		ZBANKL = zBANKL;
	}

	public String getZBANKN() {
		return ZBANKN;
	}

	public void setZBANKN(String zBANKN) {
		ZBANKN = zBANKN;
	}

	public String getZBKREF() {
		return ZBKREF;
	}

	public void setZBKREF(String zBKREF) {
		ZBKREF = zBKREF;
	}

	public String getPERNR_D() {
		return PERNR_D;
	}

	public void setPERNR_D(String pERNR_D) {
		PERNR_D = pERNR_D;
	}

	public String getZUNAME() {
		return ZUNAME;
	}

	public void setZUNAME(String zUNAME) {
		ZUNAME = zUNAME;
	}

	public String getCERT_FLAG() {
		return CERT_FLAG;
	}

	public void setCERT_FLAG(String cERT_FLAG) {
		CERT_FLAG = cERT_FLAG;
	}

	public String getCERT_DATE() {
		return CERT_DATE;
	}

	public void setCERT_DATE(String cERT_DATE) {
		CERT_DATE = cERT_DATE;
	}

	public String getSTATE1() {
		return STATE1;
	}

	public void setSTATE1(String sTATE1) {
		STATE1 = sTATE1;
	}

	public String getBRANCH() {
		return BRANCH;
	}

	public void setBRANCH(String bRANCH) {
		BRANCH = bRANCH;
	}

	public String getVORNA() {
		return VORNA;
	}

	public void setVORNA(String vORNA) {
		VORNA = vORNA;
	}

	public String getNACHN() {
		return NACHN;
	}

	public void setNACHN(String nACHN) {
		NACHN = nACHN;
	}

	public String getEMFTX() {
		return EMFTX;
	}

	public void setEMFTX(String eMFTX) {
		EMFTX = eMFTX;
	}

	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}

		public void setAINF_SEQN(String AINF_SEQN) {
	        this.AINF_SEQN = AINF_SEQN;
	    }

	    public String getAINF_SEQN() {
	        return AINF_SEQN;
	    }


	    public void setPERNR(String PERNR) {
	        this.PERNR = PERNR;
	    }

	    public String getPERNR() {
	        return PERNR;
	    }
	     
	    public void setBANK_CODE(String BANK_CODE) {
	        this.BANK_CODE = BANK_CODE;
	    }

	    public String getBANK_CODE() {
	        return BANK_CODE;
	    }

	    public void setBANK_NAME(String BANK_NAME) {
	        this.BANK_NAME = BANK_NAME;
	    }

	    public String getBANK_NAME() {
	        return BANK_NAME;
	    }

	    public String getBEGDA() {
	        return BEGDA;
	    }
	    public void setBANK_FLAG(String BANK_FLAG) {
	        this.BANK_FLAG = BANK_FLAG;
	    }

	    public String getBANK_FLAG() {
	        return BANK_FLAG;
	    }

	    public void setBANKN(String BANKN) {
	        this.BANKN = BANKN;
	    }

	    public String getBANKN() {
	        return BANKN;
	    }
	    public void setZPERNR(String ZPERNR) {
	        this.ZPERNR = ZPERNR;
	    }

	    public String getZPERNR() {
	        return ZPERNR;
	    }

	    public void setBNKSA(String BNKSA) {
	        this.BNKSA = BNKSA;
	    }

	    public String getBNKSA() {
	        return BNKSA;
	    }
}
