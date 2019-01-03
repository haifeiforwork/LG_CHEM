/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : ��������                                           */
/*   Program Name : �������� ���� ���� ���� �� ������ �Է¶� ��/��  ��ȸ                              */
/*   Program ID   : E03RetireMBegdaRFC                                         */
/*   Description  : �������� ���� ���� ���� �� ������ �Է¶� ��/��  ��ȸ                      */
/*   Note         : [���� RFC] : ZSOLRP_GET_SETTING                                                  */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire.rfc;

import hris.E.E03Retire.E03RetireMBegdaData;


import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;


public class E03RetireMBegdaRFC extends SAPWrap {
	
	private String functionName = "ZSOLRP_GET_SETTING";
	
	public String  getRetireMBegdaInfo(String i_upmu) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            String nowdate = DateTime.getShortDateString();

            setInput(function, i_upmu);
            excute(mConnection, function);
           
            E03RetireMBegdaData data = (E03RetireMBegdaData)getOutput(function, (new E03RetireMBegdaData()));
            
            String E_ZCHECK = data.E_ZCHECK;
                       
            if(E_ZCHECK == null) E_ZCHECK = "";	//E_ZCHECK �� X �̸� �����ڰ� �������� �Է��� �� �ִ� input�� ȭ�鿡 ���
            return E_ZCHECK;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.getMessage());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
	
	/*
	 * ��¥ ���
	 */
	private String getDateFormat(String date1, String format){
		try{
			java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat ("yyyy-MM-dd", java.util.Locale.KOREA);
			java.util.Date date = null;
	
			date = formatter.parse(date1);
			
			formatter = new java.text.SimpleDateFormat (format, java.util.Locale.KOREA);
        
			return formatter.format(date);
		}catch(Exception e){
			return "";
		}
	}

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_upmu) throws GeneralException {
        String fieldName1 = "I_UPMU";
        String fieldName2 = "I_ZOBJEC";

        setField( function, fieldName1, i_upmu );
        setField( function, fieldName2, "ESS_BEGDA" );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
    private Object getOutput(JCO.Function function, E03RetireMBegdaData data) throws GeneralException {
    	return getFields(data, function);
    }

}
