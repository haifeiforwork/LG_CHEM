/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  : ����                                                        */
/*   Program Name : ��������                                                    */
/*   Program ID   : PdfUtil.JA                                                  */
/*   Description  : ��������PDF UPLOAD�� ���� ����  Class                   */
/*   Note         :                                                             */
/*   Creation     : 2013-07-13  ������                                          */
/*   Update       : CSR ID:C20140106_63914 2013-11-26  2013������������йݿ� LSA                */
/*                      - �������� ���� �±� ����, �ű� �±� �߰� �� �̿� ���� �ڵ� ����(E101Y/M -> E102Y/M) */
/*						 -  �������� ���� �±� ����, �ű� �±� �߰� �� �̿� ���� �ڵ� ����(F101Y/M -> F102Y/M) */
/*                      - �� �ȵ�� ���� ���ڻ�ȯ�� J401Y J401M �����հ� J401M �߰�                                                       */
/*					     - ����ֽ������� M101Y �����հ� M101M 2013���� ���� 				*/
/*						2014/12/03 @2014�������� ������������������� �߰�													                                */
/********************************************************************************/

package hris.common.util;

public final class PdfUtil{
/*	//private static String serverURL = "/sorc001/ehr/ehr.ear/ehrWeb.war/upload/";	//�������
	private static String serverURL = "";	//���ÿ����� �����
	private static String tempURL = "/temp/";	//PDF ���� ������(temp) : �ʱ� ���Ͼ��ε�� ����Ǵ� ���
	private static String realURL = "D:/FILE_UPLOAD/ESS"; //PDF ���� ������(real) : ������ ���� �� ���� ���� ����Ǵ� ���
    //public static String cacertsURL = "/sorc001/ehr/ehr.ear/ehrWeb.war/web/D/D11TaxAdjust/Init";	//���������
    public static String cacertsURL = "/LGCHEM_EHR/workspace/ehr1/WebContent/web/D/D11TaxAdjust/Init";	//���ÿ����� ����� ���������
*/
	
	
	//private static String serverURL = "/sorc001/gehr/gehr.ear/gehrWeb.war/upload/";	//�������
	private static String serverURL = "/LGCHEM_EHR/workspace/sorc001/ehr/ehr.ear/ehrweb.war/upload/";	//���ÿ����� �����
	private static String tempURL = "/temp/";	//PDF ���� ������(temp) : �ʱ� ���Ͼ��ε�� ����Ǵ� ���
	private static String realURL = "/";	//PDF ���� ������(real) : ������ ���� �� ���� ���� ����Ǵ� ���
    //public static String cacertsURL = "/sorc001/gehr/gehr.ear/gehrWeb.war/web/D/D11TaxAdjust/Init";	//���������
    public static String cacertsURL = "/LGCHEM_EHR/workspace/gehr/WebContent/web/D/D11TaxAdjust/Init";	//���ÿ����� ����� ���������

    
    //���� �����
    public static int validatorSuc = 0;	//PDF ���� ���� ��� ����
    public static int parseSuc = 1;	//XML �Ľ� ����

    public static String[] tableNmArr = {"T_INSU","T_MEDI", "T_EDUC", "T_SPEC", "T_DONA", "T_PENS", "T_CRED"};

    //���ϰ�ΰ�������
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

    //�����������޼���
    public static String getFileMsg(int result){
    	String msg = "";
    	switch(result){
			case 101:
				msg = "������ ���� �ʱ�ȭ�� ������ �ֽ��ϴ�.";
				break;
			case 201:
				msg = "PDF������ �ƴմϴ�.";
				break;
			case 202:
				msg = "Ÿ�ӽ������� �߱޵��� ���� ���� �Դϴ�.";
				break;
			case 203:
				msg = "������ ���� �Դϴ�.";
				break;
			case 204:
				msg = "��й�ȣ�� Ʋ���ϴ�.";
				break;
			case 205:
				msg = "�ջ�� �����Դϴ�..";
				break;
			case 301:
				msg = "��ū���� ���⿡ ������ �ֽ��ϴ�.";
				break;
			case 302:
				msg = "������ ��ū���� �Դϴ�.";
				break;
			case 401:
				msg = "CRL ����� �ð��� �����ų� �ı� �Ǿ����ϴ�.";
				break;
			default:
				msg = "�˼����� �����Դϴ�.";
				break;
		}
    	return msg;
    }

    //PDF Parse �޼���
    public static String getParseMsg(int result){
    	String msg = "";
    	switch(result){
			case 0:
				msg = "�������갣��ȭ ǥ�� ���ڹ����� �ƴմϴ�.";
				break;
			case -1:
				msg = "��й�ȣ�� Ʋ���ϴ�.";
				break;
			case -2:
				msg = "PDF������ �ƴϰų� �ջ�� �����Դϴ�.";
				break;
			default:
				msg = "������ ���⿡ �����Ͽ����ϴ�.";
				break;
		}
		return msg;
    }
}
