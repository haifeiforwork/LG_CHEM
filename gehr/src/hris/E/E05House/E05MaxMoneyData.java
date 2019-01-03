package hris.E.E05House;

/**
 * E05MaxMoneyData.java
 *  주택융자 최대한도금액
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 * @see hris.E.E05House.E05LoanMoneyData.java
 */
public class E05MaxMoneyData extends com.sns.jdf.EntityData
{
    public String LOAN_CODE;    //주택융자코드
    public String LOAN_MONY;    //Max Money
	public String getLOAN_CODE() {
		return LOAN_CODE;
	}
	public void setLOAN_CODE(String lOAN_CODE) {
		LOAN_CODE = lOAN_CODE;
	}
	public String getLOAN_MONY() {
		return LOAN_MONY;
	}
	public void setLOAN_MONY(String lOAN_MONY) {
		LOAN_MONY = lOAN_MONY;
	}
}
