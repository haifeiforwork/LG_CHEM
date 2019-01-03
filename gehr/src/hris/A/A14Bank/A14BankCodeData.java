package	hris.A.A14Bank;

/**
 * A14BankCodeData.java
 * 은행계좌 코드 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_P_BANK_CODE
 * 
 * @author 김도신    
 * @version 1.0, 2002/01/07
 */
public class A14BankCodeData extends com.sns.jdf.EntityData {
    public String MANDT    ;			// 클라이언트
    public String SPRSL    ;			// 언어키
    public String BUKRS    ;      // 회사코드
    public String UPMU_FLAG;      // 업무구분 그룹 지시자
    public String UPMU_TYPE;			// 업무구분
    public String GRUP_NUMB;			// 사업장
    public String BANK_CODE;			// 은행구분코드
    public String BANK_NAME;			// 이체은행명
    public String BEGDA    ;			// 시작일
    public String ENDDA    ;			// 종료일

	
	  public String ZBANKL ;
	  public String ZBANKA ;
	  public String ZBANKS ;

	    public String getSPRSL() {
		return SPRSL;
	}

	public void setSPRSL(String sPRSL) {
		SPRSL = sPRSL;
	}

	public String getBUKRS() {
		return BUKRS;
	}

	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}

	public String getUPMU_FLAG() {
		return UPMU_FLAG;
	}

	public void setUPMU_FLAG(String uPMU_FLAG) {
		UPMU_FLAG = uPMU_FLAG;
	}

	public String getUPMU_TYPE() {
		return UPMU_TYPE;
	}

	public void setUPMU_TYPE(String uPMU_TYPE) {
		UPMU_TYPE = uPMU_TYPE;
	}

	public String getGRUP_NUMB() {
		return GRUP_NUMB;
	}

	public void setGRUP_NUMB(String gRUP_NUMB) {
		GRUP_NUMB = gRUP_NUMB;
	}

	public String getZBANKL() {
		return ZBANKL;
	}

	public void setZBANKL(String zBANKL) {
		ZBANKL = zBANKL;
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

	    public void setMANDT(String MANDT) {
	        this.MANDT = MANDT;
	    }

	    public String getMANDT() {
	        return MANDT;
	    }

	    public void setBEGDA(String BEGDA) {
	        this.MANDT = BEGDA;
	    }

	    public String getBEGDA() {
	        return BEGDA;
	    }
	    public void setENDDA(String ENDDA) {
	        this.ENDDA = ENDDA;
	    }

	    public String getENDDA() {
	        return ENDDA;
	    }
}










