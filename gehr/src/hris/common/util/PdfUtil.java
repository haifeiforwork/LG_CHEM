/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  : 공통                                                        */
/*   Program Name : 결재정보                                                    */
/*   Program ID   : PdfUtil.JA                                                  */
/*   Description  : 연말정산PDF UPLOAD용 공통 파일  Class                   */
/*   Note         :                                                             */
/*   Creation     : 2013-07-13  손혜영                                          */
/*   Update       : CSR ID:C20140106_63914 2013-11-26  2013연말정산수정분반영 LSA                */
/*                      - 연금저축 기존 태그 삭제, 신규 태그 추가 및 이에 따른 코드 변경(E101Y/M -> E102Y/M) */
/*						 -  퇴직연금 기존 태그 삭제, 신규 태그 추가 및 이에 따른 코드 변경(F101Y/M -> F102Y/M) */
/*                      - 목돈 안드는 전세 이자상환액 J401Y J401M 연간합계 J401M 추가                                                       */
/*					     - 장기주식형저축 M101Y 연간합계 M101M 2013서비스 종료 				*/
/*						2014/12/03 @2014연말정산 장기집합투자증권저축 추가													                                */
/********************************************************************************/

package hris.common.util;

public final class PdfUtil{
/*	//private static String serverURL = "/sorc001/ehr/ehr.ear/ehrWeb.war/upload/";	//서버경로
	private static String serverURL = "";	//로컬에서는 여기로
	private static String tempURL = "/temp/";	//PDF 파일 저장경로(temp) : 초기 파일업로드시 저장되는 경로
	private static String realURL = "D:/FILE_UPLOAD/ESS"; //PDF 파일 저장경로(real) : 데이터 추출 후 최종 파일 저장되는 경로
    //public static String cacertsURL = "/sorc001/ehr/ehr.ear/ehrWeb.war/web/D/D11TaxAdjust/Init";	//인증서경로
    public static String cacertsURL = "/LGCHEM_EHR/workspace/ehr1/WebContent/web/D/D11TaxAdjust/Init";	//로컬에서는 여기로 인증서경로
*/
	
	
	//private static String serverURL = "/sorc001/gehr/gehr.ear/gehrWeb.war/upload/";	//서버경로
	private static String serverURL = "/LGCHEM_EHR/workspace/sorc001/ehr/ehr.ear/ehrweb.war/upload/";	//로컬에서는 여기로
	private static String tempURL = "/temp/";	//PDF 파일 저장경로(temp) : 초기 파일업로드시 저장되는 경로
	private static String realURL = "/";	//PDF 파일 저장경로(real) : 데이터 추출 후 최종 파일 저장되는 경로
    //public static String cacertsURL = "/sorc001/gehr/gehr.ear/gehrWeb.war/web/D/D11TaxAdjust/Init";	//인증서경로
    public static String cacertsURL = "/LGCHEM_EHR/workspace/gehr/WebContent/web/D/D11TaxAdjust/Init";	//로컬에서는 여기로 인증서경로

    
    //검증 결과값
    public static int validatorSuc = 0;	//PDF 파일 인증 결과 정상
    public static int parseSuc = 1;	//XML 파싱 성공

    public static String[] tableNmArr = {"T_INSU","T_MEDI", "T_EDUC", "T_SPEC", "T_DONA", "T_PENS", "T_CRED"};

    //파일경로가져오기
    public static String getURL(String type, String targetYear, String empNo){
    	String url = "";
    	if("temp".equals(type)){
    		url = targetYear+"/"+empNo+tempURL;
    	} else if("real".equals(type)){
    		//url = realURL + "/" + targetYear+"/"+empNo;
    		url = targetYear+"/"+empNo+realURL;
    	}
    	return serverURL+url;
    }

    //진본성검증메세지
    public static String getFileMsg(int result){
    	String msg = "";
    	switch(result){
			case 101:
				msg = "진본성 검증 초기화에 문제가 있습니다.";
				break;
			case 201:
				msg = "PDF문서가 아닙니다.";
				break;
			case 202:
				msg = "타임스탬프가 발급되지 않은 문서 입니다.";
				break;
			case 203:
				msg = "변조된 문서 입니다.";
				break;
			case 204:
				msg = "비밀번호가 틀립니다.";
				break;
			case 205:
				msg = "손상된 문서입니다..";
				break;
			case 301:
				msg = "토큰정보 추출에 문제가 있습니다.";
				break;
			case 302:
				msg = "미지원 토큰정보 입니다.";
				break;
			case 401:
				msg = "CRL 목록의 시간이 지났거나 파기 되었습니다.";
				break;
			default:
				msg = "알수없는 에러입니다.";
				break;
		}
    	return msg;
    }

    //PDF Parse 메세지
    public static String getParseMsg(int result){
    	String msg = "";
    	switch(result){
			case 0:
				msg = "연말정산간소화 표준 전자문서가 아닙니다.";
				break;
			case -1:
				msg = "비밀번호가 틀립니다.";
				break;
			case -2:
				msg = "PDF문서가 아니거나 손상된 문서입니다.";
				break;
			default:
				msg = "데이터 추출에 실패하였습니다.";
				break;
		}
		return msg;
    }
}
