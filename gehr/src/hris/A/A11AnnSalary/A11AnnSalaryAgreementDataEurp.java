package hris.A.A11AnnSalary;

/**
*   1Depth Name  : Personal HR Info
*   2Depth Name  : Personal Info
*   Program Name : Annual Salary Agreement
*
 * A11AnnSalaryAgreementDataEurp.java
 * 연봉조회 데이타 [관련 RFC] : ZHR_RFC_ANNUAL_SALARY
 * [독일]
 *
 * @author yji
 * @version 1.0, 2010/07/20
 */
public class A11AnnSalaryAgreementDataEurp extends com.sns.jdf.EntityData {


	public String ZYEAR;  //Year

	public String PERNR;

	public String BUKRS;

	public String ENAME;

	public String ORGEH;

	public String ORGTX; //Org.Unit

	public String BEGDA; //Date

	public String JIKCT;  //Level

	public String ANSAL; //Annual Salary

	public String TTOUT; //Title of Level

	public String NAME1;

	public String PREVIOUS; //Agreement

	public String PRESENT; //Agreement

	public String INCREASE; //Agreement

	public String ES_RETURN;

	public String E_YEAR; //연봉협의서 연도

	public String E_DEAR; //해당사원이름


}