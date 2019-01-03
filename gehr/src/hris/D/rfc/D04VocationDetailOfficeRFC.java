/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �ް���������                                                		*/
/*   Program Name : �ް���������                                                		*/
/*   Program ID   : D04VocationDetailOfficeRFC.java                             */
/*   Description  : �繫��-������ �ް���Ȳ ������ �������� RFC�� ȣ���ϴ� Class       */
/*   Note         :                                                             */
/*   Creation     : 2018-05-18 ��ȯ�� [WorkTime52] �����ް� �߰� �� 				*/
/*   Update       :  															*/
/********************************************************************************/
package	hris.D.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D04VocationDetailOfficeRFC.java
 * [WorkTime52] �繫��-������ �ް���Ȳ ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author ��ȯ��
 * @version 1.0, 2018/05/18
 */
public class D04VocationDetailOfficeRFC extends SAPWrap {

	 private String functionName = "ZGHR_RFC_NTM_HOLIDAY_DISPLAY";

    /**
     * �繫��-������ �ް���Ȳ ������ �������� RFC�� ȣ���ϴ� Method<br/>
     * <br/>
     * 0 : E_NON_ABSENCE(���ٿ�����)<br/>
     * 1 : E_LONG_SERVICE(�ټӳ�����)<br/>
     * 2 : E_FLEXIBLE(�����ް���)<br/>
     * 3 : T_OCCUR_RESULT(�ް��߻�)<br/>
     * 4 : T_USED_RESULT(�ް����)<br/>
     * 5 : T_USED_RESULT1(�ް����-�����ο�)<br/>
     * 6 : T_OCCUR_RESULT1(�ް��߻�-�����ο�)<br/>
     * 7 : T_OCCUR_RESULT2(�ް��߻�-�����������ް�)<br/>
     * 8 : E_COMPTIME(�����ް���)<br/>
     * 9 : T_OCCUR_RESULT3(�ް��߻�-�����ް�)<br/>
     * 10: T_USED_RESULT3(�ް����-�����ް�)
     * 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getVocationDetail(String empNo, String year) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year);
            excute(mConnection, function);

            Vector ret = getExport(function);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * @param function
     * @return
     * @throws GeneralException
     */
    public Vector getExport(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
    	
    	String eNonAbsence = getField("E_NON_ABSENCE", function);		//���ٿ�����
    	String eLongService = getField("E_LONG_SERVICE", function);		//�ټӳ�����
    	String eFlexible = getField("E_FLEXIBLE", function);			//�����ް���
    	String eComptime = getField("E_COMPTIME", function);			//�����ް���
    	Vector tOccurResult = getTable(hris.D.D04VocationDetail3Data.class,  function, "T_OCCUR_RESULT");	//�ް��߻�
    	Vector tUsedResult = getTable(hris.D.D04VocationDetail2Data.class,  function, "T_USED_RESULT");		//�ް����
    	Vector tUsedResult1 = getTable(hris.D.D04VocationDetail2Data.class,  function, "T_USED_RESULT1");	//�ް����-�����ο�
    	Vector tOccurResult1 = getTable(hris.D.D04VocationDetail3Data.class,  function, "T_OCCUR_RESULT1");	//�ް��߻�-�����ο�
    	Vector tOccurResult2 = getTable(hris.D.D04VocationDetail4Data.class,  function, "T_OCCUR_RESULT2");	//�ް��߻�-�����������ް�
    	Vector tOccurResult3 = getTable(hris.D.D04VocationDetail4Data.class,  function, "T_OCCUR_RESULT3");	//�ް��߻�-�����ް�
    	Vector tUsedResult3 = getTable(hris.D.D04VocationDetail2Data.class,  function, "T_USED_RESULT3");	//�ް����-�����ް�
    	
    	ret.addElement(eNonAbsence);
    	ret.addElement(eLongService);
    	ret.addElement(eFlexible);
    	ret.addElement(tOccurResult);
    	ret.addElement(tUsedResult);
    	ret.addElement(tUsedResult1);
    	ret.addElement(tOccurResult1);
    	ret.addElement(tOccurResult2);
    	ret.addElement(eComptime);
    	ret.addElement(tOccurResult3);
    	ret.addElement(tUsedResult3);
    	
    	return ret;
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value, String value1) throws GeneralException {
        String fieldName  = "I_PERNR";
        String fieldName1 = "I_YEAR";
        setField(function, fieldName, value);
        setField(function, fieldName1, value1);

    }

}