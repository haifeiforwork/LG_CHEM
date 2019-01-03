package	hris.A;

/**
 * A03AccountDetail1Data.java
 * ������� ��ȸ ������ ��ƿ��� ������
 *   [���� RFC] : ZHRH_RFC_BANK_STOCK_LIST
 * 
 * @author �赵��    
 * @version 1.0, 2002/01/07
 */
public class A03AccountDetail1Data extends com.sns.jdf.EntityData {
    public String AINF_SEQN;			// �������� �Ϸù�ȣ
    public String PERNR    ;			// �����ȣ
    public String BEGDA    ;      // ��û��
    public String BANK_FLAG;      // ����(����/����)
    public String BANK_CODE;			// ���౸���ڵ�
    public String BANK_NAME;			// ��ü�����
    public String BANKN    ;			// ������¹�ȣ

	  public String BNKSA ;
	  public String BNKTX ;
	  public String ZBANKL ;
	  public String ZBANKA ; //bank key
	  public String ZBANKN ; //bank Account
	  public String ZBKREF;  //bank Account
	  
	  //20151203 bankcard start
	  public String VORNA;//first name
	  public String NACHN;//last name
	  public String EMFTX;//full name
	  

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

	    public void setBNKSA(String BNKSA){  	    this.BNKSA = BNKSA;	}
	    public String getBNKSA(){ 	        			return BNKSA;				}

	    public void setBNKTX(String BNKTX){  	    this.BNKTX = BNKTX;	}
	    public String getBNKTX(){ 	        			return BNKTX;				}
	    
	    public void setZBANKL(String ZBANKL){  	    this.ZBANKL = ZBANKL;	}
	    public String getZBANKL(){ 	        			return ZBANKL;				}
	    
	    public void setZBANKA(String ZBANKA){ 	    this.ZBANKA = ZBANKA;	}
	    public String getZBANKA(){ 	        			return ZBANKA;				}
	    
	    public void setZBANKN(String ZBANKN){ 	    this.ZBANKN = ZBANKN;	}
	    public String getZBANKN(){ 	        			return ZBANKN;				}
	    
	    public void setZBKREF(String value){  	    this.ZBKREF = value;		}
	    public String getZBKREF(){ 	        			return ZBKREF;				}
	    
	    public void setVORNA(String value){  	    	this.VORNA = value;			}
	    public String getVORNA(){ 	        			return VORNA;				}
	    
	    public void setNACHN(String value){  	    	this.NACHN = value;			}
	    public String getNACHN(){ 	        			return NACHN;				}
	    
	    public void setEMFTX(String value){  	    	this.EMFTX = value;			}
	    public String getEMFTX(){ 	        			return EMFTX;				}

}










