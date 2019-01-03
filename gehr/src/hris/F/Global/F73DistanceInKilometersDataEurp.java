/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Organization & Staffing                                              */
/*   2Depth Name  : Headcount                                                    */
/*   Program Name : Org.Unit/Distance                                    */
/*   Program ID   : F73DistanceInKilometersDataEurp                               */
/*   Description  : 부서별 거주지 출/퇴근거리 정보 조회를 위한 타이틀 DATA 파일       */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-08-02 yji                                           */
/********************************************************************************/

package hris.F.Global;

/**
 * F73DistanceInKilometersDataEurp 부서별 거주지 출/퇴근거리 현황을 담는 데이터[유럽용]
 *
 * @author yji
 * @version 1.0,
 */
public class F73DistanceInKilometersDataEurp extends com.sns.jdf.EntityData {

	public String ORGEH;
	public String ORGTX;
	public String EMPNR;
	public String DIS01;
	public String DIS02;
	public String DIS03;
	public String DIS04;
	public String TOTAL;
	public String PCT01;
	public String PCT02;
	public String ZLEVEL;
}