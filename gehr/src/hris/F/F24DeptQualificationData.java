/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 자격 소지자 조회                                     */
/*   Program ID   : F24DeptQualificationData                                    */
/*   Description  : 부서별 자격 소지자 조회를 위한 DATA 파일                    */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-31 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F;

/**
 * F24DeptQualificationData
 *  부서별 자격 소지자 내용을 담는 데이터
 *
 * @author 유용원
 * @version 1.0,
 */
public class F24DeptQualificationData extends com.sns.jdf.EntityData {
	public String PERNR		 ;		//  사원 번호
	public String ORGEH      ;    //  조직 단위
	public String ORGTX      ;    //  소속명
	public String ENAME      ;    //  사원 또는 지원자의 포맷된 이름
	public String BUKRS      ;    //  회사 코드
	public String WERKS      ;    //  인사 영역
	public String NAME1      ;    //  인사 영역 텍스트
	public String BTRTL      ;    //  인사 하위 영역
	public String BTEXT      ;    //  인사 하위 영역 텍스트
	public String PERSG      ;    //  사원 그룹
	public String PGTXT      ;    //  사원 그룹 이름
	public String PERSK      ;    //  사원 하위 그룹
	public String PKTXT      ;    //  사원 하위 그룹 이름
	public String STELL      ;    //  직무
	public String STLTX      ;    //  직무명
	public String DAT01      ;    //  그룹입사일
	public String DAT02      ;    //  회사입사일
	public String DAT03      ;    //  현직위승진일
	public String DAT04      ;    //  근속기준일
	public String JIKWE      ;    //  직위
	public String JIKWT      ;    //  직위명
	public String JIKCH      ;    //  직급
	public String JIKCT      ;    //  직급명
	public String JIKKB      ;    //  직책
	public String JIKKT      ;    //  직책명
	public String MOLGA      ;    //  국가 그루핑
	public String PHONE_NUM  ;    //  담당자의 전화번호
	public String TRFGR      ;    //  호봉 그룹
	public String TRFST      ;    //  호봉 단계
	public String VGLST      ;    //  비교급여범위레벨
	public String SHORT      ;    //  오브젝트 약어
	public String BEGDA      ;    //  시작일
	public String ENDDA      ;    //  종료일
	public String LICNCD     ;    //  자격면허 코드
	public String LICNNM      ;    //  자격면허명
	public String OBNDAT      ;    //  	취득일
	public String LGRADE      ;    //  자격등급 코드
	public String LGRDNM      ;    //  자격등급명
	public String PBORGH      ;    //  발행기관
	public String LAW     ;    //  법정선임사유
	public String FLAG      ;    //  자격수당 여부
	public String ORGTX2      ;    //  선임부서명
	public String	ANNUL           ; //Level Years
	public String	EXDATE          ; //Date of expriy
	public String	LNUMBER         ; //License No.




}
