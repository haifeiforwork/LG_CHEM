package	hris.A.A13Address;

/**
 * A13AddressNationData.java
 * 국가 코드, 명을 담아오는 데이터
 *   [관련 RFC] : ZHRE_RFC_P_ADDRESS_NATION
 * 
 * @author 김도신    
 * @version 1.0, 2001/12/26
 */
public class A13AddressNationData extends com.sns.jdf.EntityData {

    public String LAND1;   // 국가코드
    public String LANDX;   // 국가명       - BIRTH 사용
    public String NATIO;  //	NATIO	CHAR	15	0	국적
    public String CNATIO; //	NATIO50	CHAR	50	0	국적 (최대 50문자)    - 국가에서 사용

    public String getLAND1() {
        return LAND1;
    }

    public void setLAND1(String LAND1) {
        this.LAND1 = LAND1;
    }

    public String getLANDX() {
        return LANDX;
    }

    public void setLANDX(String LANDX) {
        this.LANDX = LANDX;
    }

    public String getNATIO() {
        return NATIO;
    }

    public void setNATIO(String NATIO) {
        this.NATIO = NATIO;
    }

    public String getCNATIO() {
        return CNATIO;
    }

    public void setCNATIO(String CNATIO) {
        this.CNATIO = CNATIO;
    }
}
