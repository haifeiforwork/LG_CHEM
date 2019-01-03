/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 복리후생                                                    */
/*   Program Name : 부서별 복리후생 현황                                        */
/*   Program ID   : F51DeptWelfareData                                          */
/*   Description  : 부서별 복리후생 현황 조회를 위한 DATA 파일                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       : 2007-10-09 zhouguangwen  global e-hr update                */
/*                                                                              */
/********************************************************************************/

package hris.F.Global;

/**
 * F51DeptWelfareData
 *  부서별 복리후생 현황 내용을 담는 데이터
 *
 * @author zhouguangwen
 * @version 2.0,
 */
public class F51DeptWelfareData extends com.sns.jdf.EntityData {

	public String   PBTXT;        //Personnel Area Text
	public String   PERNR;        //Personnel number
	public String   ENAME;        //Formatted Name of Employee or Applicant
	public String   ORGTX;        //Short Text of Organizational Unit
	public String   JIKKT;        //Promotion text
	public String   JIKWT;        //Position text
	public String   LEVAU;        //ZLEVAU
	public String   DAT01;        //Date Print Change
	public String   CELTY;        //Celebration Code
	public String   CELTX;        //Celty Code Text
	public String   FAMY_CODE;    //Family Detail Type
	public String   FAMY_TEXT;    //Family Code Text
	public String   FNAME;        //OBJECT NAME
	public String   PAYM_AMNT;    //Payment Amount
	public String   APVDT;        //Date Print Change
	public String   REFU_AMNT;    //Refund Amount
	public String   WAERS;        //Currency Key



//    public String STEXT;        //부서이름
//    public String KNAME;        //한글이름
//    public String TITEL;        //직위
//    public String GUBUN;        //업무구분
//    public String DESCRIPTION;  //신청내역
//    public String RELA_CODE;    //대상구분
//    public String EREL_NAME;    //대상자성명
//    public String PAID_AMNT;    //지원액
//    public String APPL_DATE;    //신청일자
//    public String APPR_DATE;    //승인일
}
