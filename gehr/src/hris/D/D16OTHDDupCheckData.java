package hris.D;

/**
 * D16OTHDDupCheckData.java
 *  �ʰ��ٹ��� �ް� ��û�� �ߺ� üũ�� ���� ZHRA022T ������ ��ƿ��� ������ ����
 *   [���� RFC] : ZHRW_RFC_OTHD_DUP_CHECK
 *
 * @author ��α�
 * @version 1.0, 2003/10/17
 */
public class D16OTHDDupCheckData extends com.sns.jdf.EntityData {
    public String AINF_SEQN;    //�������� �Ϸù�ȣ
    public String BEGDA    ;    //��û��
    public String WORK_DATE;    //�ʰ��ٹ���(upmu_type 17)
    public String BEGUZ    ;    //���۽ð�
    public String ENDUZ    ;    //����ð�
    public String APPR_STAT;    //���λ���

    public void setAINF_SEQN(String value){  	    this.AINF_SEQN = value;	}
    public String getAINF_SEQN(){ 	        			return AINF_SEQN;				}
    public void setBEGDA(String value)			{  	    this.BEGDA = value;	}
    public String getBEGDA(){ 	        				return BEGDA;				}
    public void setWORK_DATE(String value)	{  	    this.WORK_DATE = value;	}
    public String getWORK_DATE(){ 	        		return WORK_DATE;				}
    public void setBEGUZ(String value)			{  	    this.BEGUZ = value;	}
    public String getBEGUZ(){ 	        				return BEGUZ;				}
    public void setENDUZ(String value)		{  	    this.ENDUZ = value;	}
    public String getENDUZ(){ 	        				return ENDUZ;				}
    public void setAPPR_STAT(String value){  	    this.APPR_STAT = value;	}
    public String getAPPR_STAT(){ 	        			return APPR_STAT;				}

}
